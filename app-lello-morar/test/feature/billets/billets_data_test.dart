import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/paginator/meta_model.dart';
import 'package:essentials/paginator/paginator_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/billets/data/data_source/billets_api.dart';
import 'package:morar/feature/billets/data/data_source/billets_remote_data_source.dart';
import 'package:morar/feature/billets/data/data_source/billets_remote_data_source_impl.dart';
import 'package:morar/feature/billets/data/repository/billets_repository_impl.dart';
import 'package:morar/feature/documents/data/model/document_file_response_model.dart';

import '../../helpers/firebase_mocks.dart';

class MockBilletsApi extends Mock implements BilletsApi {}

Response<dynamic> okResponse(Object body) =>
    Response<dynamic>(http.Response(jsonEncode(body), 200), body);

Response<dynamic> errorResponse() =>
    Response<dynamic>(http.Response('erro', 500), null, error: 'boom');

class _FakeDataSource extends Fake implements BilletsRemoteDataSource {
  _FakeDataSource({this.fail = false});

  final bool fail;

  @override
  Future<PaginatorModel> getBillets(String reference, String unitId,
      {bool showAll = false}) async {
    if (fail) throw Exception('rede');
    return PaginatorModel(
      meta: MetaModel(totalItems: 2),
      data: [
        {'id': reference, 'name': unitId, 'situation': showAll ? 'a' : 'b'}
      ],
    );
  }

  @override
  Future<DocumentFileResponseModel> getBilletPdf(String nrBillet) async {
    if (fail) throw Exception('rede');
    return DocumentFileResponseModel()
      ..name = '$nrBillet.pdf'
      ..data = 'YQ==';
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('BilletsRemoteDataSourceImpl', () {
    late MockBilletsApi api;
    late BilletsRemoteDataSourceImpl dataSource;

    setUp(() {
      api = MockBilletsApi();
      dataSource = BilletsRemoteDataSourceImpl(api: api);
    });

    test('getBillets mapeia o paginator', () async {
      when(() => api.fetchBillets('R1', '101', true)).thenAnswer(
        (_) async => okResponse({
          'meta': {'totalItems': 3},
          'data': [
            {'id': '1'}
          ],
        }),
      );
      final result = await dataSource.getBillets('R1', '101', showAll: true);
      expect(result.meta!.totalItems, 3);
      expect(result.data, [
        {'id': '1'}
      ]);
    });

    test('getBillets propaga erro da api', () async {
      when(() => api.fetchBillets('R1', '101', false))
          .thenAnswer((_) async => errorResponse());
      expect(() => dataSource.getBillets('R1', '101'), throwsA('boom'));
    });

    test('getBilletPdf mapeia o arquivo', () async {
      when(() => api.getBilletPdf('9')).thenAnswer(
        (_) async => okResponse({'name': 'x.pdf', 'data': 'YQ=='}),
      );
      final result = await dataSource.getBilletPdf('9');
      expect(result.name, 'x.pdf');
      expect(result.data, 'YQ==');
    });
  });

  group('BilletsRepositoryImpl', () {
    test('getBillets devolve entidade', () async {
      final repo = BilletsRepositoryImpl(dataSource: _FakeDataSource());
      final result = await repo.getBillets('R1', '101', showAll: true);
      final paginator = result.fold((_) => null, (p) => p)!;
      expect(paginator.meta!.totalItems, 2);
      expect(paginator.data.first['situation'], 'a');
    });

    test('getBillets devolve UnknownFailure em erro', () async {
      final repo = BilletsRepositoryImpl(dataSource: _FakeDataSource(fail: true));
      final result = await repo.getBillets('R1', '101');
      expect(result.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('getPdf devolve DocumentFile', () async {
      final repo = BilletsRepositoryImpl(dataSource: _FakeDataSource());
      final result = await repo.getPdf('7');
      expect(result.fold((_) => null, (d) => d.name), '7.pdf');
    });

    test('getPdf devolve UnknownFailure em erro', () async {
      final repo = BilletsRepositoryImpl(dataSource: _FakeDataSource(fail: true));
      final result = await repo.getPdf('7');
      expect(result.fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });
}
