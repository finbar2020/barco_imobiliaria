import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/create_document/create_document.dart';
import 'package:lello/feature/vox/domain/use_case/create_document/create_document_impl.dart';
import 'package:lello/feature/vox/domain/use_case/get_document/get_document.dart';
import 'package:lello/feature/vox/domain/use_case/get_document/get_document_impl.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_reasons/list_document_reasons.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_reasons/list_document_reasons_impl.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_templates/list_document_templates.dart';
import 'package:lello/feature/vox/domain/use_case/list_document_templates/list_document_templates_impl.dart';
import 'package:lello/feature/vox/domain/use_case/list_documents/list_documents.dart';
import 'package:lello/feature/vox/domain/use_case/list_documents/list_documents_impl.dart';
import 'package:lello/feature/vox/domain/use_case/upload_document_image/upload_document_image.dart';
import 'package:lello/feature/vox/domain/use_case/upload_document_image/upload_document_image_impl.dart';

class _FakeRepo extends Fake implements VoxRepository {
  Object? last;

  @override
  Future<Try<List<Document>>> listDocuments(
      DocumentType type, String condominiumId) async {
    last = condominiumId;
    return Success([Document()..id = 'd1']);
  }

  @override
  Future<Try<DocumentDetail>> getDocument(DocumentType type, String id) async {
    last = id;
    return Success(DocumentDetail()..id = id);
  }

  @override
  Future<Try<String>> createDocument(
      DocumentType type, DocumentRequest request) async {
    last = type;
    return Success('created');
  }

  @override
  Future<Try<List<DocumentReason>>> listReasons(
      DocumentType type, String condominiumId) async {
    last = type;
    return Success([DocumentReason()..id = 'r1']);
  }

  @override
  Future<Try<List<DocumentTemplate>>> listTemplates(
      DocumentType type, String condominiumId) async {
    last = condominiumId;
    return Success([DocumentTemplate()..id = 't1']);
  }

  @override
  Future<Try<String>> uploadImage(Uint8List bytes, String fileName) async {
    last = fileName;
    return Success('https://cdn/img.png');
  }
}

void main() {
  late _FakeRepo repo;

  setUp(() => repo = _FakeRepo());

  group('ListDocumentsImpl', () {
    test('rejeita param nulo ou condomínio vazio', () async {
      final useCase = ListDocumentsImpl(repository: repo);
      expect(await useCase(null), isA<Rejection<List<Document>>>());
      expect(
        await useCase(ListDocumentsParam(
          type: DocumentType.warning,
          condominiumId: '',
        )),
        isA<Rejection<List<Document>>>(),
      );
    });

    test('lista quando os params são válidos', () async {
      final result = await ListDocumentsImpl(repository: repo)(
        ListDocumentsParam(
          type: DocumentType.warning,
          condominiumId: 'c1',
        ),
      );
      expect(result, isA<Success<List<Document>>>());
      expect(repo.last, 'c1');
    });
  });

  group('GetDocumentImpl', () {
    test('rejeita id vazio', () async {
      final result = await GetDocumentImpl(repository: repo)(
        GetDocumentParam(type: DocumentType.fine, id: ''),
      );
      expect(result, isA<Rejection<DocumentDetail>>());
    });

    test('encaminha id válido', () async {
      final result = await GetDocumentImpl(repository: repo)(
        GetDocumentParam(type: DocumentType.fine, id: 'd9'),
      );
      expect(result, isA<Success<DocumentDetail>>());
      expect(repo.last, 'd9');
    });
  });

  group('CreateDocumentImpl', () {
    test('rejeita condomínio vazio', () async {
      final result = await CreateDocumentImpl(repository: repo)(
        CreateDocumentParam(
          type: DocumentType.announcement,
          condominiumId: '',
          request: DocumentRequest(),
        ),
      );
      expect(result, isA<Rejection<String>>());
    });

    test('cria quando os params são válidos', () async {
      final result = await CreateDocumentImpl(repository: repo)(
        CreateDocumentParam(
          type: DocumentType.announcement,
          condominiumId: 'c1',
          request: DocumentRequest(),
        ),
      );
      expect(result, isA<Success<String>>());
      expect(repo.last, DocumentType.announcement);
    });
  });

  test('ListDocumentReasonsImpl e ListDocumentTemplatesImpl', () async {
    final reasons = await ListDocumentReasonsImpl(repository: repo)(
      ListDocumentReasonsParam(
        type: DocumentType.warning,
        condominiumId: 'c1',
      ),
    );
    expect(reasons, isA<Success<List<DocumentReason>>>());

    final templates = await ListDocumentTemplatesImpl(repository: repo)(
      ListDocumentTemplatesParam(
        type: DocumentType.fine,
        condominiumId: 'c1',
      ),
    );
    expect(templates, isA<Success<List<DocumentTemplate>>>());
    expect(repo.last, 'c1');
  });

  group('UploadDocumentImageImpl', () {
    test('rejeita bytes ou nome vazios', () async {
      final useCase = UploadDocumentImageImpl(repository: repo);
      expect(await useCase(null), isA<Rejection<String>>());
      expect(
        await useCase(UploadDocumentImageParam(
          bytes: Uint8List(0),
          fileName: 'a.png',
        )),
        isA<Rejection<String>>(),
      );
      expect(
        await useCase(UploadDocumentImageParam(
          bytes: Uint8List.fromList([1]),
          fileName: '',
        )),
        isA<Rejection<String>>(),
      );
    });

    test('sobe a imagem quando os params são válidos', () async {
      final result = await UploadDocumentImageImpl(repository: repo)(
        UploadDocumentImageParam(
          bytes: Uint8List.fromList([1, 2, 3]),
          fileName: 'foto.png',
        ),
      );
      expect(result, isA<Success<String>>());
      expect(repo.last, 'foto.png');
    });
  });

  test('Document.periodDate usa occurrenceDate ou createdAt', () {
    final withOccurrence = Document()
      ..occurrenceDate = DateTime(2026, 2, 1)
      ..createdAt = '2025-01-01';
    expect(withOccurrence.periodDate, DateTime(2026, 2, 1));

    final withCreated = Document()..createdAt = '2026-03-10T00:00:00.000Z';
    expect(withCreated.periodDate?.year, 2026);

    expect(Document().periodDate == null, isTrue);
  });
}
