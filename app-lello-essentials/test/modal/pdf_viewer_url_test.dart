// Cenários da PDFScreen com `url`: o `DefaultCacheManager` é um singleton
// sem injeção, então o sqflite é substituído por uma factory em memória
// (`buildDatabaseFactory`, o gancho de teste do próprio sqflite) e o HTTP por
// um `MockClient` (o singleton é construído dentro de `http.runWithClient`).
import 'dart:io';

import 'package:essentials/modal/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/src/mixin/factory.dart';

import '../helpers/pump_app.dart';
import 'pdf_test_support.dart';

/// Responde às chamadas "nativas" do sqflite: banco vazio que aceita tudo.
final sqlLog = <String>[];

Future<dynamic> _sqliteFalso(String dbPath, String method, [Object? args]) async {
  final mapa = args is Map ? args : const {};
  sqlLog.add('$method ${mapa['sql'] ?? ''}');
  switch (method) {
    case 'openDatabase':
      return {'id': 1};
    case 'query':
      final sql = mapa['sql'] as String? ?? '';
      if (sql.contains('user_version')) {
        return {'columns': ['user_version'], 'rows': [[3]]};
      }
      return {'columns': <String>[], 'rows': <List<Object?>>[]};
    case 'insert':
    case 'update':
      return 1;
    case 'delete':
      return 0;
    case 'getDatabasesPath':
      return dbPath;
    case 'databaseExists':
      return false;
    default:
      return null;
  }
}

void main() {
  late Directory dir;
  late FakePdfrxEntryFunctions pdfrx;
  final requisicoes = <http.Request>[];
  http.Response Function(http.Request) resposta =
      (_) => http.Response('erro', 500);

  setUpAll(() async {
    dir = Directory.systemTemp.createTempSync('pdf_url');
    instalaPathProviderFalso(dir);
    instalaShareFalso();

    databaseFactory = buildDatabaseFactory(
      invokeMethod: (method, [args]) => _sqliteFalso('${dir.path}/dbs', method, args),
    );

    final client = MockClient((req) async {
      requisicoes.add(req);
      return resposta(req);
    });
    http.runWithClient(() => DefaultCacheManager(), () => client);
  });

  tearDownAll(() {
    dir.deleteSync(recursive: true);
  });

  setUp(() {
    pdfrx = instalaPdfrxFalso();
    requisicoes.clear();
  });

  /// O cache manager intercala IO real com microtasks da zona fake: cada
  /// rodada deixa o event loop real andar e depois esvazia a fila fake.
  Future<void> esperaCache(WidgetTester tester) async {
    for (var i = 0; i < 60; i++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 50)));
      await tester.pump();
      if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
    }
    await tester.pump(const Duration(seconds: 1));
  }

  /// Consome o timer de limpeza do cache (10 s) antes de desmontar.
  Future<void> encerra(WidgetTester tester) async {
    await tester.pump(const Duration(seconds: 11));
    // A limpeza intercala sqflite (fake) e IO real: deixa ela terminar para
    // não largar o lock do banco preso para o próximo teste.
    for (var i = 0; i < 10; i++) {
      await tester.runAsync(() => Future.delayed(const Duration(milliseconds: 30)));
      await tester.pump();
    }
    await tester.pumpWidget(const SizedBox());
  }

  testWidgets('mostra o carregamento e depois o erro de download',
      (tester) async {
    resposta = (_) => http.Response('erro', 500);
    await pumpApp(
      tester,
      PDFScreen(url: 'https://x/erro.pdf', title: 'Remoto', headers: const {'h': '1'}),
      wrapInScaffold: false, shrinkWrap: false, settle: false,
    );
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.share), findsNothing);
    expect(find.text('Remoto'), findsOneWidget);

    await esperaCache(tester);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('pdf_load_error'), findsOneWidget);
    expect(requisicoes.single.url.toString(), 'https://x/erro.pdf');
    expect(requisicoes.single.headers['h'], '1');
    await encerra(tester);
  });

  testWidgets('download com sucesso mostra o PDF e libera os botões',
      (tester) async {
    resposta = (_) => http.Response.bytes([0x25, 0x50, 0x44, 0x46], 200,
        headers: {'content-type': 'application/pdf'});
    await pumpApp(
      tester,
      PDFScreen(url: 'https://x/ok.pdf', title: 'Baixado', canDownload: true),
      wrapInScaffold: false, shrinkWrap: false, settle: false,
    );
    await tester.pump();
    await esperaCache(tester);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(PdfViewer), findsOneWidget);
    expect(pdfrx.abertos, isNotEmpty);
    expect(pdfrx.abertos.first, endsWith('.pdf'));
    expect(File(pdfrx.abertos.first).readAsBytesSync(), [0x25, 0x50, 0x44, 0x46]);
    // Depois do primeiro frame o arquivo vai para `fileAfterSnapshotData` e
    // os botões de ação aparecem.
    expect(find.byIcon(Icons.share), findsOneWidget);
    expect(find.byIcon(Icons.download), findsOneWidget);
    await expectLater(
        findGoldenSurface(), matchesGoldenFile('goldens/pdf_viewer_url.png'));
    await encerra(tester);
  });
}
