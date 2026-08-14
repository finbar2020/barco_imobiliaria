import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_detail.dart';
import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_request.dart';
import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';
import 'package:lello/feature/vox/domain/repository/vox_repository.dart';
import 'package:lello/feature/vox/domain/use_case/request_document/request_document.dart';
import 'package:lello/feature/vox/domain/use_case/request_document/request_document_impl.dart';

import '../../../../matcher/is_and_matcher.dart';

/// Fake que registra se a chamada chegou ao repositório (após a validação).
class _FakeRepo implements VoxRepository {
  bool requested = false;

  @override
  Future<Try<String>> requestDocument(
      DocumentType type, DocumentRequest request) async {
    requested = true;
    return Success('ok');
  }

  @override
  Future<Try<List<DocumentReason>>> listReasons(
          DocumentType type, String condominiumId) async =>
      Success(const []);

  @override
  Future<Try<List<DocumentTemplate>>> listTemplates(
          DocumentType type, String condominiumId) async =>
      Success(const []);

  @override
  Future<Try<List<Document>>> listDocuments(
          DocumentType type, String condominiumId) async =>
      Success(const []);

  @override
  Future<Try<DocumentDetail>> getDocument(DocumentType type, String id) async =>
      Success(DocumentDetail());

  @override
  Future<Try<String>> createDocument(
          DocumentType type, DocumentRequest request) async =>
      Success('ok');

  @override
  Future<Try<String>> uploadImage(Uint8List bytes, String fileName) async =>
      Success('url');
}

void main() {
  late _FakeRepo repo;
  late RequestDocumentImpl useCase;

  setUp(() {
    repo = _FakeRepo();
    useCase = RequestDocumentImpl(repository: repo);
  });

  test('retorna InvalidParamFailure quando o parâmetro é nulo', () async {
    final result = await useCase(null);
    expect(result,
        IsAnd<Rejection<String>>((it) => it.get() is InvalidParamFailure));
    expect(repo.requested, isFalse);
  });

  test('retorna InvalidParamFailure quando condominiumId é vazio', () async {
    final result = await useCase(RequestDocumentParam(
        type: DocumentType.warning,
        condominiumId: '',
        request: DocumentRequest()));
    expect(result,
        IsAnd<Rejection<String>>((it) => it.get() is InvalidParamFailure));
    expect(repo.requested, isFalse);
  });

  test('chama o repositório quando os parâmetros são válidos', () async {
    final result = await useCase(RequestDocumentParam(
        type: DocumentType.warning,
        condominiumId: 'c1',
        request: DocumentRequest()));
    expect(result, isA<Success<String>>());
    expect(repo.requested, isTrue);
  });
}
