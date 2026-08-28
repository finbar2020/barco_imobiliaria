import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/core/database/documents/cached_documents_hive_model.dart';
import 'package:shared_features/core/database/documents/cached_documents_store.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

void main() {
  late Directory dir;
  late CachedDocumentsStore store;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('shared_documents_hive');
    Hive.init(dir.path);
    store = CachedDocumentsStore();
  });

  tearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });

  test('ttl de 24 horas', () {
    expect(CachedDocumentsStore.ttl, const Duration(hours: 24));
  });

  test('read devolve null sem cache e upsert grava a entrada', () async {
    expect(await store.read('c1', 'u1', 'boleto'), isNull);
    final now = DateTime(2026, 8, 20, 12);
    await store.upsert('c1', 'u1', 'boleto', '[{"id":1}]', now);

    final entry = await store.read('c1', 'u1', 'boleto');
    expect(entry, isNotNull);
    expect(entry!.key, 'c1|u1|boleto');
    expect(entry.documentsJson, '[{"id":1}]');
    expect(entry.lastFetchedAt, now.millisecondsSinceEpoch);
    expect(entry.lastErrorAt, isNull);
    // chaves distintas por unidade/tipo
    expect(await store.read('c1', '', 'boleto'), isNull);
    expect(await store.read('c1', 'u1', 'ata'), isNull);
    expect(Hive.isAdapterRegistered(CachedDocumentsHiveAdapter().typeId), isTrue);
  });

  test('upsert substitui e limpa o último erro', () async {
    await store.upsert('c1', '', 'ata', '[]', DateTime(2026, 1, 1));
    await store.markFailed('c1', '', 'ata', DateTime(2026, 1, 2));
    expect((await store.read('c1', '', 'ata'))!.lastErrorAt,
        DateTime(2026, 1, 2).millisecondsSinceEpoch);

    await store.upsert('c1', '', 'ata', '[1]', DateTime(2026, 1, 3));
    final entry = (await store.read('c1', '', 'ata'))!;
    expect(entry.documentsJson, '[1]');
    expect(entry.lastFetchedAt, DateTime(2026, 1, 3).millisecondsSinceEpoch);
    expect(entry.lastErrorAt, isNull);
  });

  test('markFailed sem entrada não grava nada', () async {
    await store.markFailed('c1', 'u1', 'x', DateTime(2026, 1, 2));
    expect(await store.read('c1', 'u1', 'x'), isNull);
  });

  test('clear apaga todas as entradas', () async {
    await store.upsert('c1', 'u1', 'a', '[]', DateTime(2026, 1, 1));
    await store.upsert('c2', 'u2', 'b', '[]', DateTime(2026, 1, 1));
    await store.clear();
    expect(await store.read('c1', 'u1', 'a'), isNull);
    expect(await store.read('c2', 'u2', 'b'), isNull);
  });

  test('entrada sobrevive à reabertura da caixa (adaptador gerado)', () async {
    await store.upsert('c1', 'u1', 'a', '[7]', DateTime(2026, 5, 5));
    await store.markFailed('c1', 'u1', 'a', DateTime(2026, 5, 6));
    await Hive.close();
    Hive.init(dir.path);
    final entry = (await CachedDocumentsStore().read('c1', 'u1', 'a'))!;
    expect(entry.documentsJson, '[7]');
    expect(entry.lastFetchedAt, DateTime(2026, 5, 5).millisecondsSinceEpoch);
    expect(entry.lastErrorAt, DateTime(2026, 5, 6).millisecondsSinceEpoch);

    final a = CachedDocumentsHiveAdapter();
    expect(a.typeId, 2);
    expect(a, equals(CachedDocumentsHiveAdapter()));
    expect(a.hashCode, 2.hashCode);
    expect(a == Object(), isFalse);
  });
}
