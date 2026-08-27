import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document_impl.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text_impl.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_state.dart';

import 'documents_support.dart';

void main() {
  late FakeDocumentsRepository repo;
  late RecordingDocumentsAnalytics analytics;
  late DocumentsHarness harness;
  late Directory dir;

  setUp(() {
    repo = FakeDocumentsRepository();
    analytics = RecordingDocumentsAnalytics();
    harness = DocumentsHarness(repository: repo, analytics: analytics);
    dir = Directory.systemTemp.createTempSync('shared_docs_ctrl');
  });

  tearDown(() => dir.deleteSync(recursive: true));

  Future<void> flush() => Future<void>.delayed(const Duration(milliseconds: 10));

  group('use cases', () {
    test('DownloadDocumentImpl valida e converte o tipo', () async {
      final useCase = DownloadDocumentImpl(repository: repo);
      final invalid = await useCase
          .call(DownloadDocumentParam(documentId: '', documentType: 'x'));
      expect((invalid as Rejection).get(), isA<InvalidParamFailure>());
      final invalid2 = await useCase
          .call(DownloadDocumentParam(documentId: 'd1', documentType: ''));
      expect(invalid2, isA<Rejection>());
      expect(repo.downloadCalls, isEmpty);

      final pdf = writePdf(dir);
      repo.download = () => Success(pdf);
      final ok = await useCase.call(
          DownloadDocumentParam(documentId: 'd1', documentType: minutesType));
      expect((ok as Success<File>).get().path, pdf.path);
      expect(repo.downloadCalls.single, ['d1', minutesApi]);
    });

    test('GetExtractedTextImpl valida e converte o tipo', () async {
      final useCase = GetExtractedTextImpl(repository: repo);
      final invalid = await useCase
          .call(GetExtractedTextParam(documentId: '', documentType: 'x'));
      expect((invalid as Rejection).get(), isA<InvalidParamFailure>());
      final invalid2 = await useCase
          .call(GetExtractedTextParam(documentId: 'd1', documentType: ''));
      expect(invalid2, isA<Rejection>());

      repo.text = () => Success('texto');
      final ok = await useCase.call(GetExtractedTextParam(
          documentId: 'd1', documentType: 'documents_notices'));
      expect((ok as Success<String>).get(), 'texto');
      expect(repo.textCalls.single, ['d1', '3']);
    });
  });

  group('DocumentsController', () {
    test('getDocs observa o repositório com a sessão e loga o acesso uma vez',
        () async {
      final at = DateTime(2026, 1, 1);
      final docs = [buildDocument()];
      repo.results = [
        DocsListResult.coldLoading(),
        DocsListResult.fresh(docs: docs, lastFetchedAt: at),
        DocsListResult.fresh(docs: docs, lastFetchedAt: at),
      ];
      final controller = harness.buildController();
      final states = <dynamic>[];
      controller.bloc.stream.listen(states.add);

      await controller.getDocs(minutesType);
      await flush();

      expect(repo.watchCalls.single, ['C1', minutesApi, 'U1', false]);
      expect(states.map((s) => s.runtimeType),
          [DocumentsLoadingState, DocumentsLoadedState, DocumentsLoadedState]);
      expect(analytics.accesses, [minutesType]);
    });

    test('lista vazia ou não fresca não loga o acesso', () async {
      repo.results = [
        DocsListResult.fresh(docs: const [], lastFetchedAt: DateTime(2026)),
        DocsListResult.staleRevalidating(
            docs: [buildDocument()], lastFetchedAt: DateTime(2026)),
      ];
      final controller = harness.buildController();
      await controller.getDocs(minutesType);
      await flush();
      expect(analytics.accesses, isEmpty);
    });

    test('refresh sem tipo não faz nada; com tipo força a revalidação',
        () async {
      final controller = harness.buildController();
      await controller.refresh();
      expect(repo.watchCalls, isEmpty);

      await controller.getDocs('documents_divers');
      await controller.refresh();
      await flush();
      expect(repo.watchCalls, [
        ['C1', '0', 'U1', false],
        ['C1', '0', 'U1', true],
      ]);
    });

    test('síndico (sem unidade) lista pelo condomínio', () async {
      final sindico = DocumentsHarness(
          repository: repo, session: FakeSharedSession(unitId: ''));
      await sindico.buildController().getDocs('documents_circulars');
      expect(repo.watchCalls.single, ['C1', '1', '', false]);
    });

    test('getFile: loading e arquivo carregado com texto lazy', () async {
      final pdf = writePdf(dir);
      repo.download = () => Success(pdf);
      repo.text = () => Success('texto extraído');
      final controller = harness.buildController();
      final states = <dynamic>[];
      controller.bloc.stream.listen(states.add);

      await controller.getFile(buildDocument(), minutesType);
      await flush();

      expect(states.map((s) => s.runtimeType),
          [DocumentsFileLoadingState, DocumentsFileLoadedState]);
      final file = (states.last as DocumentsFileLoadedState).file;
      expect(file.id, 'd1');
      expect(file.name, 'Ata da assembleia');
      expect(file.documentName, 'Ata da assembleia');
      expect(file.localFile!.path, pdf.path);
      expect(repo.downloadCalls.single, ['d1', minutesApi]);

      expect(await file.loadExtractedText!(), 'texto extraído');
      expect(repo.textCalls.single, ['d1', minutesApi]);

      repo.text = () => Rejection(UnknownFailure('x'));
      expect(await file.loadExtractedText!(), isNull);
    });

    test('getFile com erro emite falha', () async {
      repo.download = () => Rejection(UnknownFailure('x'));
      final controller = harness.buildController();
      final states = <dynamic>[];
      controller.bloc.stream.listen(states.add);

      await controller.getFile(buildDocument(), minutesType);
      await flush();

      expect(states.last, isA<DocumentsFileFailureState>());
      expect((states.last as DocumentsFileFailureState).error, '');
    });

    test('dispose cancela a assinatura', () async {
      repo.results = [DocsListResult.coldLoading()];
      final controller = harness.buildController();
      await controller.getDocs(minutesType);
      await controller.dispose();
      await controller.dispose();
      await flush();
      expect(controller.bloc.state, isA<DocumentsState>());
    });
  });
}
