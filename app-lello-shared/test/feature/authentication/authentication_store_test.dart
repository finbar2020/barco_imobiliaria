import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/firebase_mocks.dart';
import 'authentication_support.dart';

class _FakeConnectionController extends Fake implements ConnectionController {
  int starts = 0;

  @override
  Future<void> starCheckConnection() async => starts++;
}

void main() {
  late AuthenticationBloc bloc;
  late FakeAuthenticate authenticate;
  late FakeLogout logout;
  late FakeGetToken getToken;
  late List<AuthenticationState> states;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    initHiveTemp();
    bloc = AuthenticationBloc();
    authenticate = FakeAuthenticate();
    logout = FakeLogout();
    getToken = FakeGetToken();
    states = [];
    bloc.stream.listen(states.add);
  });

  tearDown(() => bloc.close());

  AuthenticationStore build({
    AppOriginEnum? appOrigin,
    ConnectionController? connection,
  }) =>
      AuthenticationStore(
        bloc: bloc,
        authenticateUsecase: authenticate,
        logoutUsecase: logout,
        getToken: getToken,
        switchRoles: FakeSwitchRoles(),
        appOrigin: appOrigin,
        connectionController: connection,
      );

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('com controller de conexão inicia a verificação periódica', () {
    final connection = _FakeConnectionController();
    build(connection: connection);
    expect(connection.starts, 1);

    final store = build();
    expect(store.connectionController, isNull);
    expect(store.isTabletSession, isFalse);
    expect(store.credentials.username, '');
  });

  test('authenticate com sucesso emite autenticando e autenticado', () async {
    final store = build()
      ..credentials = Credentials(username: 'u', password: 'p');

    await store.authenticate();
    await settle();

    expect(authenticate.calls.single.username, 'u');
    expect(states.first, const AuthenticatingState());
    final authenticated = states.last as AuthenticatedState;
    expect(authenticated.accessToken.accessToken, 'jwt-1');
    expect(authenticated.onLogin, isTrue);
    expect(store.isTabletSession, isFalse);
  });

  test('authenticate com falha emite o estado de falha', () async {
    final failure = InvalidCredentialsFailure('x', null);
    authenticate.result = Rejection(failure);

    await build().authenticate();
    await settle();

    expect(states.last, AuthenticationFailedState(error: failure));
  });

  test('no colaborador em sessão de tablet guarda a data de início',
      () async {
    await TabletSessionUtils.setCondoCode('C1');
    final store = build(appOrigin: AppOriginEnum.employee);

    await store.authenticate();
    await settle();

    expect(store.isTabletSession, isTrue);
    expect(states.last, isA<AuthenticatedState>());
    expect(await TabletSessionUtils.getTabletSessionStartDate(), isNotNull);
  });

  test('logout emite saindo e depois desautenticado', () async {
    await build().logout();
    await settle();

    expect(logout.calls, 1);
    expect(states, [const LogoutState(), const UnauthenticatedState()]);
  });

  test('logout com falha para no estado de saída', () async {
    logout.result = Rejection(UnknownFailure('x'));

    await build().logout();
    await settle();

    expect(states, [const LogoutState()]);
  });

  test('load restaura o token do cache', () async {
    await build().load();
    await settle();

    expect(getToken.params, [null]);
    final authenticated = states.single as AuthenticatedState;
    expect(authenticated.accessToken.accessToken, 'jwt-1');
    expect(authenticated.onLogin, isFalse);
  });

  test('load sem token desautentica e com erro não muda o estado', () async {
    getToken.result = Success(null);
    await build().load();
    await settle();
    expect(states, [const UnauthenticatedState()]);

    states.clear();
    getToken.result = Rejection(UnknownFailure('x'));
    await build().load();
    await settle();
    expect(states, isEmpty);
  });

  test('load em sessão de tablet desautentica sem consultar o cache',
      () async {
    await TabletSessionUtils.setCondoCode('C1');

    await build(appOrigin: AppOriginEnum.employee).load();
    await settle();

    expect(getToken.params, isEmpty);
    expect(states, [const UnauthenticatedState()]);
  });

  test('switchRole sem token usa o cache do papel', () async {
    await build().switchRole(role: 'R', me: 'eu');
    await settle();

    expect(getToken.params.single!.role, 'R');
    final authenticated = states.single as AuthenticatedState;
    expect(authenticated.accessToken.accessToken, 'jwt-1');
    expect(authenticated.me, 'eu');
  });

  test('switchRole sem token no cache ou com erro fica não autorizado',
      () async {
    getToken.result = Success(null);
    await build().switchRole();
    await settle();
    expect(states.last, const UnautorizedState(error: null, restartApp: true));

    final failure = UnknownFailure('x');
    getToken.result = Rejection(failure);
    await build().switchRole(role: 'R');
    await settle();
    expect(states.last, UnautorizedState(error: failure, restartApp: false));
    expect(getToken.params.last!.role, 'R');
  });

  test('switchRole com token registra a data da troca e autentica', () async {
    final token = buildToken(accessToken: 'novo');

    await build().switchRole(token: token, me: 'eu', isUpdate: true);
    await settle();

    expect(getToken.params, isEmpty);
    expect(states.single, AuthenticatedState(accessToken: token, me: 'eu'));
    final preferences = await SharedPreferences.getInstance();
    expect(preferences.getString(SharedPreferencesKeys.lastSwitchRoles),
        isNotNull);
  });

  test('close fecha o bloc', () async {
    await build().close();
    expect(bloc.isClosed, isTrue);
  });

  test('consultas de permissão, cabeçalho, refresh e expiração', () async {
    final store = build();

    expect(store.checkRback('home.menu.item'), isFalse);
    expect(store.getCustomHeader(), isNull);
    expect(store.getRefreshToken(), '-');
    expect(store.getExpirationDate(), '');

    bloc.add(AuthenticateEvent(
        accessToken: buildToken(
            permissions: ['home.menu.item'],
            expiresIn: DateTime(2026, 1, 2, 3, 4, 5))));
    await settle();

    expect(store.checkRback('home.menu.item'), isTrue);
    expect(store.checkRback('outra'), isFalse);
    expect(store.getCustomHeader(), {'Authorization': 'Bearer jwt-1'});
    expect(store.getRefreshToken(), 'refresh-1');
    expect(store.getExpirationDate(), '02/01/2026 03:04:05');

    bloc.add(AuthenticateEvent(
        accessToken: buildToken(accessToken: '', refreshToken: '')));
    await settle();

    expect(store.getCustomHeader(), isNull);
    expect(store.getRefreshToken(), '-');
    expect(store.getExpirationDate(), '');
  });
}
