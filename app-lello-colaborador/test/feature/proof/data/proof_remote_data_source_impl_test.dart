import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_api.dart';
import 'package:colaborador/feature/proof/data/data_source/remote/proof_remote_data_source_impl.dart';
import 'package:colaborador/feature/proof/data/model/proof_file_model.dart';
import 'package:colaborador/feature/proof/data/model/proof_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

class _FakeProofApi extends Fake implements ProofApi {
  bool fail = false;

  @override
  Future<Response<dynamic>> getProof(
    String condominiumId,
    DateTime date,
  ) async {
    if (fail) {
      return Response(http.Response('erro', 500), 'erro');
    }
    return Response(
      http.Response(
        jsonEncode([
          {
            'nsr': 1,
            'date_time_clock_in': '2026-01-10T08:00:00',
            'proof_name': 'proof.pdf',
          },
        ]),
        200,
      ),
      '',
    );
  }

  @override
  Future<Response<dynamic>> getFileProof(
    String condominiumId,
    String fileName,
  ) async {
    if (fail) {
      return Response(http.Response('erro', 500), 'erro');
    }
    return Response(
      http.Response(jsonEncode({'content_bytes': 'abc123'}), 200),
      '',
    );
  }
}

void main() {
  group('ProofRemoteDataSourceImpl', () {
    test('lista comprovantes', () async {
      final dataSource = ProofRemoteDataSourceImpl(api: _FakeProofApi());
      final list = await dataSource.getProof('c1', DateTime(2026, 1, 10));
      expect(list, hasLength(1));
      expect(list.first, isA<ProofModel>());
      expect(list.first.proofName, 'proof.pdf');
    });

    test('busca arquivo do comprovante', () async {
      final file = await ProofRemoteDataSourceImpl(api: _FakeProofApi())
          .getFileProof('c1', 'proof.pdf');
      expect(file, isA<ProofFileModel>());
      expect(file.contentBytes, 'abc123');
    });

    test('lança quando api falha', () async {
      final api = _FakeProofApi()..fail = true;
      final dataSource = ProofRemoteDataSourceImpl(api: api);
      expect(
        () => dataSource.getProof('c1', DateTime(2026, 1, 10)),
        throwsA(anything),
      );
      expect(
        () => dataSource.getFileProof('c1', 'x.pdf'),
        throwsA(anything),
      );
    });
  });
}
