import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode.dart';
import 'package:lello/feature/payment/domain/use_case/find_payment_by_barcode/find_payment_by_barcode_impl.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment.dart';
import 'package:lello/feature/payment/domain/use_case/get_payment/get_payment_impl.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../../matcher/is_and_matcher.dart';

void main() {
  PaymentRepository repository;
  FindPaymentByBarcode findByBarcode;

  setUp(() {
    repository = PaymentRepositoryMock();
    findByBarcode = FindPaymentByBarcodeImpl(repository: repository);
  });
  final validParam =
      FindPaymentByBarcodeParam(condominiumId: "1", barcode: "2");

  group('call', () {
    group('With invalid params', () {
      test('Should return rejection with expected failure if params is null',
          () async {
        final result = await findByBarcode(null);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if condominium id is null',
          () async {
        final param =
            FindPaymentByBarcodeParam(condominiumId: null, barcode: "2");
        final result = await findByBarcode(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test(
          'Should return rejection with expected failure if condominium id is empty',
          () async {
        final param =
            FindPaymentByBarcodeParam(condominiumId: "", barcode: "2");
        final result = await findByBarcode(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection with expected failure if supplier is null',
          () async {
        final param =
            FindPaymentByBarcodeParam(condominiumId: "1", barcode: null);
        final result = await findByBarcode(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });

      test('Should return rejection with expected failure if supplier is empty',
          () async {
        final param =
            FindPaymentByBarcodeParam(condominiumId: "1", barcode: "");
        final result = await findByBarcode(param);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is InvalidParamFailure));
      });
    });

    group('With valid params', () {
      test('Should call repository find', () async {
        when(repository.findByBarcode(any, any))
            .thenAnswer((_) async => Success(null));
        await findByBarcode(validParam);
        verify(repository.findByBarcode(
            validParam.condominiumId, validParam.barcode));
      });

      test('Should return success if repository succeeds', () async {
        final payment = Payment();
        when(repository.findByBarcode(
                validParam.condominiumId, validParam.barcode))
            .thenAnswer((_) async => Success(payment));
        final result = await findByBarcode(validParam);
        expect(result, IsAnd<Success<Payment>>((it) => it.get() == payment));
      });

      test('Should return rejection if repository fails', () async {
        when(repository.findByBarcode(
                validParam.condominiumId, validParam.barcode))
            .thenAnswer((_) async => Rejection(UnknownFailure(null)));
        final result = await findByBarcode(validParam);
        expect(result,
            IsAnd<Rejection<Payment>>((it) => it.get() is UnknownFailure));
      });
    });
  });
}

class PaymentRepositoryMock extends Mock implements PaymentRepository {}
