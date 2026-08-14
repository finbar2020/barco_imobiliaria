import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_event.dart';

import '../../../../core/analytics/analytics_log_events.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entity/agreement.dart';
import '../../domain/entity/agreement_analysis/agreements_analysis.dart';
import '../../domain/entity/agreement_update_status.dart';
import '../../domain/entity/agreements_all_info.dart';
import '../../domain/entity/agreements_filter_sort.dart';
import '../../domain/entity/agreements_history.dart';
import '../../domain/entity/agreements_in_progress.dart';
import '../../domain/entity/agreements_proposals.dart';
import '../../domain/entity/agreements_rules.dart';
import '../../domain/entity/payment_method.dart';
import '../../domain/use_case/agreement_update_status_use_case.dart';
import '../../domain/use_case/change_rules_use_case.dart';
import '../../domain/use_case/get_all_agreements_info_use_case.dart';
import '../../domain/use_case/get_analysis_use_case.dart';
import '../../domain/use_case/get_rules_use_case.dart';
import '../bloc/agreements_bloc.dart';
import '../bloc/agreements_state.dart';

class AgreementsController {
  final SessionBloc sessionBloc;
  final AgreementsBloc agreementsBloc;
  final GetAnalysisUseCase getAnalysisUseCase;
  final GetAllAgreementsInfoUseCase getAllAgreementsInfoUseCase;
  final GetRulesUseCase getRulesUseCase;
  final AgreementUpdateStatusUseCase agreementUpdateStatusUseCase;
  final ChangeRulesUseCase changeRulesUseCase;

  String searchText = "";

  Agreement? agreement;

  AgreementsAnalysis? agreementsAnalysis;
  AgreementsAllInfo? agreementsAllInfo;
  AgreementsProposals? agreementsProposals;
  AgreementsInProgress? agreementsInProgress;
  AgreementsHistory? agreementsHistory;
  AgreementsRules? agreementsRules;

  String? filterUnitOrName;
  String? filterPaymentMethodKey;
  String? sortNameKey;
  String? sortUnitKey;
  String? sortDueDateKey;
  String? sortProposalDateKey;

  List<Agreement> agreements = [];

  AgreementsController({
    required this.sessionBloc,
    required this.agreementsBloc,
    required this.getAnalysisUseCase,
    required this.getAllAgreementsInfoUseCase,
    required this.getRulesUseCase,
    required this.agreementUpdateStatusUseCase,
    required this.changeRulesUseCase,
  });

  Future<void> pipeline() async {
    await getAllInformation();
  }

  Future<void> getAnalysis({DateTime? fromDate}) async {
    DateTime? toDate;
    if (fromDate != null) {
      int year = fromDate.year;
      int month = fromDate.month;
      if (fromDate.month == 12) {
        month = 1;
        year = year + 1;
      } else {
        month = month + 1;
      }
      toDate = DateTime(year, month, 1);
    }

    final response = await getAnalysisUseCase(
      GetAnalysisParams(
        condominiumId: condominiumId!,
        fromDate: fromDate?.toString() ?? "",
        toDate: toDate?.toString() ?? "",
      ),
    );
    response.fold(
      (error) => AgreementsErrorState(error: error),
      (data) {
        agreementsAnalysis = data;
      },
    );
  }

  Future<void> getAllInformation() async {
    agreementsBloc.add(AgreementsLoadingEvent());
    final response = await getAllAgreementsInfoUseCase(
      GetAllAgreementsInfoParams(
        condominiumId: condominiumId!,
        origin: DataOrigin.remote,
      ),
    );

    response.fold(
      (error) async {
        final resultCache = await getAllAgreementsInfoUseCase(
          GetAllAgreementsInfoParams(
            condominiumId: condominiumId!,
            origin: DataOrigin.local,
          ),
        );
        resultCache.fold(
          (failure) => agreementsBloc.add(AgreementsErrorEvent(error: failure)),
          (info) {
            if (info != null) {
              setAgreementsInfo(allInfo: info);
              agreementsBloc.add(
                AgreementsSuccessEvent(
                  agreements: agreements,
                ),
              );
            } else {
              agreementsBloc.add(
                AgreementsErrorEvent(
                  error: null,
                ),
              );
            }
          },
        );
      },
      (data) {
        if (data != null) {
          setAgreementsInfo(allInfo: data);

          agreementsBloc.add(
            AgreementsSuccessEvent(
              agreements: agreements,
            ),
          );
        } else {
          agreementsBloc
              .add(AgreementsErrorEvent(error: null));
        }
      },
    );
  }

  Future<void> changeRules({required AgreementsRules rules}) async {
    final response = await changeRulesUseCase.call(
      ChangeRulesParams(
        condominiumId: condominiumId!,
        newRules: rules,
      ),
    );
//agreements_rules_change_change_error
    response.fold((error) => AgreementsErrorState(error: error), (data) {
      agreementsRules = data;

      ManagerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.acordosRegrasFinalizado(),
        referenceValue: reference!,
      );
    });
  }

  Future<void> updateStatus({
    required String agreementId,
    required bool approved,
    required String? reason,
  }) async {
    agreementsBloc.add(AgreementsSendingEvent());
    final response = await agreementUpdateStatusUseCase(
      AgreementUpdateStatusParams(
        condominiumId: condominiumId!,
        updateStatus: AgreementUpdateStatus(
          approved: approved,
          agreementId: agreementId,
          reason: reason,
          userName: sessionBloc.state.session!.me!.name!,
        ),
      ),
    );

//agreements_agreement_update_status_error
    response.fold(
      (error) => agreementsBloc.add(
        AgreementsErrorEvent(error: error),
      ),
      (data) {
        ManagerAnalyticsLogEvents.logEvent(
          event: approved
              ? AnalyticsEventsManager.acordosAprovarFinalizado()
              : AnalyticsEventsManager.acordosReprovarFinalizado(),
          referenceValue: reference!,
        );
        agreementsBloc.add(AgreementsApprovalPostedEvent(approved: approved));
      },
    );
  }

  List<Agreement> filterSortList(List<Agreement> agreements) {
    //Filters
    List<Agreement> agreementsFiltered = agreements;

    if (filterUnitOrName != null) {
      agreementsFiltered = agreementsFiltered
          .where((e) => ((e.unit ?? "").contains(filterUnitOrName!) ||
              (e.unitOwner ?? "")
                  .toUpperCase()
                  .contains(filterUnitOrName!.toUpperCase())))
          .toList();
    }
    if (filterPaymentMethodKey != null) {
      if (filterPaymentMethodKey == PaymentMethod.billet) {
        agreementsFiltered = agreementsFiltered
            .where((e) => e.paymentMethod == PaymentMethod.billet)
            .toList();
      } else {
        agreementsFiltered = agreementsFiltered
            .where((e) => e.paymentMethod == PaymentMethod.credit)
            .toList();
      }
    }

    //Sorts
    if (sortNameKey != null) {
      if (sortNameKey == AgreementsFilterSortKeys.nameAtoZ) {
        agreementsFiltered
            .sort((a, b) => (a.unitOwner ?? "").compareTo(b.unitOwner ?? ""));
      }
      if (sortNameKey == AgreementsFilterSortKeys.nameZtoA) {
        agreementsFiltered
            .sort((a, b) => (b.unitOwner ?? "").compareTo(a.unitOwner ?? ""));
      }
    }
    if (sortUnitKey != null) {
      if (sortUnitKey == AgreementsFilterSortKeys.unitCrescent) {
        agreementsFiltered
            .sort((a, b) => (a.unit ?? "").compareTo(b.unit ?? ""));
      }
      if (sortUnitKey == AgreementsFilterSortKeys.unitDecrescent) {
        agreementsFiltered
            .sort((a, b) => (b.unit ?? "").compareTo(a.unit ?? ""));
      }
    }
    if (sortProposalDateKey != null) {
      if (sortProposalDateKey ==
          AgreementsFilterSortKeys.proposalDateCrescent) {
        agreementsFiltered.sort((a, b) =>
            (a.lastInstallmentDate ?? DateTime.now())
                .compareTo(b.lastInstallmentDate ?? DateTime.now()));
      }
      if (sortProposalDateKey ==
          AgreementsFilterSortKeys.proposalDateDecrescent) {
        agreementsFiltered.sort((a, b) =>
            (b.lastInstallmentDate ?? DateTime.now())
                .compareTo(a.lastInstallmentDate ?? DateTime.now()));
      }
    }
    if (sortDueDateKey != null) {
      if (sortDueDateKey == AgreementsFilterSortKeys.dueDateCrescent) {
        agreementsFiltered.sort((a, b) =>
            (a.lastInstallmentDate ?? DateTime.now())
                .compareTo(b.lastInstallmentDate ?? DateTime.now()));
      }
      if (sortDueDateKey == AgreementsFilterSortKeys.dueDateDecrescent) {
        agreementsFiltered.sort((a, b) =>
            (b.lastInstallmentDate ?? DateTime.now())
                .compareTo(a.lastInstallmentDate ?? DateTime.now()));
      }
    }

    return agreementsFiltered;
  }

  void setAgreementsInfo({required AgreementsAllInfo allInfo}) {
    agreementsAllInfo = allInfo;
    agreementsProposals =
        AgreementsProposals(agreements: allInfo.agreementsProposals);
    agreementsInProgress =
        AgreementsInProgress(agreements: allInfo.agreementsInProgress);
    agreementsHistory =
        AgreementsHistory(agreements: allInfo.agreementsHistory);
    agreementsRules = allInfo.rule;
    agreements = allInfo.agreements;
  }

  List<Agreement> get agreementsFiltered {
    final list = filterSortList(
      agreements
          .where(
            (element) =>
                element.unit!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()) ||
                element.unitOwner!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()),
          )
          .toList(),
    );
    agreementsBloc.add(AgreementsSuccessEvent(agreements: list));
    return list;
  }

  List<Agreement> get agreementsHistoryFiltered {
    final list = filterSortList(
      agreementsHistory!.agreements
          .where(
            (element) =>
                element.unit!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()) ||
                element.unitOwner!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()),
          )
          .toList(),
    );
    agreementsBloc.add(AgreementsSuccessEvent(agreements: list));
    return list;
  }

  List<Agreement> get agreementsInProgressFiltered {
    final list = filterSortList(
      agreementsInProgress!.agreements
          .where(
            (element) =>
                element.unit!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()) ||
                element.unitOwner!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()),
          )
          .toList(),
    );
    agreementsBloc.add(AgreementsSuccessEvent(agreements: list));
    return list;
  }

  List<Agreement> get agreementsProposalsFiltered {
    final list = filterSortList(
      agreementsProposals!.agreements
          .where(
            (element) =>
                element.unit!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()) ||
                element.unitOwner!
                    .toUpperCase()
                    .contains(searchText.toUpperCase()),
          )
          .toList(),
    );
    agreementsBloc.add(AgreementsSuccessEvent(agreements: list));
    return list;
  }

  void disposeFilter() {
    filterUnitOrName = null;
    filterPaymentMethodKey = null;
    sortNameKey = null;
    sortUnitKey = null;
    sortDueDateKey = null;
    sortProposalDateKey = null;
  }

  String? get condominiumId =>
      sessionBloc.state.session?.selectedCondominium?.id;

  String? get reference =>
      sessionBloc.state.session?.selectedCondominium?.reference;
}
