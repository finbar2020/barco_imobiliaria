import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:morar/feature/agreements/domain/entity/agreement.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_quotas.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';

abstract class AgreementsState extends Equatable {
  const AgreementsState();

  @override
  List<Object?> get props => [];
}

class AgreementsInitialState extends AgreementsState {
  const AgreementsInitialState();
}

class AgreementsLoadingState extends AgreementsState {
  const AgreementsLoadingState();
}

class AgreementsQuotaInitialState extends AgreementsState {
  const AgreementsQuotaInitialState();
}

class AgreementsQuotaLoadingState extends AgreementsState {
  const AgreementsQuotaLoadingState();
}

class AgreementsErrorState extends AgreementsState {
  final String errorMessageKey;

  const AgreementsErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class AgreementsQuotaErrorState extends AgreementsState {
  final String errorMessageKey;

  const AgreementsQuotaErrorState({required this.errorMessageKey});

  @override
  List<Object?> get props => [errorMessageKey];
}

class AgreementsQuotaAvailableLoadedState extends AgreementsState {
  final List<AgreementQuota> agreementsQuotaAvailable;
  final List<Agreement> agreements;
  List<bool> checkList;

  AgreementsQuotaAvailableLoadedState({
    required this.agreementsQuotaAvailable,
    required this.agreements,
    required this.checkList,
  });

  @override
  List<Object?> get props => [agreementsQuotaAvailable, agreements, checkList];
}

class AgreementsChoiceLoadedState extends AgreementsState {
  final List<AgreementPaymentMethod> agreementPaymentMethod;

  const AgreementsChoiceLoadedState({
    required this.agreementPaymentMethod,
  });

  @override
  List<Object?> get props => [agreementPaymentMethod];
}

class AgreementsRecommendationLoadedState extends AgreementsState {
  final List<AgreementRecommendationPayment> optionsPayments;

  const AgreementsRecommendationLoadedState({
    required this.optionsPayments,
  });

  @override
  List<Object?> get props => [optionsPayments];
}

class AgreementsPaydayLoadedState extends AgreementsState {
  final List<String> days;
  List<bool> checkList;

  AgreementsPaydayLoadedState({
    required this.days,
    required this.checkList,
  });

  @override
  List<Object?> get props => [days, checkList];
}

class AgreementsInstallmentLoadedState extends AgreementsState {
  final List<AgreementInstallmentCredit> installments;

  const AgreementsInstallmentLoadedState({
    required this.installments,
  });

  @override
  List<Object?> get props => [installments];
}

class PostAgreementLoadedState extends AgreementsState {
  final bool creditCard;
  final Agreement agreement;

  const PostAgreementLoadedState({
    required this.creditCard,
    required this.agreement,
  });

  @override
  List<Object?> get props => [creditCard, agreement];
}

class PostPendingProposalLoadedState extends AgreementsState {
  const PostPendingProposalLoadedState();
}

class AgreementDetailLoadedState extends AgreementsState {
  final Agreement agreement;

  const AgreementDetailLoadedState({
    required this.agreement,
  });

  @override
  List<Object?> get props => [agreement];
}

class AgreementBilletLoadedState extends AgreementsState {
  final File billet;

  const AgreementBilletLoadedState({
    required this.billet,
  });

  @override
  List<Object?> get props => [billet];
}
