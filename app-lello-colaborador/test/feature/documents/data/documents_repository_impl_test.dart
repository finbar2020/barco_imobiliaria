import 'dart:convert';
import 'dart:io';

import 'package:colaborador/feature/documents/data/data_source/documents_remote_data_source.dart';
import 'package:colaborador/feature/documents/data/model/document_file_model.dart';
import 'package:colaborador/feature/documents/data/model/document_info_model.dart';
import 'package:colaborador/feature/documents/data/repository/documents_repository_impl.dart';
import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemote extends Fake implements DocumentsRemoteDataSource {
  Object? last;
  bool fail = false;
  bool failFile = false;
  String fileData = '';

  @override
  Future<List<DocumentInfoModel>> getDocumentsInfoList(
    String condoId,
    String documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    if (fail) throw Exception('boom');
    last = '$condoId|$documentType';
    return [
      DocumentInfoModel(
        name: 'novo.pdf',
        type: 'payStub',
        documentProcessingDate: DateTime(2026, 2, 1),
      ),
      DocumentInfoModel(
        name: 'antigo.pdf',
        type: 'payStub',
        documentProcessingDate: DateTime(2026, 1, 1),
      ),
    ];
  }

  @override
  Future<DocumentFileModel> getDocumentFile(String documentName) async {
    if (failFile) throw Exception('file boom');
    last = documentName;
    return DocumentFileModel(
      id: '1',
      name: '$documentName.pdf',
      type: 'pdf',
      data: fileData,
    );
  }
}

void main() {
  group('DocumentsRepositoryImpl.getDocumentsInfoList', () {
    test('ordena do mais recente para o mais antigo', () async {
      final remote = _FakeRemote();
      final result = await DocumentsRepositoryImpl(remoteDataSource: remote)
          .getDocumentsInfoList(
        'c1',
        DocumentTypeEnum.payStub,
        null,
        null,
      );
      expect(result, isA<Success<List<DocumentInfo>>>());
      final list = (result as Success<List<DocumentInfo>>).get();
      expect(list.map((e) => e.name), ['novo.pdf', 'antigo.pdf']);
    });

    test('rejeita erro do remote', () async {
      final result = await DocumentsRepositoryImpl(
        remoteDataSource: _FakeRemote()..fail = true,
      ).getDocumentsInfoList('c1', DocumentTypeEnum.payStub, null, null);
      expect(result, isA<Rejection<List<DocumentInfo>>>());
    });
  });

  group('DocumentsRepositoryImpl.getDocumentFile', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      const channel = MethodChannel('plugins.flutter.io/path_provider');
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(channel, (call) async {
        if (call.method == 'getApplicationDocumentsPath' ||
            call.method == 'getApplicationDocumentsDirectory') {
          return Directory.systemTemp.path;
        }
        return null;
      });
    });

    test('retorna arquivo sem gravar quando data vazio', () async {
      final remote = _FakeRemote();
      final result = await DocumentsRepositoryImpl(remoteDataSource: remote)
          .getDocumentFile('holerite');
      expect(result, isA<Success<DocumentFile>>());
      final file = (result as Success<DocumentFile>).get();
      expect(file.name, 'holerite.pdf');
      expect(file.file, isNull);
      expect(remote.last, 'holerite');
    });

    test('grava base64 em disco', () async {
      final remote = _FakeRemote()
        ..fileData = base64Encode([1, 2, 3]);
      final result = await DocumentsRepositoryImpl(remoteDataSource: remote)
          .getDocumentFile('doc');
      expect(result, isA<Success<DocumentFile>>());
      final file = (result as Success<DocumentFile>).get();
      expect(file.file, isNotNull);
      expect(await file.file!.exists(), isTrue);
      expect(await file.file!.readAsBytes(), [1, 2, 3]);
      await file.file!.delete();
    });

    test('rejeita erro do remote', () async {
      final result = await DocumentsRepositoryImpl(
        remoteDataSource: _FakeRemote()..failFile = true,
      ).getDocumentFile('x');
      expect(result, isA<Rejection<DocumentFile>>());
    });
  });
}
