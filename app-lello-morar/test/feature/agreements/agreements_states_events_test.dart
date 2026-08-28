import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_created.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_installment_credit.dart';
import 'package:morar/feature/agreements/domain/entity/agreement_payment_method.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_payment_method_enum.dart';
import 'package:morar/feature/agreements/domain/entity/agreements_recommendatio_payment.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_event.dart';
import 'package:morar/feature/agreements/presentation/bloc/agreements_state.dart';

import 'agreements_test_support.dart';

void main() {
  group('estados', () {
    test('estados sem dados são iguais entre instâncias', () {
      expect(const AgreementsInitialState().props, isEmpty);
      // ignore: prefer_const_constructors
      expect(AgreementsLoadingState(), AgreementsLoadingState());
      // ignore: prefer_const_constructors
      expect(AgreementsQuotaInitialState(), AgreementsQuotaInitialState());
      // ignore: prefer_const_constructors
      expect(AgreementsQuotaLoadingState(), AgreementsQuotaLoadingState());
      // ignore: prefer_const_constructors
      expect(PostPendingProposalLoadedState(), PostPendingProposalLoadedState());
    });

    test('estados com dados expõem os props', () {
      final quota = testQuota();
      final agreement = testAgreement();
      final method = AgreementPaymentMethod(
        type: AgreementPaymentMethodEnum.billet,
        enabled: true,
        text: 't',
        description: 'd',
        disabledDescription: 'dd',
      );
      final recommendation = AgreementRecommendationPayment(installmentQtd: 1, recomendation: true);
      final credit = AgreementInstallmentCredit(
        billetValue: 1,
        installmentQtd: 1,
        totalValue: 1,
        installmentValue: 1,
      );

      expect(const AgreementsQuotaErrorState(errorMessageKey: 'e').props, ['e']);
      expect(
        AgreementsQuotaAvailableLoadedState(
          agreementsQuotaAvailable: [quota],
          agreements: [agreement],
          checkList: [false],
        ).props,
        [
          [quota],
          [agreement],
          [false]
        ],
      );
      expect(AgreementsChoiceLoadedState(agreementPaymentMethod: [method]).props, [
        [method]
      ]);
      expect(AgreementsRecommendationLoadedState(optionsPayments: [recommendation]).props, [
        [recommendation]
      ]);
      expect(AgreementsPaydayLoadedState(days: ['5'], checkList: [true]).props, [
        ['5'],
        [true]
      ]);
      expect(AgreementsInstallmentLoadedState(installments: [credit]).props, [
        [credit]
      ]);
      expect(PostAgreementLoadedState(creditCard: true, agreement: agreement).props, [true, agreement]);
      expect(AgreementDetailLoadedState(agreement: agreement).props, [agreement]);
      final file = File('x.pdf');
      expect(AgreementBilletLoadedState(billet: file).props, [file]);
    });
  });

  group('eventos', () {
    test('expõem os props', () {
      expect(const AgreementsGetQuotaAvailableEvent().props, isEmpty);
      expect(const AgreementsGetChoicesPaymentEvent().props, isEmpty);
      expect(const AgreementsGetRecommendationPaymentEvent().props, isEmpty);
      expect(const AgreementsGetPaydayEvent().props, isEmpty);
      expect(const GoToRecommendationPaymentEvent().props, isEmpty);
      expect(const GoToAgreementstEvent().props, isEmpty);
      expect(const GoToInstallmentEvent().props, isEmpty);
      expect(const AgreementsGetInstallmentEvent(totalValue: 2).props, [2.0]);
      expect(const AgreementsDetailsEvent(agreementId: 'a').props, ['a']);
      expect(const GetAgreementBilletEvent(installmentId: 'i').props, ['i']);
      final created = AgreementCreated();
      expect(
        PostAgreementEvent(agreement: created, pendingProposal: true, creditCard: false).props,
        [created, true, false],
      );
      // ignore: prefer_const_constructors
      expect(AgreementsGetPaydayEvent(), AgreementsGetPaydayEvent());
    });
  });
}
