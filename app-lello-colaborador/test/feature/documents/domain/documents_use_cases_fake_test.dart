import 'package:colaborador/feature/documents/domain/entity/document_file.dart';
import 'package:colaborador/feature/documents/domain/entity/document_info.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/documents/domain/repository/documents_repository.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_document_file/get_document_file_impl.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list.dart';
import 'package:colaborador/feature/documents/domain/use_case/get_documents_info_list/get_documents_info_list_impl.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeDocsRepo extends Fake implements DocumentsRepository {
  Object? last;
  bool failList = false;
  bool failFile = false;

  @override
  Future<Try<List<DocumentInfo>>> getDocumentsInfoList(
    String condoId,
    DocumentTypeEnum documentType,
    DateTime? dateFrom,
    DateTime? dateTo,
  ) async {
    if (failList) return Rejection(UnknownFailure('list'));
    last = condoId;
    return Success([
      DocumentInfo(
        name: 'holerite.pdf',
        type: documentType,
        documentProcessingDate: DateTime(2026, 1, 10),
      ),
    ]);
  }

  @override
  Future<Try<DocumentFile>> getDocumentFile(String documentName) async {
    if (failFile) return Rejection(UnknownFailure('file'));
    last = documentName;
    return Success(DocumentFile(
      id: '1',
      name: documentName,
      type: 'pdf',
      data: 'abc',
    ));
  }
}

void main() {
  group('GetDocumentsInfoListUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        GetDocumentsInfoListUsecaseImpl(repository: _FakeDocsRepo())
            .validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita condomínio vazio', () async {
      final result = await GetDocumentsInfoListUsecaseImpl(
        repository: _FakeDocsRepo(),
      )(GetDocumentsInfoListParam(
        condoId: '',
        documentType: DocumentTypeEnum.payStub,
      ));
      expect(result, isA<Rejection<List<DocumentInfo>>>());
    });

    test('lista documentos', () async {
      final repo = _FakeDocsRepo();
      final result = await GetDocumentsInfoListUsecaseImpl(repository: repo)(
        GetDocumentsInfoListParam(
          condoId: 'c1',
          documentType: DocumentTypeEnum.payStub,
        ),
      );
      expect(result, isA<Success<List<DocumentInfo>>>());
      expect(repo.last, 'c1');
      expect((result as Success<List<DocumentInfo>>).get().first.name, 'holerite.pdf');
    });

    test('rejeita erro do repositório', () async {
      final result = await GetDocumentsInfoListUsecaseImpl(
        repository: _FakeDocsRepo()..failList = true,
      )(GetDocumentsInfoListParam(
        condoId: 'c1',
        documentType: DocumentTypeEnum.incomeReport,
      ));
      expect(result, isA<Rejection<List<DocumentInfo>>>());
    });
  });

  group('GetDocumentFileUsecaseImpl', () {
    test('rejeita param nulo', () {
      expect(
        GetDocumentFileUsecaseImpl(repository: _FakeDocsRepo()).validate(null),
        isA<InvalidParamFailure>(),
      );
    });

    test('rejeita nome vazio', () async {
      final result = await GetDocumentFileUsecaseImpl(
        repository: _FakeDocsRepo(),
      )(GetDocumentFileParam(documentName: ''));
      expect(result, isA<Rejection<DocumentFile>>());
    });

    test('busca o arquivo', () async {
      final repo = _FakeDocsRepo();
      final result = await GetDocumentFileUsecaseImpl(repository: repo)(
        GetDocumentFileParam(documentName: 'holerite.pdf'),
      );
      expect(result, isA<Success<DocumentFile>>());
      expect(repo.last, 'holerite.pdf');
    });

    test('rejeita erro do repositório', () async {
      final result = await GetDocumentFileUsecaseImpl(
        repository: _FakeDocsRepo()..failFile = true,
      )(GetDocumentFileParam(documentName: 'holerite.pdf'));
      expect(result, isA<Rejection<DocumentFile>>());
    });
  });
}
