import 'dart:typed_data';

import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/data/data_source/remote/vox_remote_data_source.dart';
import 'package:lello/feature/vox/data/model/announcement_create_model.dart';
import 'package:lello/feature/vox/data/model/announcement_detail_model.dart';
import 'package:lello/feature/vox/data/model/announcement_model.dart';
import 'package:lello/feature/vox/data/model/announcement_request_model.dart';
import 'package:lello/feature/vox/data/model/document_reason_model.dart';
import 'package:lello/feature/vox/data/model/document_template_model.dart';
import 'package:lello/feature/vox/data/model/fine_model.dart';
import 'package:lello/feature/vox/data/model/fine_request_model.dart';
import 'package:lello/feature/vox/data/model/warning_create_model.dart';
import 'package:lello/feature/vox/data/model/warning_model.dart';
import 'package:lello/feature/vox/data/model/warning_request_model.dart';
import 'package:lello/feature/vox/data/repository/vox_repository_impl.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

/// Fake que registra qual método foi chamado e captura o model — para provar
/// o dispatch por tipo (estratégia de submit) sem depender de matchers.
class _FakeRemote implements VoxRemoteDataSource {
  String? calledRequest;
  WarningRequestModel? warningModel;
  FineRequestModel? fineModel;
  AnnouncementRequestModel? announcementModel;
  final List<String> reasonsCalls = [];
  final List<String> templatesCalls = [];

  Object? error;

  void _throwIfError() {
    if (error != null) throw error!;
  }

  @override
  Future<String> requestWarning(WarningRequestModel model) async {
    _throwIfError();
    calledRequest = 'warning';
    warningModel = model;
    return '';
  }

  @override
  Future<String> requestFine(FineRequestModel model) async {
    calledRequest = 'fine';
    fineModel = model;
    return '';
  }

  @override
  Future<String> requestAnnouncement(AnnouncementRequestModel model) async {
    calledRequest = 'announcement';
    announcementModel = model;
    return '';
  }

  @override
  Future<List<DocumentReasonModel>> getWarningReasons(String condominiumId) async {
    _throwIfError();
    reasonsCalls.add('warning');
    return [];
  }

  @override
  Future<List<DocumentReasonModel>> getFineReasons(String condominiumId) async {
    reasonsCalls.add('fine');
    return [];
  }

  @override
  Future<List<DocumentTemplateModel>> getWarningTemplates(String condominiumId) async {
    _throwIfError();
    templatesCalls.add('warning');
    return [];
  }

  @override
  Future<List<DocumentTemplateModel>> getFineTemplates(String condominiumId) async {
    templatesCalls.add('fine');
    return [];
  }

  @override
  Future<List<DocumentTemplateModel>> getAnnouncementModels(
      String condominiumId) async {
    templatesCalls.add('announcement');
    return [];
  }

  final List<String> listCalls = [];
  final List<String> detailCalls = [];
  final List<String> createCalls = [];

  @override
  Future<String> createWarning(
      String condominiumId, WarningCreateModel model) async {
    _throwIfError();
    createCalls.add('warning');
    return '';
  }

  @override
  Future<String> createAnnouncement(
      String condominiumId, AnnouncementCreateModel model) async {
    createCalls.add('announcement');
    return '';
  }

  @override
  Future<List<WarningModel>> listWarnings(String condominiumId) async {
    _throwIfError();
    listCalls.add('warning');
    return [];
  }

  @override
  Future<List<FineModel>> listFines(String condominiumId) async {
    listCalls.add('fine');
    return [];
  }

  @override
  Future<List<AnnouncementModel>> listAnnouncements(String condominiumId) async {
    listCalls.add('announcement');
    return [];
  }

  @override
  Future<WarningModel> getWarningById(String id) async {
    _throwIfError();
    detailCalls.add('warning');
    return WarningModel();
  }

  @override
  Future<FineModel> getFineById(String id) async {
    detailCalls.add('fine');
    return FineModel();
  }

  @override
  Future<AnnouncementDetailModel> getAnnouncementById(String id) async {
    detailCalls.add('announcement');
    return AnnouncementDetailModel();
  }

  @override
  Future<String> uploadImage(List<int> bytes, String fileName) async {
    _throwIfError();
    return 'url';
  }
}

void main() {
  late _FakeRemote remote;
  late VoxRepositoryImpl repository;

  setUp(() {
    remote = _FakeRemote();
    repository = VoxRepositoryImpl(remoteDataSource: remote);
  });

  group('requestDocument — dispatch da estratégia de submit', () {
    test('warning -> requestWarning com serviceId 790850', () async {
      final result = await repository.requestDocument(
          DocumentType.warning, DocumentRequest(condominiumId: 'c1'));
      expect(result, isA<Success<String>>());
      expect(remote.calledRequest, 'warning');
      expect(remote.warningModel!.serviceId, '790850');
    });

    test('fine -> requestFine com serviceId 790851', () async {
      final result = await repository.requestDocument(
          DocumentType.fine, DocumentRequest(condominiumId: 'c1'));
      expect(result, isA<Success<String>>());
      expect(remote.calledRequest, 'fine');
      expect(remote.fineModel!.serviceId, '790851');
    });

    test('announcement -> requestAnnouncement com serviceId 790829', () async {
      final result = await repository.requestDocument(
          DocumentType.announcement, DocumentRequest(condominiumId: 'c1'));
      expect(result, isA<Success<String>>());
      expect(remote.calledRequest, 'announcement');
      expect(remote.announcementModel!.serviceId, '790829');
    });
  });

  group('listReasons / listTemplates — dispatch por tipo', () {
    test('reasons: warning chama remote; comunicado não tem motivos', () async {
      await repository.listReasons(DocumentType.warning, 'c1');
      await repository.listReasons(DocumentType.fine, 'c1');
      final ann = await repository.listReasons(DocumentType.announcement, 'c1');
      expect(remote.reasonsCalls, ['warning', 'fine']);
      expect((ann as Success).get(), isEmpty);
    });

    test('templates: fine e comunicado batem na rede', () async {
      await repository.listTemplates(DocumentType.warning, 'c1');
      await repository.listTemplates(DocumentType.fine, 'c1');
      await repository.listTemplates(DocumentType.announcement, 'c1');
      expect(remote.templatesCalls, ['warning', 'fine', 'announcement']);
    });
  });

  group('listDocuments / getDocument — dispatch por tipo', () {
    test('listDocuments dispatcha para o endpoint do tipo', () async {
      await repository.listDocuments(DocumentType.warning, 'c1');
      await repository.listDocuments(DocumentType.fine, 'c1');
      await repository.listDocuments(DocumentType.announcement, 'c1');
      expect(remote.listCalls, ['warning', 'fine', 'announcement']);
    });

    test('getDocument dispatcha para o detalhe do tipo', () async {
      await repository.getDocument(DocumentType.warning, 'id1');
      await repository.getDocument(DocumentType.fine, 'id1');
      await repository.getDocument(DocumentType.announcement, 'id1');
      expect(remote.detailCalls, ['warning', 'fine', 'announcement']);
    });
  });

  group('createDocument — dispatch da estratégia de criação', () {
    test('warning e announcement dispatcham; fine não suporta', () async {
      await repository.createDocument(
          DocumentType.warning, DocumentRequest(condominiumId: 'c1'));
      await repository.createDocument(
          DocumentType.announcement, DocumentRequest(condominiumId: 'c1'));
      final fine = await repository.createDocument(
          DocumentType.fine, DocumentRequest(condominiumId: 'c1'));

      expect(remote.createCalls, ['warning', 'announcement']);
      expect(fine, isA<Rejection<String>>());
      expect((fine as Rejection).get(), isA<InvalidParamFailure>());
    });
  });

  test('falhas da remote viram Rejection', () async {
    remote.error = Exception('rede');
    expect(
      await repository.requestDocument(
        DocumentType.warning,
        DocumentRequest(condominiumId: 'c1'),
      ),
      isA<Rejection<String>>(),
    );
  });

  test('uploadImage comprime ou envia bytes originais', () async {
    final result = await repository.uploadImage(
      Uint8List.fromList(List<int>.filled(12, 1)),
      'foto.png',
    );
    expect(result, isA<Success<String>>());
    expect((result as Success<String>).get(), 'url');

    final noExt = await repository.uploadImage(
      Uint8List.fromList(List<int>.filled(12, 1)),
      'foto',
    );
    expect(noExt, isA<Success<String>>());
  });

  test('falhas da remote em create, listagens, detalhe e upload', () async {
    remote.error = Exception('rede');
    final request = DocumentRequest(condominiumId: 'c1');
    expect(
      await repository.createDocument(DocumentType.warning, request),
      isA<Rejection<String>>(),
    );
    expect(
      (await repository.listReasons(DocumentType.warning, 'c1')) is Rejection,
      isTrue,
    );
    expect(
      (await repository.listTemplates(DocumentType.warning, 'c1')) is Rejection,
      isTrue,
    );
    expect(
      (await repository.listDocuments(DocumentType.warning, 'c1')) is Rejection,
      isTrue,
    );
    expect(
      (await repository.getDocument(DocumentType.warning, 'id1')) is Rejection,
      isTrue,
    );
    expect(
      await repository.uploadImage(
        Uint8List.fromList(List<int>.filled(4, 1)),
        'foto.png',
      ),
      isA<Rejection<String>>(),
    );
  });
}
