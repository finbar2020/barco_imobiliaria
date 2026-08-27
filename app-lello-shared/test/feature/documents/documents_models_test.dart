import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_api.dart';
import 'package:shared_features/feature/documents/data/model/documents_response_model.dart';
import 'package:shared_features/feature/documents/domain/entity/document_file.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_bloc.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_event.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_state.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_analytics.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_item.dart';
import 'package:shared_features/feature/documents/presentation/page/documents_menu_strategy.dart';

import '../../helpers/pump_app.dart';
import 'documents_support.dart';

void main() {
  group('DocumentsResponseModel', () {
    test('fromJson/toJson/toEntity', () {
      final json = documentJson();
      final model = DocumentsResponseModel.fromJson(json);
      expect(model.id, 'd1');
      expect(model.name, 'Ata da assembleia');
      expect(model.description, 'Descrição');
      expect(model.content, 'conteúdo');
      expect(model.createdAt, '2026-01-10T00:00:00');
      expect(model.flagEmailDistribution, isTrue);
      expect(model.flagPrintDistribution, isFalse);
      expect(model.pagesQuantity, 3);
      expect(model.status, 'ATIVO');
      expect(model.notificationParameter, 'np1');
      expect(model.documentsType, DocumentsType.atas);
      expect(model.toJson(), json);

      final entity = model.toEntity();
      expect(entity.id, 'd1');
      expect(entity.name, 'Ata da assembleia');
      expect(entity.documentsType, DocumentsType.atas);
      expect(entity.pagesQuantity, 3);
      expect(entity.notificationParameter, 'np1');
      expect(entity.toString(), contains('name: Ata da assembleia'));

      final tipoDesconhecido =
          DocumentsResponseModel.fromJson(documentJson(documentsType: null));
      expect(tipoDesconhecido.documentsType, isNull);
    });

    test('fromEntity copia os campos e aceita nulo', () {
      final model = DocumentsResponseModel.fromEntity(buildDocument())!;
      expect(model.id, 'd1');
      expect(model.name, 'Ata da assembleia');
      expect(model.documentsType, DocumentsType.atas);
      expect(model.notificationParameter, 'np1');
      expect(model.createdAt, '2026-01-10T00:00:00');
      expect(DocumentsResponseModel.fromEntity(null), isNull);
    });
  });

  test('DocumentFile guarda o arquivo e o texto lazy', () async {
    final file = DocumentFile(
      id: '1',
      name: 'n',
      type: 't',
      documentName: 'doc',
      localFile: File('/tmp/x.pdf'),
      loadExtractedText: () async => 'texto',
    );
    expect(file.toString(), 'DocumentFile(id: 1, name: n, type: t, localFile: /tmp/x.pdf)');
    expect(await file.loadExtractedText!(), 'texto');
    // ignore: deprecated_member_use_from_same_package
    expect(DocumentFile(data: 'b64', extractedText: 'x').data, 'b64');
  });

  test('DocsListResult: fábricas e frescor', () {
    final docs = [buildDocument()];
    final at = DateTime(2026, 1, 1);
    final fresh = DocsListResult.fresh(docs: docs, lastFetchedAt: at);
    expect(fresh.freshness, DocsFreshness.fresh);
    expect(fresh.docs, same(docs));
    expect(fresh.lastFetchedAt, at);
    expect(fresh.error, isNull);

    final stale = DocsListResult.staleRevalidating(docs: docs, lastFetchedAt: at);
    expect(stale.freshness, DocsFreshness.staleRevalidating);

    final failed = DocsListResult.staleFailed(docs: docs, lastFetchedAt: at, error: 'e');
    expect(failed.freshness, DocsFreshness.staleFailed);
    expect(failed.error, 'e');

    final cold = DocsListResult.coldLoading();
    expect(cold.freshness, DocsFreshness.coldLoading);
    expect(cold.docs, isEmpty);

    final error = DocsListResult.error('boom');
    expect(error.freshness, DocsFreshness.error);
    expect(error.error, 'boom');
  });

  test('documentTypeToApiNumber e caminhos binários', () {
    expect(documentTypeToApiNumber('documents_divers'), '0');
    expect(documentTypeToApiNumber('documents_circulars'), '1');
    expect(documentTypeToApiNumber('documents_minutes'), '2');
    expect(documentTypeToApiNumber('documents_notices'), '3');
    expect(documentTypeToApiNumber('outro'), '');
    expect(DocumentsBinaryPaths.download('2', 'd1'),
        '/documents/type/2/d1/downloadRaw');
    expect(DocumentsBinaryPaths.text('2', 'd1'),
        '/documents/type/2/d1/extractedText');
    expect(DocumentsType.values, hasLength(5));
  });

  test('itens do menu, estratégia padrão e analytics nula', () {
    expect(kDefaultDocumentsMenuItems.map((i) => i.documentType), [
      'documents_minutes',
      'documents_notices',
      'documents_circulars',
      'documents_divers',
    ]);
    final strategy = DefaultDocumentsMenuStrategy();
    expect(strategy.items, kDefaultDocumentsMenuItems);
    final custom = DefaultDocumentsMenuStrategy(
        items: const [DocumentsMenuItem('documents_divers')]);
    expect(custom.items.single.documentType, 'documents_divers');

    const noop = NoopDocumentsAnalytics();
    noop.logAccess('x');
    noop.logShare('x');
  });

  testWidgets('wrapItem padrão devolve o card sem envolver', (tester) async {
    final strategy = DefaultDocumentsMenuStrategy();
    await pumpApp(
      tester,
      Builder(
        builder: (context) => strategy.wrapItem(
            context, const DocumentsMenuItem('documents_minutes'),
            const Text('card')),
      ),
    );
    expect(find.text('card'), findsOneWidget);
  });

  test('predicados de estado', () {
    expect(isListAffectingState(DocumentsEmptyState()), isTrue);
    expect(isListAffectingState(DocumentsLoadingState()), isTrue);
    expect(isListAffectingState(DocumentsLoadedState(documents: const [])), isTrue);
    expect(isListAffectingState(DocumentsFailureState(error: 'e')), isTrue);
    expect(isListAffectingState(DocumentsFileLoadingState()), isFalse);
    expect(isFileAffectingState(DocumentsFileLoadingState()), isTrue);
    expect(isFileAffectingState(DocumentsFileLoadedState(file: DocumentFile())), isTrue);
    expect(isFileAffectingState(DocumentsFileFailureState(error: 'e')), isTrue);
    expect(isFileAffectingState(DocumentsLoadedState(documents: const [])), isFalse);
    final base = DocumentsEmptyState();
    expect(base.documents, isEmpty);
    expect(base.file, isNull);
  });

  test('DocumentsBloc reage a todos os eventos', () async {
    final bloc = DocumentsBloc();
    expect(bloc.state, isA<DocumentsEmptyState>());
    final states = <dynamic>[];
    bloc.stream.listen(states.add);
    final docs = [buildDocument()];
    final at = DateTime(2026, 1, 1);

    bloc.add(DocumentsLoadingEvent());
    bloc.add(DocumentsEmptyEvent());
    bloc.add(DocumentsLoadedEvent(documents: docs));
    bloc.add(DocumentsFailedEvent(error: 'falha'));
    bloc.add(DocumentsFileLoadingEvent());
    bloc.add(DocumentsFileLoadedEvent(file: DocumentFile(id: 'f')));
    bloc.add(DocumentsFileFailedEvent(error: 'arquivo'));
    bloc.add(DocumentsCacheResultEvent(
        DocsListResult.fresh(docs: docs, lastFetchedAt: at)));
    bloc.add(DocumentsCacheResultEvent(
        DocsListResult.fresh(docs: const [], lastFetchedAt: at)));
    bloc.add(DocumentsCacheResultEvent(
        DocsListResult.staleRevalidating(docs: docs, lastFetchedAt: at)));
    bloc.add(DocumentsCacheResultEvent(
        DocsListResult.staleFailed(docs: docs, lastFetchedAt: at)));
    bloc.add(DocumentsCacheResultEvent(DocsListResult.coldLoading()));
    bloc.add(DocumentsCacheResultEvent(DocsListResult.error('erro')));
    await Future<void>.delayed(Duration.zero);

    expect(states[0], isA<DocumentsLoadingState>());
    expect(states[1], isA<DocumentsEmptyState>());
    expect((states[2] as DocumentsLoadedState).documents, same(docs));
    expect((states[2] as DocumentsLoadedState).freshness, DocsFreshness.fresh);
    expect((states[3] as DocumentsFailureState).error, 'falha');
    expect(states[4], isA<DocumentsFileLoadingState>());
    expect((states[5] as DocumentsFileLoadedState).file.id, 'f');
    expect((states[6] as DocumentsFileFailureState).error, 'arquivo');
    final fresh = states[7] as DocumentsLoadedState;
    expect(fresh.freshness, DocsFreshness.fresh);
    expect(fresh.lastFetchedAt, at);
    expect(states[8], isA<DocumentsEmptyState>());
    expect((states[9] as DocumentsLoadedState).freshness,
        DocsFreshness.staleRevalidating);
    expect((states[10] as DocumentsLoadedState).freshness,
        DocsFreshness.staleFailed);
    expect(states[11], isA<DocumentsLoadingState>());
    expect((states[12] as DocumentsFailureState).error, 'erro');
    await bloc.close();
  });
}
