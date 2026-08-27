// Apoio dos testes de `feature/authentication`: Hive em diretório
// temporário, Firebase Auth falso, servidor HTTP local para o Dio do
// refresh token, container de teste com as classes REAIS (API chopper, data
// sources, repositórios, use cases, bloc e store) ligadas ao `FakeHttp` e
// fixtures de JSON do token.
import 'dart:convert';
import 'dart:io';

import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_features/feature/authentication/data/data_source/remote/authentication_api.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_model.dart';
import 'package:shared_features/feature/authentication/data/model/access_token_request_model.dart';
import 'package:shared_features/feature/authentication/data/model/refresh_token_request_model.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/fake_http.dart';
import '../../helpers/test_container.dart';

// ---------------------------------------------------------------------------
// Hive
// ---------------------------------------------------------------------------

/// Aponta o Hive para um diretório temporário novo e fecha/apaga tudo no fim
/// do teste. Chame no `setUp` (fora do fake async).
Directory initHiveTemp() {
  final dir = Directory.systemTemp.createTempSync('shared_auth_hive');
  Hive.init(dir.path);
  addTearDown(() async {
    await Hive.close();
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

// ---------------------------------------------------------------------------
// Firebase Auth falso
// ---------------------------------------------------------------------------

/// `FirebaseAuthPlatform` falso: registra os tokens de `signInWithCustomToken`.
/// O `FirebaseAuth.instance` guarda o delegate na primeira resolução, então
/// instale UMA vez por arquivo e troque só [fail].
class FakeFirebaseAuthPlatform extends FirebaseAuthPlatform
    with MockPlatformInterfaceMixin {
  final tokens = <String>[];
  bool fail = false;

  @override
  FirebaseAuthPlatform delegateFor({required FirebaseApp app}) => this;

  @override
  FirebaseAuthPlatform setInitialValues({
    InternalUserDetails? currentUser,
    String? languageCode,
  }) =>
      this;

  @override
  Future<UserCredentialPlatform> signInWithCustomToken(String token) async {
    tokens.add(token);
    if (fail) throw StateError('firebase auth falhou');
    return _FakeUserCredential(this);
  }
}

class _FakeUserCredential extends UserCredentialPlatform {
  _FakeUserCredential(FirebaseAuthPlatform auth) : super(auth: auth);
}

FakeFirebaseAuthPlatform? _firebaseAuth;

/// Instala (uma vez por processo) o Firebase Auth falso e o devolve zerado.
FakeFirebaseAuthPlatform installFakeFirebaseAuth() {
  final fake = _firebaseAuth ??= FakeFirebaseAuthPlatform();
  FirebaseAuthPlatform.instance = fake;
  fake.tokens.clear();
  fake.fail = false;
  return fake;
}

// ---------------------------------------------------------------------------
// Fakes simples
// ---------------------------------------------------------------------------

/// `AuthenticateFirebase` falso para os use cases que só precisam do
/// resultado.
class FakeAuthenticateFirebase extends Fake implements AuthenticateFirebase {
  bool fail = false;
  final tokens = <String>[];

  @override
  Future<Try<bool>> call(String params) async {
    tokens.add(params);
    if (fail) return Rejection(UnknownFailure('firebase'));
    return Success(true);
  }
}

/// Repositório `dynamic` (pendências/sessão) com `clear()`.
class FakeClearable {
  int clears = 0;
  Future<void> clear() async => clears++;
}

/// Data source local em memória (sem Hive) para os testes de widget, onde IO
/// real travaria o fake async.
class InMemoryAccessTokenLocalDataSource extends AccessTokenLocalDataSource {
  final tokens = <String, AccessTokenModel>{};
  String? lastRole;
  bool throwOnSelect = false;
  bool throwOnSave = false;
  final savedRoles = <String>[];

  @override
  Future<AccessTokenModel?> select({required String role}) async {
    if (throwOnSelect) throw StateError('select falhou');
    final key = role.isEmpty ? (lastRole ?? '') : role;
    return tokens[key];
  }

  @override
  Future<AccessTokenModel?> save(AccessTokenModel? token,
      {required String role}) async {
    if (throwOnSave) throw StateError('save falhou');
    savedRoles.add(role);
    if (token == null) {
      tokens.clear();
      lastRole = null;
      return null;
    }
    tokens[role] = token;
    lastRole = role;
    return token;
  }
}

/// Data source remoto que sempre lança (cobre os `catch` genéricos).
class ThrowingAccessTokenRemoteDataSource extends Fake
    implements AccessTokenRemoteDataSource {
  @override
  Future<AccessTokenModel?> post(AccessTokenRequestModel model) async =>
      throw StateError('boom');

  @override
  Future<AccessTokenModel?> postInvite(AccessTokenRequestModel model) async =>
      throw StateError('boom');

  @override
  Future<AccessTokenModel?> switchRoles(String id) async =>
      throw StateError('boom');

  @override
  Future<String?> deleteAccount() async => throw StateError('boom');
}

/// Data source remoto que devolve um [ApiFailure] configurável.
class ApiFailureAccessTokenRemoteDataSource extends Fake
    implements AccessTokenRemoteDataSource {
  ApiFailureAccessTokenRemoteDataSource(this.failure);
  final ApiFailure failure;

  @override
  Future<AccessTokenModel?> post(AccessTokenRequestModel model) async =>
      throw failure;

  @override
  Future<AccessTokenModel?> postInvite(AccessTokenRequestModel model) async =>
      throw failure;

  @override
  Future<AccessTokenModel?> switchRoles(String id) async => throw failure;
}

class FakeRefreshTokenRemoteDataSource extends Fake
    implements RefreshTokenRemoteDataSource {
  Object? error;
  AccessTokenModel? result;
  final requests = <RefreshTokenRequestModel>[];

  @override
  Future<AccessTokenModel?> refreshToken(RefreshTokenRequestModel model) async {
    requests.add(model);
    if (error != null) throw error!;
    return result ?? AccessTokenModel.fromJson(tokenJson(accessToken: 'jwt-2'));
  }
}

class FakeAccessTokenRepository extends Fake implements AccessTokenRepository {
  Try<AccessToken?> postResult = Success(buildToken());
  Try<AccessToken?> postInviteResult = Success(buildToken());
  Try<AccessToken?> switchResult = Success(buildToken());
  Try<AccessToken?> saveResult = Success(buildToken(accessToken: 'salvo'));
  Try<AccessToken?> selectResult = Success(buildToken());
  Try<String?> deleteResult = Success('');
  final saved = <AccessToken?>[];
  final savedRoles = <String?>[];
  final selectedRoles = <String?>[];
  final posted = <Credentials>[];
  final switched = <String>[];
  bool throwOnSave = false;

  @override
  Future<Try<AccessToken?>> select({String? role}) async {
    selectedRoles.add(role);
    return selectResult;
  }

  @override
  Future<Try<AccessToken?>> save(AccessToken? token, {String? role}) async {
    if (throwOnSave) throw StateError('save');
    saved.add(token);
    savedRoles.add(role);
    return saveResult;
  }

  @override
  Future<Try<AccessToken?>> post(Credentials credentials) async {
    posted.add(credentials);
    return postResult;
  }

  @override
  Future<Try<AccessToken?>> postInvite(Credentials credentials) async {
    posted.add(credentials);
    return postInviteResult;
  }

  @override
  Future<Try<AccessToken?>> switchRoles(String id) async {
    switched.add(id);
    return switchResult;
  }

  @override
  Future<Try<Nothing>> clear() async => Success(Nothing());

  @override
  Future<Try<String?>> deleteAccount() async => deleteResult;
}

class FakeRefreshTokenRepository extends Fake
    implements RefreshTokenRepository {
  Try<AccessToken?> refreshResult = Success(buildToken(accessToken: 'jwt-2'));
  Try<AccessToken?> saveResult = Success(buildToken(accessToken: 'salvo'));
  bool throwOnRefresh = false;
  int clears = 0;
  final saved = <AccessToken?>[];

  @override
  Future<Try<AccessToken?>> refreshToken() async {
    if (throwOnRefresh) throw StateError('refresh');
    return refreshResult;
  }

  @override
  Future<Try<AccessToken?>> save(AccessToken? token, {String? role}) async {
    saved.add(token);
    return saveResult;
  }

  @override
  Future<Try<Nothing>> clear() async {
    clears++;
    return Success(Nothing());
  }
}

class FakeAuthenticate extends Fake implements Authenticate {
  Try<AccessToken?> result = Success(buildToken());
  final calls = <Credentials>[];

  @override
  Future<Try<AccessToken?>> call(Credentials params) async {
    calls.add(Credentials(username: params.username, password: params.password));
    return result;
  }
}

class FakeLogout extends Fake implements Logout {
  Try<Nothing> result = Success(Nothing());
  int calls = 0;

  @override
  Future<Try<Nothing>> call() async {
    calls++;
    return result;
  }
}

class FakeGetToken extends Fake implements GetToken {
  Try<AccessToken?> result = Success(buildToken());
  final params = <GetTokenParams?>[];

  @override
  Future<Try<AccessToken?>> call(GetTokenParams? p) async {
    params.add(p);
    return result;
  }
}

class FakeSwitchRoles extends Fake implements SwitchRoles {
  @override
  Future<Try<AccessToken?>> call(SwitchParams params) async =>
      Success(buildToken());
}

class TestEnvironment extends Environment {
  TestEnvironment()
      : super(isProduction: false, apiUrl: 'http://localhost', name: 'teste');
}

// ---------------------------------------------------------------------------
// Servidor HTTP local (para o Dio do refresh token)
// ---------------------------------------------------------------------------

typedef LocalHandler = Future<void> Function(HttpRequest request);

/// O `TestWidgetsFlutterBinding` troca o `HttpOverrides.global` por um
/// cliente que responde 400 a tudo; este override devolve o `HttpClient`
/// real para falar com o servidor local.
class RealHttpOverrides extends HttpOverrides {}

/// Roda [body] com o `HttpClient` real (necessário para o Dio alcançar o
/// [LocalHttpServer] depois de o binding de teste ser inicializado).
Future<T> withRealHttp<T>(Future<T> Function() body) =>
    HttpOverrides.runWithHttpOverrides(body, RealHttpOverrides());

/// Servidor HTTP real em `127.0.0.1` com um [handler] trocável por teste.
class LocalHttpServer {
  LocalHttpServer._(this.server);
  final HttpServer server;
  final requests = <HttpRequest>[];
  final bodies = <String>[];
  LocalHandler handler = (req) async {
    req.response.statusCode = 404;
    await req.response.close();
  };

  static Future<LocalHttpServer> start() async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final local = LocalHttpServer._(server);
    server.listen((request) async {
      local.requests.add(request);
      local.bodies.add(await utf8.decoder.bind(request).join());
      await local.handler(request);
    });
    addTearDown(() => server.close(force: true));
    return local;
  }

  String get baseUrl => 'http://127.0.0.1:${server.port}';

  /// Responde JSON com [status].
  void respondJson(Object body, {int status = 200}) {
    handler = (req) async {
      req.response.statusCode = status;
      req.response.headers.contentType = ContentType.json;
      req.response.write(jsonEncode(body));
      await req.response.close();
    };
  }

  /// Responde texto puro (sem JSON) com [status].
  void respondText(String body, {int status = 500}) {
    handler = (req) async {
      req.response.statusCode = status;
      req.response.headers.contentType = ContentType.text;
      req.response.write(body);
      await req.response.close();
    };
  }
}

// ---------------------------------------------------------------------------
// Harness
// ---------------------------------------------------------------------------

/// Classes reais da feature ligadas ao [http] falso. O data source local é
/// escolhido pelo teste (Hive real ou memória).
class AuthenticationHarness {
  AuthenticationHarness({AccessTokenLocalDataSource? local})
      : localDataSource = local ?? InMemoryAccessTokenLocalDataSource() {
    api = AuthenticationApi.create(buildChopperClient(http));
    remoteDataSource = AccessTokenRemoteDataSourceImpl(api: api);
    repository = AccessTokenRepositoryImpl(
        remoteDataSource: remoteDataSource, dataSource: localDataSource);
  }

  final FakeHttp http = FakeHttp();
  final TestSharedContainer container = TestSharedContainer();
  final AccessTokenLocalDataSource localDataSource;
  final FakeAuthenticateFirebase firebase = FakeAuthenticateFirebase();
  final FakeClearable pendencies = FakeClearable();
  final FakeClearable session = FakeClearable();
  late final AuthenticationApi api;
  late final AccessTokenRemoteDataSourceImpl remoteDataSource;
  late final AccessTokenRepositoryImpl repository;

  AuthenticationStore? lastStore;

  Authenticate get authenticate =>
      AuthenticateImpl(repository: repository, authenticateFirebase: firebase);

  Logout get logout => LogoutImpl(
      repository: repository,
      pendencyRepository: pendencies,
      sessionRepository: session);

  GetToken get getToken => GetTokenImpl(repository: repository);

  SwitchRoles get switchRoles =>
      SwitchRolesImpl(repository: repository, authenticateFirebase: firebase);

  /// Store real com um bloc novo (crie dentro do `testWidgets`).
  AuthenticationStore buildStore({
    AppOriginEnum? appOrigin,
    ConnectionController? connectionController,
    AuthenticationBloc? bloc,
  }) {
    final store = AuthenticationStore(
      bloc: bloc ?? AuthenticationBloc(),
      authenticateUsecase: authenticate,
      logoutUsecase: logout,
      getToken: getToken,
      switchRoles: switchRoles,
      appOrigin: appOrigin,
      connectionController: connectionController,
    );
    lastStore = store;
    return store;
  }

  // Rotas ------------------------------------------------------------------

  void mockToken({int status = 200, Object? body}) =>
      http.on('POST', '/tokenrbac', status: status, body: body ?? tokenJson());

  void mockInvite({int status = 200, Object? body}) =>
      http.on('POST', '/tokenConvite',
          status: status, body: body ?? tokenJson());

  void mockSwitch(String ref, {int status = 200, Object? body}) =>
      http.on('POST', '/token/$ref', status: status, body: body ?? tokenJson());

  void mockDelete({int status = 200, Object? body = const {}}) =>
      http.on('DELETE', '/me/deleteAccount', status: status, body: body);

  List<String> get requestedPaths =>
      http.requests.map((r) => r.url.path).toList();
}

// ---------------------------------------------------------------------------
// Fixtures
// ---------------------------------------------------------------------------

Map<String, dynamic> tokenJson({
  String? accessToken = 'jwt-1',
  String? refreshToken = 'refresh-1',
  String? firebaseToken = 'fb-1',
  String? userId = 'u1',
  int? expiresIn = 1700000000,
  List<Map<String, dynamic>>? roles = const [
    {'context': 'CONDO-1', 'role_name': 'SINDICO'},
    {'context': 'CONDO-2', 'role_name': 'MORADOR'},
  ],
  String? selectedRole = 'SINDICO',
  List<String>? permissions = const ['home.menu.item', 'home.banner'],
  List<String>? custom,
}) =>
    {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'firebase_token': firebaseToken,
      'user_id': userId,
      'expires_in': expiresIn,
      'roles': roles,
      'selected_role': selectedRole,
      'selected_role_permissions': permissions,
      'custom_role_permissions': custom,
    };

/// Corpo de erro no formato do `ApiFailure`.
Map<String, dynamic> apiFailureBody({
  int status = 500,
  String? failure,
  String? title = 'erro',
  String? detail,
}) =>
    {
      'status': status,
      'title': title,
      'detail': detail,
      'failure': failure,
      'message': 'mensagem',
    };

AccessToken buildToken({
  String? accessToken = 'jwt-1',
  String? refreshToken = 'refresh-1',
  String? firebaseToken = 'fb-1',
  List<String>? permissions = const ['home.menu.item'],
  List<String>? custom,
  DateTime? expiresIn,
}) =>
    AccessToken()
      ..accessToken = accessToken
      ..refreshToken = refreshToken
      ..firebaseToken = firebaseToken
      ..userId = 'u1'
      ..expiresIn = expiresIn
      ..roles = [Role(context: 'CONDO-1', roleName: 'SINDICO')]
      ..selectedRole = 'SINDICO'
      ..selectedRolePermissions = permissions
      ..customRolePermissions = custom;

ApiFailure buildApiFailure({int? status, String? failure, String? title}) =>
    ApiFailure()
      ..status = status
      ..failure = failure
      ..title = title;
