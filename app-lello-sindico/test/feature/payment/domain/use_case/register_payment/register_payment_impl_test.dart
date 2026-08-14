import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/entity/payment_status.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment.dart';
import 'package:lello/feature/payment/domain/use_case/list_payment/list_payment_impl.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment.dart';
import 'package:lello/feature/payment/domain/use_case/register_payment/register_payment_impl.dart';
import 'package:mockito/mockito.dart';

import '../../../../../matcher/is_and_matcher.dart';

void main() {
  PaymentRepository repository;
  RegisterPayment registerPayment;

  final _payment = Payment()
    ..supplierIdentification = "1"
    ..supplierName = "1"
    ..documentNumber = "1"
    ..totalValue = 1
    ..expirationDate = DateTime.now()
    ..paymentHistory = "1"
    ..accountId = "1"
    ..accountName = "1"
    ..hasInstallments = false
    ..equalInstallments = false
    ..installments = []
    ..paymentMethod = "1"
    ..observation = "1";

  final _condominiumId = "3";
  final param =
      RegisterPaymentParams(condominiumId: _condominiumId, payment: _payment);
  setUp(() {
    repository = PaymentRepositoryMock();
    registerPayment = RegisterPaymentImpl(repository: repository);
  });

  group('call', () {
    group('with invalid parameters', () {
      test('Should return rejection with expected failure if param is null',
          () async {
        final result = await registerPayment.call(null);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });
    });

    test('Should call repository list method', () async {
      when(repository.insert(any, any))
          .thenAnswer((_) async => Success(_payment));
      await registerPayment.call(param);
      verify(repository.insert(_condominiumId, _payment));
    });

    test('Should return success if repository succeeds', () async {
      when(repository.insert(any, any))
          .thenAnswer((_) async => Success(_payment));
      final result = await registerPayment.call(param);
      expect(result, IsAnd<Success<Payment>>((it) => it.get() == _payment));
    });

    test('Should return rejection if repository fails', () async {
      when(repository.insert(any, any))
          .thenAnswer((_) async => Rejection(UnknownFailure(null)));
      final result = await registerPayment.call(param);
      expect(result,
          IsAnd<Rejection<Payment>>((it) => it.get() is UnknownFailure));
    });
  });
}

class PaymentRepositoryMock extends Mock implements PaymentRepository {}
