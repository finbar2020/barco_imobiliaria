import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shared_features/core/database/documents/cached_documents_store.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';

import '../../helpers/firebase_mocks.dart';
import 'documents_support.dart';

void main() {
  late Directory hiveDir;
  late DocumentsHarness harness;

  setUpAll(() async {
    await setUpFakeFirebase();
    installDocumentsCacheManager();
  });

  setUp(() {
    hiveDir = initHiveTemp();
    resetCacheFileServer();
    harness = DocumentsHarness();
  });

  tearDown(() => disposeHive(hiveDir));

  group('DocumentsRemoteDataSourceImpl', () {
    test('com unidade usa a rota da unidade; sem unidade a do condomínio',
        () async {
      harness.stubUnit('2', [documentJson(id: 'd1')]);
      harness.http.on('GET', harness.condoPath('2'),
          body: [documentJson(id: 'd2'), documentJson(id: 'd3')]);

      final unit = await harness.remote.listDocuments('C1', '2', 'U1');
      expect(unit.single.id, 'd1');
      final condo = await harness.remote.listDocuments('C1', '2', '');
      expect(condo.map((d) => d.id), ['d2', 'd3']);
      expect(harness.requestedPaths, [
        '/documents/condominium/C1/type/2/unit/U1',
        '/documents/condominium/C1/type/2',
      ]);
    });

    test('erro da API lança', () async {
      harness.http.failAll();
      expect(() => harness.remote.listDocuments('C1', '2', 'U1'),
          throwsA(anything));
    });
  });

  group('CachedDocumentsStore', () {
    test('upsert, read, markFailed e clear', () async {
      final store = CachedDocumentsStore();
      expect(await store.read('C1', 'U1', '2'), isNull);

      final now = DateTime(2026, 1, 2, 3);
      await store.upsert('C1', 'U1', '2', '[]', now);
      final entry = (await store.read('C1', 'U1', '2'))!;
      expect(entry.key, 'C1|U1|2');
      expect(entry.documentsJson, '[]');
      expect(entry.lastFetchedAt, now.millisecondsSinceEpoch);
      expect(entry.lastErrorAt, isNull);

      final failedAt = DateTime(2026, 1, 3);
      await store.markFailed('C1', 'U1', '2', failedAt);
      expect((await store.read('C1', 'U1', '2'))!.lastErrorAt,
          failedAt.millisecondsSinceEpoch);
      // Sem entrada não faz nada.
      await store.markFailed('X', 'Y', 'Z', failedAt);

      await store.clear();
      expect(await store.read('C1', 'U1', '2'), isNull);
      expect(CachedDocumentsStore.ttl, const Duration(hours: 24));
    });
  });

  group('DocumentsRepositoryImpl.watch', () {
    test('sem cache: coldLoading e depois fresh, gravando o cache', () async {
      harness.stubUnit('2', [documentJson(id: 'd1'), documentJson(id: 'd2')]);

      final results = await harness.repository.watch('C1', '2', 'U1').toList();

      expect(results.map((r) => r.freshness),
          [DocsFreshness.coldLoading, DocsFreshness.fresh]);
      expect(results.last.docs.map((d) => d.id), ['d1', 'd2']);
      expect(results.last.lastFetchedAt, isNotNull);

      final cached = (await harness.cacheStore.read('C1', 'U1', '2'))!;
      final decoded = jsonDecode(cached.documentsJson) as List;
      expect(decoded, hasLength(2));
      expect(decoded.first['id'], 'd1');
    });

    test('sem cache e com erro: coldLoading e depois error', () async {
      harness.http.failAll();
      final results = await harness.repository.watch('C1', '2', 'U1').toList();
      expect(results.map((r) => r.freshness),
          [DocsFreshness.coldLoading, DocsFreshness.error]);
      expect(results.last.error, isNotNull);
      expect(await harness.cacheStore.read('C1', 'U1', '2'), isNull);
    });

    test('cache fresco: só fresh, sem chamar a API', () async {
      await harness.cacheStore.upsert('C1', 'U1', '2',
          jsonEncode([documentJson(id: 'cache')]), DateTime.now());

      final results = await harness.repository.watch('C1', '2', 'U1').toList();

      expect(results.single.freshness, DocsFreshness.fresh);
      expect(results.single.docs.single.id, 'cache');
      expect(harness.http.requests, isEmpty);
    });

    test('cache fresco com forceRefresh revalida', () async {
      await harness.cacheStore.upsert('C1', 'U1', '2',
          jsonEncode([documentJson(id: 'cache')]), DateTime.now());
      harness.stubUnit('2', [documentJson(id: 'novo')]);

      final results = await harness.repository
          .watch('C1', '2', 'U1', forceRefresh: true)
          .toList();

      expect(results.map((r) => r.freshness),
          [DocsFreshness.staleRevalidating, DocsFreshness.fresh]);
      expect(results.first.docs.single.id, 'cache');
      expect(results.last.docs.single.id, 'novo');
    });

    test('cache velho: staleRevalidating e depois fresh', () async {
      final old = DateTime.now().subtract(const Duration(days: 2));
      await harness.cacheStore.upsert(
          'C1', 'U1', '2', jsonEncode([documentJson(id: 'cache')]), old);
      harness.stubUnit('2', [documentJson(id: 'novo')]);

      final results = await harness.repository.watch('C1', '2', 'U1').toList();

      expect(results.map((r) => r.freshness),
          [DocsFreshness.staleRevalidating, DocsFreshness.fresh]);
      expect(results.first.lastFetchedAt!.millisecondsSinceEpoch,
          old.millisecondsSinceEpoch);
      expect(
          (await harness.cacheStore.read('C1', 'U1', '2'))!.lastFetchedAt >
              old.millisecondsSinceEpoch,
          isTrue);
    });

    test('cache velho com erro: staleFailed e marca a falha', () async {
      final old = DateTime.now().subtract(const Duration(days: 2));
      await harness.cacheStore.upsert(
          'C1', 'U1', '2', jsonEncode([documentJson(id: 'cache')]), old);
      harness.http.failAll();

      final results = await harness.repository.watch('C1', '2', 'U1').toList();

      expect(results.map((r) => r.freshness),
          [DocsFreshness.staleRevalidating, DocsFreshness.staleFailed]);
      expect(results.last.docs.single.id, 'cache');
      expect(results.last.error, isNotNull);
      expect((await harness.cacheStore.read('C1', 'U1', '2'))!.lastErrorAt,
          isNotNull);
    });
  });

  group('downloadFile / getExtractedText (cache manager real)', () {
    test('baixa o PDF com o header de autenticação e grava em disco',
        () async {
      final result = await harness.repository.downloadFile('d1', '2');

      final file = (result as Success<File>).get();
      expect(file.existsSync(), isTrue);
      expect(file.path, endsWith('.pdf'));
      expect(file.readAsStringSync(), '%PDF-1.4');
      final request = cacheFileRequests.single;
      expect(request.url.toString(),
          'http://localhost/documents/type/2/d1/downloadRaw');
      expect(request.headers['Authorization'], 'Bearer t');

      // Segunda chamada vem do cache em disco.
      final again = await harness.repository.downloadFile('d1', '2');
      expect((again as Success<File>).get().path, file.path);
      expect(cacheFileRequests, hasLength(1));
    });

    test('lê o texto extraído', () async {
      cacheFileHandler = (request) => http.Response('texto do documento', 200,
          headers: const {'content-type': 'text/plain'});

      final result = await harness.repository.getExtractedText('d7', '3');

      expect((result as Success<String>).get(), 'texto do documento');
      expect(cacheFileRequests.single.url.path,
          '/documents/type/3/d7/extractedText');
    });

    test('erro do servidor vira Rejection', () async {
      cacheFileHandler = (request) => http.Response('nope', 500);

      final download = await harness.repository.downloadFile('erro', '2');
      expect(download, isA<Rejection>());
      expect((download as Rejection).get(), isA<UnknownFailure>());

      final text = await harness.repository.getExtractedText('erro', '2');
      expect(text, isA<Rejection>());
    });
  });
}
