import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  PaymentRepository repository;
  GetPayment getPaymentRegistration;

  setUp(() {
    repository = PaymentRepositoryMock();
    getPaymentRegistration = GetPaymentImpl(repository: repository);
  });
  final validParam = GetPaymentParam(
      condominiumId: "1", supplierIdentification: "2", documentNumber: "3");

  group('call', () {
    group('With invalid params', () {
      test('Should return rejection with expected failure if params is null',
          () async {
        final result = await getPaymentRegistration(null);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if condominium id is null',
          () async {
        final param = GetPaymentParam(
            condominiumId: null,
            supplierIdentification: "1",
            documentNumber: "1");
        final result = await getPaymentRegistration(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if condominium id is empty',
          () async {
        final param = GetPaymentParam(
            condominiumId: "",
            supplierIdentification: "1",
            documentNumber: "1");
        final result = await getPaymentRegistration(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection with expected failure if supplier is null',
          () async {
        final param = GetPaymentParam(
            condominiumId: "1",
            supplierIdentification: null,
            documentNumber: "1");
        final result = await getPaymentRegistration(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection with expected failure if supplier is empty',
          () async {
        final param = GetPaymentParam(
            condominiumId: "1",
            supplierIdentification: null,
            documentNumber: "1");
        final result = await getPaymentRegistration(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if documentNumber is null',
          () async {
        final param = GetPaymentParam(
            condominiumId: "1",
            supplierIdentification: "1",
            documentNumber: null);
        final result = await getPaymentRegistration(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if documentNumber is empty',
          () async {
        final param = GetPaymentParam(
            condominiumId: "1",
            supplierIdentification: "1",
            documentNumber: "");
        final result = await getPaymentRegistration(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });
    });

    group('With valid params', () {
      test('Should call repository find', () async {
        when(repository.find(any, any, any))
            .thenAnswer((_) async => Success(null));
        await getPaymentRegistration(validParam);
        verify(repository.find(validParam.condominiumId,
            validParam.supplierIdentification, validParam.documentNumber));
      });

      test('Should return success if repository succeeds', () async {
        final registration = Payment();
        when(repository.find(validParam.condominiumId,
                validParam.supplierIdentification, validParam.documentNumber))
            .thenAnswer((_) async => Success(registration));
        final result = await getPaymentRegistration(validParam);
        expect(
            result, IsAnd<Success<Payment>>((it) => it.get() == registration));
      });

      test('Should return rejection if repository fails', () async {
        when(repository.find(validParam.condominiumId,
                validParam.supplierIdentification, validParam.documentNumber))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await getPaymentRegistration(validParam);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is UnknownFailure));
      });
    });
  });
}

class PaymentRepositoryMock extends Mock implements PaymentRepository {}
