import 'dart:async';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_all_info.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_rule.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';
import 'package:morar/feature/agreements/domain/use_case/get_all_info/get_all_info.dart';
import 'package:morar/feature/agreements/domain/use_case/get_detail/get_detail.dart';
import 'package:morar/feature/agreements/domain/use_case/get_installment_credit/get_installment_credit.dart';
import 'package:morar/feature/agreements/domain/use_case/get_payday/get_payday.dart';
import 'package:morar/feature/agreements/domain/use_case/get_recommendation/get_recommendation.dart';
import 'package:morar/feature/agreements/domain/use_case/post_agreement/post_agreement.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_event.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';

import '../../domain/entity/agreements_quotas.dart';

class AgreementsBloc extends Bloc<AgreementsEvent, AgreementsState> {
  final SessionBloc sessionBloc;
  final GetAvailableUseCase getAvailableUseCase;
  final GetRecommendationUseCase getRecommendationUseCase;
  final GetPaydayUseCase getPaydayUseCase;
  final GetInstallmentCreditUseCase getInstallmentCreditUseCase;
  final PostAgreementUseCase postAgreementUseCase;
  final GetAgreementDetailUseCase getAgreementDetailUseCase;
  final baseUrl;

  StreamSubscription? _subscription;

  AgreementAllInfo agreementAllInfo = AgreementAllInfo(
    agreements: [],
    quotes: [],
    rule: AgreementRule(
      installmentQtd: 0,
      days: [],
      paymentMethod: [],
    ),
  );
  List<AgreementPaymentMethod> agreementPaymentMethod = [];
  List<AgreementInstallmentCredit> installments = [];
  List<AgreementRecommendationPayment> agreementRecommendation = [];
  List<String> days = [];
  List<AgreementQuota>? quotasFromParam;
  AgreementRule? ruleFromParam;
  bool isFirstMadeCall = false;

  AgreementsBloc({
    required this.sessionBloc,
    required this.getAvailableUseCase,
    required this.getRecommendationUseCase,
    required this.getPaydayUseCase,
    required this.getInstallmentCreditUseCase,
    required this.postAgreementUseCase,
    required this.getAgreementDetailUseCase,
    required this.baseUrl,
  }) : super(const AgreementsInitialState()) {
    on<AgreementsGetQuotaAvailableEvent>(_mapGetQuotaAvailable);
    on<AgreementsGetChoicesPaymentEvent>(_mapGetChoicePayment);
    on<AgreementsGetRecommendationPaymentEvent>(_mapRecommendation);
    on<GoToRecommendationPaymentEvent>(_mapGoToRecommendation);
    on<AgreementsGetPaydayEvent>(_mapGetPayday);
    on<AgreementsGetInstallmentEvent>(_mapGetInstallments);
    on<GoToInstallmentEvent>(_mapGoToInstallments);
    on<PostAgreementEvent>(_mapPostAgreement);
    on<GoToAgreementstEvent>(_mapGoToAgreements);
    on<AgreementsDetailsEvent>(_mapDetails);
    if (this.sessionBloc.state is SessionLoadedState) {
      _onSessionChanged(this.sessionBloc.state);
    } else {
      _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
    }
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      add(const AgreementsGetQuotaAvailableEvent());
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  Future<void> _mapGetQuotaAvailable(
    AgreementsGetQuotaAvailableEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(const AgreementsQuotaLoadingState());
    if (quotasFromParam != null && ruleFromParam != null) {
      List<bool> list = [];

      if (quotasFromParam!.isNotEmpty) {
        list = List.generate(quotasFromParam!.length, (index) => false);
      }
      emit(AgreementsQuotaAvailableLoadedState(
        agreementsQuotaAvailable: quotasFromParam!,
        agreements: [],
        checkList: list,
      ));
      quotasFromParam = null;
      ruleFromParam = null;
      return;
    }
    final response = await getAvailableUseCase.call(GetAvailableParams(
      condoId: sessionBloc.state.session!.condominium!.id!,
      unitTitle: sessionBloc.state.session!.unity!.title!,
    ));

    emit(response.fold((error) {
      String messageKey = "request_fine_error_message";
      if (error is KnownFailure && error.code != null) {
        messageKey = error.code!;
      }
      return AgreementsQuotaErrorState(errorMessageKey: messageKey);
    }, (data) {
      List<bool> list = [];
      agreementAllInfo = data;
      if (data.quotes.isNotEmpty) {
        list = List.generate(data.quotes.length, (index) => false);
      }
      agreementPaymentMethod = data.rule.paymentMethod;
      if (data.agreements.isNotEmpty) {
        List.generate(data.agreements.length,
            (index) => data.agreements[index].baseUrl = baseUrl);
      }
      return AgreementsQuotaAvailableLoadedState(
        agreementsQuotaAvailable: agreementAllInfo.quotes,
        agreements: agreementAllInfo.agreements,
        checkList: list,
      );
    }));
  }

  Future<void> _mapGetChoicePayment(
    AgreementsGetChoicesPaymentEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(AgreementsChoiceLoadedState(
      agreementPaymentMethod: agreementPaymentMethod,
    ));
  }

  Future<void> _mapRecommendation(
    AgreementsGetRecommendationPaymentEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(const AgreementsLoadingState());
    final response = await getRecommendationUseCase.call(
        GetRecommendationParams(
            condoId: sessionBloc.state.session!.condominium!.id!));

    emit(response.fold(
        (error) => const AgreementsErrorState(
            errorMessageKey: "request_fine_error_message"),
        (data) {
      agreementRecommendation = data;
      return AgreementsRecommendationLoadedState(
        optionsPayments: data,
      );
    }));
  }

  Future<void> _mapGetPayday(
    AgreementsGetPaydayEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(const AgreementsLoadingState());
    final response = await getPaydayUseCase.call(
        GetPaydayParams(condoId: sessionBloc.state.session!.condominium!.id!));

    emit(response.fold(
        (error) => const AgreementsErrorState(
            errorMessageKey: "request_fine_error_message"),
        (data) {
      days = data;
      List<bool> list = [];
      if (data.isNotEmpty) {
        list = List.generate(data.length, (index) => false);
      }
      return AgreementsPaydayLoadedState(
        days: data,
        checkList: list,
      );
    }));
  }

  Future<void> _mapGetInstallments(
    AgreementsGetInstallmentEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(const AgreementsLoadingState());
    final response =
        await getInstallmentCreditUseCase.call(GetInstallmentParams(
      condoId: sessionBloc.state.session!.condominium!.id!,
      totalValue: event.totalValue,
    ));

    emit(response.fold(
        (error) => const AgreementsErrorState(
            errorMessageKey: "request_fine_error_message"),
        (data) {
      installments = data;
      return AgreementsInstallmentLoadedState(installments: data);
    }));
  }

  Future<void> _mapPostAgreement(
    PostAgreementEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(const AgreementsLoadingState());
    event.agreement.unit = sessionBloc.state.session!.unity!.title!;
    event.agreement.reference = int.tryParse(
            sessionBloc.state.session!.condominium?.reference ?? '') ??
        event.agreement.reference;
    event.agreement.email = sessionBloc.state.session?.me?.email;
    event.agreement.phone = sessionBloc.state.session?.me?.phone;
    final response = await postAgreementUseCase.call(PostAgreementParams(
        condoId: sessionBloc.state.session!.condominium!.id!,
        body: event.agreement));

    emit(response.fold(
        (error) => const AgreementsErrorState(
            errorMessageKey: "request_fine_error_message"),
        (data) {
      data.baseUrl = baseUrl;
      OwnerAnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.acordosFinalizarAcordoSucesso(),
          userId: sessionBloc.state.session?.me?.id ?? "",
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          otherParameters: {
            "metodo_pagamento": event.agreement.paymentMethod.toString(),
            "parcelas": event.agreement.installmentQuantity.toString(),
          });
      return data.isPending
          ? const PostPendingProposalLoadedState()
          : PostAgreementLoadedState(
              creditCard: event.creditCard,
              agreement: data,
            );
    }));
  }

  Future<void> _mapDetails(
    AgreementsDetailsEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(const AgreementsLoadingState());
    final response = await getAgreementDetailUseCase.call(
        GetAgreementDetailParams(
            condoId: sessionBloc.state.session!.condominium!.id!,
            agreementId: event.agreementId));

    emit(response.fold(
        (error) => const AgreementsErrorState(
            errorMessageKey: "request_fine_error_message"),
        (data) {
      OwnerAnalyticsLogEvents.logEvent(
          userId: sessionBloc.state.session?.me?.id ?? "",
          event: AnalyticsEventsOwner.acordosAcessarAcordosEmAndamento(),
          unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
          referenceValue:
              sessionBloc.state.session!.condominium?.reference?.toString() ??
                  "",
          otherParameters: {
            "id_acordo": event.agreementId,
          });
      return AgreementDetailLoadedState(agreement: data);
    }));
  }

  Future<void> _mapGoToRecommendation(
    GoToRecommendationPaymentEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(AgreementsRecommendationLoadedState(
      optionsPayments: agreementRecommendation,
    ));
  }

  Future<void> _mapGoToAgreements(
    GoToAgreementstEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    List<bool> list = [];
    if (agreementAllInfo.quotes.isNotEmpty) {
      list = List.generate(agreementAllInfo.quotes.length, (index) => false);
    }
    emit(AgreementsQuotaAvailableLoadedState(
      agreementsQuotaAvailable: agreementAllInfo.quotes,
      agreements: agreementAllInfo.agreements,
      checkList: list,
    ));
  }

  Future<void> _mapGoToInstallments(
    GoToInstallmentEvent event,
    Emitter<AgreementsState> emit,
  ) async {
    emit(AgreementsInstallmentLoadedState(installments: installments));
  }

  void goToInstallments() {
    add(const GoToInstallmentEvent());
  }

  void getRecommendation() {
    add(const AgreementsGetRecommendationPaymentEvent());
  }

  void goToRecommendation() {
    add(const GoToRecommendationPaymentEvent());
  }

  void getPayday() {
    add(const AgreementsGetPaydayEvent());
  }

  void getChoicePayment() {
    add(const AgreementsGetChoicesPaymentEvent());
  }

  void getInstallments(double totalValue) {
    add(AgreementsGetInstallmentEvent(totalValue: totalValue));
  }

  void postAgreement(
    AgreementCreated agreement,
    bool pendingProposal,
    bool creditCard,
  ) {
    add(PostAgreementEvent(
      agreement: agreement,
      pendingProposal: pendingProposal,
      creditCard: creditCard,
    ));
  }

  void goToAgreements(AgreementCreated agreement, {bool reload = true}) {
    agreement.totalValue = 0;
    if (reload) {
      add(const AgreementsGetQuotaAvailableEvent());
    } else {
      add(const GoToAgreementstEvent());
    }
  }

  void getDetails({required String agreementId}) {
    add(AgreementsDetailsEvent(agreementId: agreementId));
  }

  void getQuotaAvailable() {
    add(const AgreementsGetQuotaAvailableEvent());
  }
}
