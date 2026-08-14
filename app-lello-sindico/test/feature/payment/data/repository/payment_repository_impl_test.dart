import 'package:flutter_test/flutter_test.dart';

import 'package:lello/feature/payment/data/data_source/payment/payment_remote_data_source.dart';
import 'package:lello/feature/payment/data/model/payment_model.dart';
import 'package:lello/feature/payment/data/repository/payment_repository_impl.dart';
import 'package:lello/feature/payment/domain/entity/payment.dart';
import 'package:lello/feature/payment/domain/entity/payment_list_filter.dart';
import 'package:lello/feature/payment/domain/entity/payment_status.dart';
import 'package:lello/feature/payment/domain/repository/payment_repository.dart';
import 'package:mockito/mockito.dart';
import 'package:essentials/essentials.dart';
import '../../../../matcher/is_and_matcher.dart';

void main() {
  PaymentRemoteDataSource dataSource;
  PaymentRepository repository;
  setUp(() {
    dataSource = PaymentRemoteDataSourceMock();
    repository = PaymentRepositoryImpl(remoteDataSource: dataSource);
  });

  final _condominiumId = "1";
  final _id = "2";
  final _supplierIdentification = "3";
  final _documentNumber = "4";
  final _barcode = "5";
  final model = PaymentModel();

  group('select', () {
    test('Should call data source select method', () async {
      when(dataSource.select(_condominiumId, _id))
          .thenAnswer((_) async => model);
      await repository.select(_condominiumId, _id);
      verify(dataSource.select(_condominiumId, _id));
    });

    test('Should return rejection if data source throws any error', () async {
      when(dataSource.select(_condominiumId, _id)).thenThrow(Exception());
      final result = await repository.select(_condominiumId, _id);
      expect(result, isA<Rejection<Payment>>());
    });

    test('Should return succeess if data source succeeds', () async {
      when(dataSource.select(_condominiumId, _id))
          .thenAnswer((_) async => model);
      final result = await repository.select(_condominiumId, _id);
      expect(result, isA<Success<Payment>>());
    });
  });

  group('list', () {
    test('Should call data source select method', () async {
      final filter = PaymentListFilter();
      when(dataSource.list(_condominiumId,
              lastPaymentId: "1", filter: filter, status: "Aprovado"))
          .thenAnswer((_) async => [model]);
      await repository.list(_condominiumId,
          lastPaymentId: "1", filter: filter, status: "Aprovado");
      verify(dataSource.list(_condominiumId,
          lastPaymentId: "1", filter: filter, status: "Aprovado"));
    });

    test('Should return rejection if data source throws any error', () async {
      when(dataSource.list(_condominiumId)).thenThrow(Exception());
      final result = await repository.list(_condominiumId);
      expect(result, isA<Rejection>());
    });

    test('Should return succeess if data source succeeds', () async {
      when(dataSource.list(_condominiumId)).thenAnswer((_) async => [model]);
      final result = await repository.list(_condominiumId);
      expect(result, IsAnd<Success<List<Payment>>>((it) => it.length() == 1));
    });
  });

  group('find', () {
    test('Should call data source select method', () async {
      final filter = PaymentListFilter();
      when(dataSource.find(
              _condominiumId, _supplierIdentification, _documentNumber))
          .thenAnswer((_) async => model);
      await repository.find(
          _condominiumId, _supplierIdentification, _documentNumber);
      verify(dataSource.find(
          _condominiumId, _supplierIdentification, _documentNumber));
    });

    test('Should return rejection if data source throws any error', () async {
      when(dataSource.find(
              _condominiumId, _supplierIdentification, _documentNumber))
          .thenThrow(Exception());
      final result = await repository.find(
          _condominiumId, _supplierIdentification, _documentNumber);
      expect(result, isA<Rejection<Payment>>());
    });

    test('Should return succeess if data source succeeds', () async {
      when(dataSource.find(
              _condominiumId, _supplierIdentification, _documentNumber))
          .thenAnswer((_) async => model);
      final result = await repository.find(
          _condominiumId, _supplierIdentification, _documentNumber);
      expect(result, isA<Success<Payment>>());
    });
  });

  group('findByBarcode', () {
    test('Should call data source select method', () async {
      when(dataSource.findByBarcode(_condominiumId, _barcode))
          .thenAnswer((_) async => model);
      await repository.findByBarcode(_condominiumId, _barcode);
      verify(dataSource.findByBarcode(_condominiumId, _barcode));
    });

    test('Should return rejection if data source throws any error', () async {
      when(dataSource.findByBarcode(_condominiumId, _barcode))
          .thenThrow(Exception());
      final result = await repository.findByBarcode(_condominiumId, _barcode);
      expect(result, isA<Rejection<Payment>>());
    });

    test('Should return succeess if data source succeeds', () async {
      when(dataSource.findByBarcode(_condominiumId, _barcode))
          .thenAnswer((_) async => model);
      final result = await repository.findByBarcode(_condominiumId, _barcode);
      expect(result, isA<Success<Payment>>());
    });
  });
}

class PaymentRemoteDataSourceMock extends Mock
    implements PaymentRemoteDataSource {}
