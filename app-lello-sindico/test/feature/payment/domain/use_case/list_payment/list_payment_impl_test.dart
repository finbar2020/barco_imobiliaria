import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/entity/payment_status.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  PaymentRepository repository;
  ListPayment listPayment;

  setUp(() {
    repository = PaymentRepositoryMock();
    listPayment = ListPaymentImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should return rejection with expected failure if param is null',
          () async {
        final result = await listPayment.call(null);
        expect(
            result,
            IsAnd<Rejection<List<Payment>>>(
                (it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if condominium is null',
          () async {
        final param = ListPaymentParam(condominiumId: null);
        final result = await listPayment.call(param);
        expect(
            result,
            IsAnd<Rejection<List<Payment>>>(
                (it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list method', () async {
      when(repository.list(any,
              status: null, filter: null, lastPaymentId: null))
          .thenAnswer((_) async => Success([]));
      final param = ListPaymentParam(
          condominiumId: "2",
          status: "Aprovado",
          filter: PaymentListFilter(),
          lastRegistrationId: "1");
      await listPayment.call(param);
      verify(repository.list(param.condominiumId,
          status: param.status,
          filter: param.filter,
          lastPaymentId: param.lastRegistrationId));
    });

    test('Should return success if repository succeeds', () async {
      final List<Payment> data = [Payment()];
      when(repository.list(
        any,
      )).thenAnswer((_) async => Success(data));
      final param = ListPaymentParam(condominiumId: "2");
      final result = await listPayment.call(param);
      expect(result, IsAnd<Success<List<Payment>>>((it) => it.get() == data));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.list(any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final param = ListPaymentParam(condominiumId: "2");
      final result = await listPayment.call(param);
      expect(result,
          IsAnd<Rejection<List<Payment>>>((it) => it.get() is UnknownFailure));
    });
  });
}

class PaymentRepositoryMock extends Mock implements PaymentRepository {}
