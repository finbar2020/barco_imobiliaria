// Apoio dos testes de `feature/documents`: sessão compartilhada falsa, Hive
// em diretório temporário (o `CachedDocumentsStore` é real), sqflite em
// memória + path_provider falso + HTTP falso para o `DocumentsCacheManager`
// (flutter_cache_manager) gravar os PDFs de verdade, e harness com as classes
// REAIS (API chopper → data source → repositório → use cases →
// bloc/controller) ligadas ao `FakeHttp`.
import 'dart:async';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:share_plus_platform_interface/share_plus_platform_interface.dart';
import 'package:shared_features/core/database/documents/cached_documents_store.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_api.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_cache_manager.dart';
import 'package:shared_features/feature/documents/data/data_source/documents_remote_data_source_impl.dart';
import 'package:shared_features/feature/documents/data/repository/documents_repository_impl.dart';
import 'package:shared_features/feature/documents/domain/entity/documents.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_list_result.dart';
import 'package:shared_features/feature/documents/domain/entity/documents_type.dart';
import 'package:shared_features/feature/documents/domain/repository/documents_repository.dart';
import 'package:shared_features/feature/documents/domain/use_case/download_document/download_document_impl.dart';
import 'package:shared_features/feature/documents/domain/use_case/get_extracted_text/get_extracted_text_impl.dart';
import 'package:shared_features/feature/documents/presentation/bloc/documents_bloc.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_analytics.dart';
import 'package:shared_features/feature/documents/presentation/controllers/documents_controller.dart';
import 'package:shared_features/shared_features.dart';
import 'package:sqflite/sqflite.dart' as sql;
// ignore: implementation_imports
import 'package:sqflite_common/src/factory.dart' show SqfliteDatabaseFactory;

import '../../helpers/fake_http.dart';
import '../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Sessão, ambiente e autenticação
// ---------------------------------------------------------------------------

class FakeSharedSession implements SharedSession {
  FakeSharedSession({
    this.condominiumId = 'C1',
    this.condominiumReference = 'R1',
    this.userId = 'ME1',
    this.unitId = 'U1',
  });

  @override
  String condominiumId;
  @override
  String condominiumReference;
  @override
  String userId;
  @override
  String unitId;
}

class TestEnvironment extends Environment {
  TestEnvironment({String apiUrl = 'http://localhost'})
      : super(isProduction: false, apiUrl: apiUrl, name: 'test');
}

class FakeAuthenticationStore extends Fake implements AuthenticationStore {
  FakeAuthenticationStore({this.header = const {'Authorization': 'Bearer t'}});
  final Map<String, String>? header;

  @override
  Map<String, String>? getCustomHeader() => header;
}

/// Analytics de documentos que só registra as chamadas.
class RecordingDocumentsAnalytics implements DocumentsAnalytics {
  final accesses = <String>[];
  final shares = <String>[];

  @override
  void logAccess(String documentType) => accesses.add(documentType);

  @override
  void logShare(String documentType) => shares.add(documentType);
}

// ---------------------------------------------------------------------------
// Hive
// ---------------------------------------------------------------------------

Directory initHiveTemp() {
  final dir = Directory.systemTemp.createTempSync('shared_documents');
  Hive.init(dir.path);
  return dir;
}

Future<void> disposeHive(Directory dir) async {
  await Hive.close();
  if (dir.existsSync()) dir.deleteSync(recursive: true);
}

// ---------------------------------------------------------------------------
// path_provider, share_plus
// ---------------------------------------------------------------------------

class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;

  @override
  Future<String?> getTemporaryPath() async => dir.path;

  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

class FakeSharePlatform extends SharePlatform with MockPlatformInterfaceMixin {
  final shared = <ShareParams>[];

  @override
  Future<ShareResult> share(ShareParams params) async {
    shared.add(params);
    return const ShareResult('ok', ShareResultStatus.success);
  }
}

// ---------------------------------------------------------------------------
// sqflite em memória (o flutter_cache_manager guarda o índice do cache em
// uma tabela sqflite no macOS/iOS/Android)
// ---------------------------------------------------------------------------

/// O setter `databaseFactory` só aceita um `SqfliteDatabaseFactory`.
class MemoryDatabaseFactory extends Fake implements SqfliteDatabaseFactory {
  MemoryDatabaseFactory(this.databasesPath);
  final String databasesPath;
  final databases = <String, MemoryDatabase>{};

  @override
  Future<sql.Database> openDatabase(String path,
      {sql.OpenDatabaseOptions? options}) async {
    final db = databases.putIfAbsent(path, MemoryDatabase.new);
    if (!db.created) {
      db.created = true;
      await options?.onCreate?.call(db, options.version ?? 1);
    }
    db.open = true;
    return db;
  }

  @override
  Future<String> getDatabasesPath() async => databasesPath;
}

/// Tabela única em memória com o subconjunto de SQL que o
/// `CacheObjectProvider` usa (`col = ?`, `col < ?`, `col IN (...)`,
/// orderBy/limit/offset).
class MemoryDatabase extends Fake implements sql.Database {
  final rows = <Map<String, Object?>>[];
  int _nextId = 1;
  bool created = false;
  bool open = false;

  @override
  bool get isOpen => open;

  @override
  Future<void> close() async => open = false;

  @override
  Future<void> execute(String sql, [List<Object?>? arguments]) async {}

  @override
  Future<int> insert(String table, Map<String, Object?> values,
      {String? nullColumnHack, sql.ConflictAlgorithm? conflictAlgorithm}) async {
    final row = Map<String, Object?>.of(values);
    row['_id'] = _nextId++;
    rows.add(row);
    return row['_id'] as int;
  }

  List<Map<String, Object?>> _filter(String? where, List<Object?>? whereArgs) {
    if (where == null) return List.of(rows);
    final w = where.trim();
    var m = RegExp(r'^(\w+) = \?$').firstMatch(w);
    if (m != null) {
      return rows.where((r) => r[m!.group(1)] == whereArgs![0]).toList();
    }
    m = RegExp(r'^(\w+) < \?$').firstMatch(w);
    if (m != null) {
      return rows
          .where((r) =>
              ((r[m!.group(1)] as num?) ?? 0) < (whereArgs![0] as num))
          .toList();
    }
    m = RegExp(r'^(\w+) IN \((.*)\)$').firstMatch(w);
    if (m != null) {
      final ids = m
          .group(2)!
          .split(',')
          .where((s) => s.trim().isNotEmpty)
          .map((s) => int.parse(s.trim()))
          .toSet();
      return rows.where((r) => ids.contains(r[m!.group(1)])).toList();
    }
    throw UnsupportedError('where não suportado: $where');
  }

  @override
  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    var result = _filter(where, whereArgs);
    if (orderBy != null) {
      final parts = orderBy.split(' ');
      final col = parts[0];
      final desc = parts.length > 1 && parts[1].toUpperCase() == 'DESC';
      result.sort((a, b) {
        final c = ((a[col] as num?) ?? 0).compareTo((b[col] as num?) ?? 0);
        return desc ? -c : c;
      });
    }
    if (offset != null) result = result.skip(offset).toList();
    if (limit != null) result = result.take(limit).toList();
    return result.map((r) => Map<String, Object?>.of(r)).toList();
  }

  @override
  Future<int> update(String table, Map<String, Object?> values,
      {String? where,
      List<Object?>? whereArgs,
      sql.ConflictAlgorithm? conflictAlgorithm}) async {
    final targets = _filter(where, whereArgs);
    for (final t in targets) {
      t.addAll(values);
    }
    return targets.length;
  }

  @override
  Future<int> delete(String table,
      {String? where, List<Object?>? whereArgs}) async {
    final targets = _filter(where, whereArgs);
    rows.removeWhere(targets.contains);
    return targets.length;
  }
}

// ---------------------------------------------------------------------------
// DocumentsCacheManager (singleton) com HTTP falso
// ---------------------------------------------------------------------------

/// Resposta do servidor de arquivos para o cache manager. Trocável por teste.
http.Response Function(http.Request request) cacheFileHandler = (request) =>
    http.Response.bytes(
      [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34], // %PDF-1.4
      200,
      headers: const {'content-type': 'application/pdf'},
    );

/// Requisições recebidas pelo servidor de arquivos.
final cacheFileRequests = <http.Request>[];

bool _cacheManagerInstalled = false;
late Directory _cacheDir;

/// Prepara path_provider, sqflite em memória e o HTTP falso e cria o
/// singleton `DocumentsCacheManager` dentro do `http.runWithClient` (o
/// `HttpFileService` captura o `http.Client()` do zone na construção).
/// Idempotente por isolate.
Directory installDocumentsCacheManager() {
  if (_cacheManagerInstalled) return _cacheDir;
  _cacheManagerInstalled = true;
  _cacheDir = Directory.systemTemp.createTempSync('shared_documents_cache');
  PathProviderPlatform.instance = FakePathProvider(_cacheDir);
  sql.databaseFactory = MemoryDatabaseFactory(_cacheDir.path);
  http.runWithClient(
    () => DocumentsCacheManager(),
    () => MockClient((request) async {
      cacheFileRequests.add(request);
      return cacheFileHandler(request);
    }),
  );
  return _cacheDir;
}

/// Volta o servidor de arquivos ao padrão (PDF mínimo) e limpa o histórico.
void resetCacheFileServer() {
  cacheFileRequests.clear();
  cacheFileHandler = (request) => http.Response.bytes(
        [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34],
        200,
        headers: const {'content-type': 'application/pdf'},
      );
}

// ---------------------------------------------------------------------------
// Repositório falso (fluxo controlado) para controller e páginas
// ---------------------------------------------------------------------------

class FakeDocumentsRepository extends Fake implements DocumentsRepository {
  /// Resultados emitidos pelo `watch` (em ordem).
  List<DocsListResult> results = [];

  /// Registro das chamadas: `[condominiumId, documentType, unitId, force]`.
  final watchCalls = <List<Object?>>[];
  final downloadCalls = <List<String>>[];
  final textCalls = <List<String>>[];

  Try<File> Function()? download;
  Try<String> Function()? text;

  @override
  Stream<DocsListResult> watch(
    String condominiumId,
    String documentType,
    String unitId, {
    bool forceRefresh = false,
  }) {
    watchCalls.add([condominiumId, documentType, unitId, forceRefresh]);
    return Stream.fromIterable(List.of(results));
  }

  @override
  Future<Try<File>> downloadFile(String documentId, String documentType) async {
    downloadCalls.add([documentId, documentType]);
    return download?.call() ?? Rejection(UnknownFailure('sem download'));
  }

  @override
  Future<Try<String>> getExtractedText(
      String documentId, String documentType) async {
    textCalls.add([documentId, documentType]);
    return text?.call() ?? Rejection(UnknownFailure('sem texto'));
  }
}

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

class DocumentsHarness {
  DocumentsHarness({
    FakeSharedSession? session,
    DocumentsRepository? repository,
    DocumentsAnalytics? analytics,
  })  : session = session ?? FakeSharedSession(),
        analytics = analytics ?? RecordingDocumentsAnalytics() {
    api = DocumentsApi.create(buildChopperClient(http));
    remote = DocumentsRemoteDataSourceImpl(api: api);
    cacheStore = CachedDocumentsStore();
    this.repository = repository ??
        DocumentsRepositoryImpl(
          remoteDataSource: remote,
          cacheStore: cacheStore,
          environment: TestEnvironment(),
          authenticationStore: FakeAuthenticationStore(),
        );
    container.register<AuthenticationStore>(FakeAuthenticationStore());
  }

  final FakeSharedSession session;
  final DocumentsAnalytics analytics;
  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  late final DocumentsApi api;
  late final DocumentsRemoteDataSourceImpl remote;
  late final CachedDocumentsStore cacheStore;
  late final DocumentsRepository repository;
  DocumentsController? controller;

  DocumentsController buildController({DocumentsBloc? bloc}) {
    final c = DocumentsController(
      bloc: bloc ?? DocumentsBloc(),
      repository: repository,
      downloadDocument: DownloadDocumentImpl(repository: repository),
      getExtractedText: GetExtractedTextImpl(repository: repository),
      session: session,
      analytics: analytics,
    );
    controller = c;
    return c;
  }

  String unitPath(String type, {String unit = 'U1'}) =>
      '/documents/condominium/C1/type/$type/unit/$unit';

  String condoPath(String type) => '/documents/condominium/C1/type/$type';

  void stubUnit(String type, List<Map<String, dynamic>> docs) =>
      http.on('GET', unitPath(type), body: docs);

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> documentJson({
  String id = 'd1',
  String? name = 'Ata da assembleia',
  String? description = 'Descrição',
  String? content = 'conteúdo',
  String? createdAt = '2026-01-10T00:00:00',
  bool? flagEmail = true,
  bool? flagPrint = false,
  int? pages = 3,
  String? status = 'ATIVO',
  String? notificationParameter = 'np1',
  String? documentsType = 'atas',
}) =>
    {
      'id': id,
      'name': name,
      'description': description,
      'content': content,
      'created_at': createdAt,
      'flag_email_distribution': flagEmail,
      'flag_print_distribution': flagPrint,
      'pages_quantity': pages,
      'status': status,
      'notification_parameter': notificationParameter,
      'documents_type': documentsType,
    };

Documents buildDocument({
  String id = 'd1',
  String? name = 'Ata da assembleia',
  String? notificationParameter = 'np1',
  DocumentsType? type = DocumentsType.atas,
}) =>
    Documents()
      ..id = id
      ..name = name
      ..notificationParameter = notificationParameter
      ..documentsType = type
      ..createdAt = '2026-01-10T00:00:00';

/// Grava um PDF mínimo em [dir] e devolve o arquivo.
File writePdf(Directory dir, [String name = 'doc.pdf']) =>
    File('${dir.path}/$name')..writeAsStringSync('%PDF-1.4 teste');

/// Tipo usado na maioria dos testes e o número que a API espera.
const minutesType = 'documents_minutes';
const minutesApi = '2';
