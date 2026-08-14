import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/data_origin.dart';
import 'package:essentials/enum/enum_serializer.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/feature/resin/domain/entity/resin_action_enum.dart';
import 'package:lello/feature/resin/domain/entity/resin_advances_steps_enum.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/domain/use_case/create_resin_refund/create_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/delete_resin_bank_account/delete_resin_bank_account.dart';
import 'package:lello/feature/resin/domain/use_case/edit_resin_refund/edit_resin_refund.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_bank_accounts/get_resin_bank_accounts.dart';
import 'package:lello/feature/resin/domain/use_case/get_resin_check_max_value/get_resin_check_max_value.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_bloc.dart';
import 'package:lello/feature/resin/presentation/resin_new_advance/bloc/resin_new_advance_event.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';

class ResinNewAdvanceController {
  final ResinNewAdvanceBloc bloc;
  final SessionBloc sessionBloc;
  final GetResinBankAccounts getResinBankAccountsUseCase;
  final DeleteResinBankAccount deleteResinBankAccountUseCase;
  final CreateResinRefund createResinRefundUseCase;
  final EditResinRefund editResinRefund;
  final GetResinCheckMaxValueUsecase checkMaxValueUsecase;

  ResinAdvancesStepsEnum currentStep = ResinAdvancesStepsEnum.bankAccount;

  ResinActionEnum _action = ResinActionEnum.create;

  List<ResinBankAccount> resinBankAccounts = [];

  late ResinRefund resinRefund;

  ResinNewAdvanceController({
    required this.bloc,
    required this.sessionBloc,
    required this.getResinBankAccountsUseCase,
    required this.deleteResinBankAccountUseCase,
    required this.createResinRefundUseCase,
    required this.editResinRefund,
    required this.checkMaxValueUsecase,
  }) {
    resinRefund = ResinRefund(
        value: 0.00,
        receipts: [],
        status: ResinRefundStatus.sended,
        type: ResinRefundType.advance,
        requesterId: sessionBloc.state.session?.me?.id ?? "",
        requestDate: DateTime.now(),
        requester: sessionBloc.state.session?.me?.name ?? "");
  }

  void changeStep(ResinAdvancesStepsEnum step) {
    currentStep = step;
  }

  void setUpBloc(ResinRefund? refund) {
    if (refund == null) {
      return;
    }
    if (resinRefund.id != refund.id) {
      _action = ResinActionEnum.edit;
      resinRefund = refund;
      resinRefund.requesterId = sessionBloc.state.session?.me?.id ?? "";
      changeStep(ResinAdvancesStepsEnum.valueDescription);
    }
  }

  void postRefund(ResinRefund refund) {
    switch (_action) {
      case ResinActionEnum.create:
        createRefund(refund);
        break;
      case ResinActionEnum.edit:
        editRefund(refund);
        break;
    }
  }

  getBankAccounts() async {
    bloc.add(ResinNewAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //buscaCache
    final responseCache = await getResinBankAccountsUseCase.call(
      GetResinBankAccountsParams(
        condominiumId: condominiumId,
        origin: DataOrigin.local,
      ),
    );
    responseCache.fold(
      (error) => bloc.add(ResinNewAdvanceLoadingEvent()),
      (data) {
        resinBankAccounts = data;
        bloc.add(ResinNewAdvanceLoadedEvent(
            bankAccounts: data, loadingRemote: true));
      },
    );

    //buscaRemote
    final responseRemote = await getResinBankAccountsUseCase.call(
      GetResinBankAccountsParams(
        condominiumId: condominiumId,
        origin: DataOrigin.remote,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(
          ResinNewAdvanceErrorEvent(errorMessageKey: "resin_get_params_error")),
      (data) {
        resinBankAccounts = data;
        resinBankAccounts = data;
        bloc.add(ResinNewAdvanceLoadedEvent(bankAccounts: data));
      },
    );
  }

  deleteBankAccount(ResinBankAccount bankAccount) async {
    bloc.add(ResinNewAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //remote
    final responseRemote = await deleteResinBankAccountUseCase.call(
      DeleteResinBankAccountParams(
        condominiumId: condominiumId,
        accountId: bankAccount.id,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(ResinNewAdvanceLoadedEvent(
          bankAccounts: resinBankAccounts,
          flushbarMessageKey: "resin_delete_bank_account_error")),
      (data) {
        resinBankAccounts.remove(bankAccount);
        bloc.add(ResinNewAdvanceLoadedEvent(
            bankAccounts: resinBankAccounts,
            flushbarMessageKey: "resin_delete_bank_account_success"));
      },
    );
  }

  createRefund(ResinRefund refund) async {
    bloc.add(ResinNewAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //remote
    final responseRemote = await createResinRefundUseCase.call(
      CreateResinRefundParams(
        condominiumId: condominiumId,
        refund: refund,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(ResinNewAdvanceErrorEvent(
          errorMessageKey: "resin_review_data_advance_error")),
      (data) {
        ManagerAnalyticsLogEvents.logEvent(
            event: AnalyticsEventsManager.solicitarAdiantamentoFinalizado(),
            referenceValue:
                sessionBloc.state.session?.selectedCondominium?.reference ??
                    "");
        bloc.add(ResinNewAdvanceSuccessEvent(refund));
      },
    );
    bloc.add(ResinNewAdvanceLoadedEvent(bankAccounts: resinBankAccounts));
  }

  editRefund(ResinRefund refund) async {
    bloc.add(ResinNewAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    //remote
    final responseRemote = await editResinRefund.call(
      EditResinRefundParams(
        condominiumId: condominiumId,
        refund: refund,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(ResinNewAdvanceErrorEvent(
          errorMessageKey: "resin_review_data_advance_error")),
      (data) {
        bloc.add(ResinNewAdvanceSuccessEvent(refund));
      },
    );
    bloc.add(ResinNewAdvanceLoadedEvent(bankAccounts: resinBankAccounts));
  }

  checkMaxValues(ResinRefund refund) async {
    bloc.add(ResinNewAdvanceLoadingEvent());

    String condominiumId =
        sessionBloc.state.session?.selectedCondominium?.id ?? "";

    final responseRemote = await checkMaxValueUsecase.call(
      GetResinCheckMaxValueParams(
        condominiumId: condominiumId,
        type: enumToString(refund.type)!,
        value: refund.value,
      ),
    );

    responseRemote.fold(
      (error) => bloc.add(ResinNewAdvanceLoadedEvent(
          bankAccounts: resinBankAccounts,
          flushbarMessageKey: "resin_review_data_refund_error")),
      (data) {
        bloc.add(ResinCheckValuesSuccessEvent(checkMaxValueParam: data));
      },
    );
  }
}
