import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/stores/remote_config_store.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:morar/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:shared_features/core/modal/theme_color_dialog.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:flutter/material.dart' show Colors;

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/test_application_container.dart';

class _FakeAuthStore extends Fake implements AuthenticationStore {
  @override
  final AuthenticationBloc bloc = AuthenticationBloc();

  final switchCalls = <Map<String, Object?>>[];
  final rbacs = <String>{};

  @override
  Future<void> switchRole({
    AccessToken? token,
    String? role,
    bool isUpdate = false,
    dynamic me,
  }) async {
    switchCalls.add({'token': token, 'role': role});
  }

  @override
  bool checkRback(String feature) => rbacs.contains(feature);

  Future<void> authenticate({bool? onLogin}) async {
    bloc.add(AuthenticateEvent(accessToken: AccessToken(), onLogin: onLogin));
    await Future<void>.delayed(const Duration(milliseconds: 10));
  }
}

class _FakeLoadSession extends Fake implements LoadSession {
  _FakeLoadSession({this.local, this.remote});
  Try<Session>? local;
  Try<Session>? remote;
  final origins = <DataOrigin>[];

  @override
  Future<Try<Session>> call(DataOrigin origin) async {
    origins.add(origin);
    final result = origin == DataOrigin.local ? local : remote;
    return result ?? Rejection(UnknownFailure('none'));
  }
}

class _FakeSaveSession extends Fake implements SaveSession {
  final saved = <Session>[];
  @override
  Future<Try<Session>> call(Session params) async {
    saved.add(params);
    return Success(params);
  }
}

class _FakeSwitchRoles extends Fake implements SwitchRoles {
  _FakeSwitchRoles({this.failure});
  Failure? failure;
  final params = <SwitchParams>[];

  @override
  Future<Try<AccessToken?>> call(SwitchParams p) async {
    params.add(p);
    if (failure != null) return Rejection(failure!);
    return Success(AccessToken()..selectedRole = p.role);
  }
}

const _insuranceTable = {
  'telefone': '0800',
  'assistencia': 'a',
  'premio': [
    {
      'custo': 10.0,
      'valores': [
        {'id_titulo': 't', 'valor': '1'}
      ]
    }
  ],
  'titulos': {'t': 'T'},
};

void main() {
  late _FakeAuthStore auth;
  late _FakeLoadSession load;
  late _FakeSaveSession save;
  late _FakeSwitchRoles switchRoles;
  late FakeRemoteConfigPlatform remoteConfig;

  setUp(() async {
    remoteConfig = await setUpFakeFirebase(remoteConfigValues: {
      CustomFirebaseRemoteConfig.insuranceTable: jsonEncode(_insuranceTable),
      CustomFirebaseRemoteConfig.homePersonalizationActive: 'true',
      CustomFirebaseRemoteConfig.splashIgnoreBiometric: 'true',
    });
    auth = _FakeAuthStore();
    load = _FakeLoadSession();
    save = _FakeSaveSession();
    switchRoles = _FakeSwitchRoles();
  });

  SessionBloc build() => SessionBloc(
        remoteConfigStore: RemoteConfigStore(),
        authenticationStore: auth,
        loadSession: load,
        saveSesion: save,
        switchRoles: switchRoles,
        baseUrl: 'http://base',
      );

  test('carrega a sessão ao autenticar e faz switch de role', () async {
    final session = testSession();
    load.remote = Success(session);
    await auth.authenticate();
    final bloc = build();
    addTearDown(bloc.close);

    await waitFor(() => bloc.state is SessionLoadedState);
    expect(bloc.state.session!.unity!.id, 'u1');
    expect(load.origins, [DataOrigin.local, DataOrigin.remote]);
    expect(switchRoles.params.single.role, 'u1');
    expect(switchRoles.params.single.name, 'R1101');
    expect(auth.switchCalls.single['token'], isA<AccessToken>());
    expect(fakeAnalytics.userId, '12345678901');
    expect(fakeAnalytics.userProperties['cpf'], '12345678901');
    expect(fakeAnalytics.eventNames, contains('morar_morador_login'));
    expect(bloc.getInsuranceTable()!.telefone, '0800');
    expect(bloc.getHortaRemoteConfig(), isNull);
    expect(bloc.iSPreferencesPersonalizationActive, isTrue);
    expect(bloc.getBaseUrl(), 'http://base');
    expect(remoteConfig.activations, greaterThan(0));
  });

  test('falha remota sem cache vira SessionFailedState', () async {
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession();
    await waitFor(() => bloc.state is SessionFailedState);
    expect((bloc.state as SessionFailedState).failure, isA<UnknownFailure>());
    expect(fakeAnalytics.eventNames, contains('morar_sessao_expirada_read'));
  });

  test('falha remota com cache válido mantém a sessão do cache', () async {
    load.local = Success(testSession(me: testMe(name: 'cache')));
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession();
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(bloc.state.session!.me!.name, 'cache');
    expect(bloc.loadedFromCache, isTrue);
  });

  test('token proibido no switch de role encerra a sessão', () async {
    load.remote = Success(testSession());
    switchRoles.failure = ForbidenTokenFailure('403', 'x');
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession();
    await waitFor(() => bloc.state is SessionFailedState);
    expect((bloc.state as SessionFailedState).failure, isA<ForbidenTokenFailure>());
    // A sessão ainda não tinha sido emitida, então não há usuário para guardar.
    expect((bloc.state as SessionFailedState).user, isNull);
    expect(auth.switchCalls, isEmpty);
    expect(fakeAnalytics.eventNames, contains('morar_sessao_expirada_switch_role'));
  });

  test('outra falha no switch usa o cache de role', () async {
    load.remote = Success(testSession());
    switchRoles.failure = UnknownFailure('x');
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession(onLogin: true);
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(auth.switchCalls.single['role'], 'R1101');
    expect(fakeAnalytics.eventNames, contains('login_finalizado'));
  });

  test('remoto preserva condomínio e unidade já selecionados', () async {
    final me = testMe(condominiums: [
      testCondominium(id: 'c1', reference: 'R1', blocks: [
        testBlock(units: [testUnity(id: 'u1', title: '101'), testUnity(id: 'u2', title: '102')])
      ]),
    ]);
    load.local = Success(Session()
      ..me = me
      ..unity = me.allUnitsEntity[1]);
    load.remote = Success(Session()..me = testMe(condominiums: me.condominiums));
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession();
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(bloc.state.session!.unity!.title, '102');
  });

  test('selectedUnity troca a role e salva', () async {
    load.remote = Success(testSession());
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession();
    await waitFor(() => bloc.state is SessionLoadedState);

    final other = testUnity(id: 'u2', title: '102');
    bloc.selectedUnity(other);
    await waitFor(() => bloc.state.session?.unity?.id == 'u2');
    expect((bloc.state as SessionLoadedState).switchFailed, isFalse);
    expect(save.saved.last.unity!.id, 'u2');

    switchRoles.failure = UnknownFailure('x');
    bloc.selectedCondominium(testUnity(id: 'u3'));
    await waitFor(() =>
        bloc.state is SessionLoadedState &&
        (bloc.state as SessionLoadedState).switchFailed == true);
    expect(bloc.state.session!.unity!.id, 'u2');
    expect(auth.switchCalls.last['role'], 'R1102');
  });

  test('updateMe e logout', () async {
    final bloc = build();
    addTearDown(bloc.close);
    bloc.updateMe(testMe(name: 'novo'));
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(bloc.state.session!.me!.name, 'novo');
    expect(bloc.state.session!.condominium!.id, 'c1');
    expect(bloc.state.session!.unity!.id, 'u1');
    expect(save.saved, hasLength(1));

    bloc.updateMe(null);
    await waitFor(() => save.saved.length == 2);
    expect(save.saved.last.me, isNull);

    bloc.logout(error: UnknownFailure('expirou'), restartApp: true);
    await waitFor(() => bloc.state is SessionFailedState);
    expect((bloc.state as SessionFailedState).failure.error, 'expirou');

    bloc.emptyState();
    await waitFor(() => bloc.state is SessionInitialState);
  });

  test('updateMe com usuário sem condomínio', () async {
    final bloc = build();
    addTearDown(bloc.close);
    bloc.updateMe(testMe(condominiums: [Condominium()]));
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(bloc.state.session!.condominium!.id, isNull);
  });

  test('estado de autenticação não autorizado encerra a sessão', () async {
    final bloc = build();
    addTearDown(bloc.close);
    auth.bloc.add(UnauthorizedEvent(error: UnknownFailure('401'), restartApp: true));
    await waitFor(() => bloc.state is SessionFailedState);

    load.remote = Success(testSession());
    await auth.authenticate(onLogin: true);
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(load.origins, contains(DataOrigin.remote));
  });

  test('checkConfig respeita o remote config', () async {
    load.remote = Success(testSession());
    remoteConfig.values[CustomFirebaseRemoteConfig.customRbac] = jsonEncode({
      'morar.x': true,
      'morar.x_reference': 'R1|R2',
      'morar.all': true,
      'morar.all_reference': 'ALL',
      'morar.off': false,
      'morar.off_reference': 'R1',
    });
    final bloc = build();
    addTearDown(bloc.close);
    bloc.beginLoadSession();
    await waitFor(() => bloc.state is SessionLoadedState);
    expect(bloc.checkConfig('morar.x_reference'), isTrue);
    expect(bloc.checkConfig('morar.all_reference'), isTrue);
    expect(bloc.checkConfig('morar.off_reference'), isFalse);
    expect(bloc.checkConfig('morar.none_reference'), isFalse);
    expect(bloc.checkRback('morar.x'), isFalse);
    auth.rbacs.add('morar.x');
    expect(bloc.checkRback('morar.x'), isTrue);

    remoteConfig.values[CustomFirebaseRemoteConfig.customRbac] = '';
    expect(bloc.checkConfig('morar.x_reference'), isFalse);
  });

  test('links do remote config e biometria', () async {
    remoteConfig.values['link_key'] =
        jsonEncode({'link': 'https://l', 'webview': true, 'name': 'n'});
    remoteConfig.values['broken'] = '{';
    final bloc = build();
    addTearDown(bloc.close);
    expect(bloc.getRemoteConfigForLinks('link_key'), isNull);
    // Corrigido: na primeira chamada o remote config é inicializado e a flag
    // é respeitada (o `if` estava invertido e devolvia `false`).
    expect(bloc.getRemoteConfig, isNull);
    expect(await bloc.iSsplashIgnoreBiometricActive(), isTrue);
    expect(await bloc.iSsplashIgnoreBiometricActive(), isTrue);
    expect(bloc.getRemoteConfigForLinks('link_key')!.link, 'https://l');
    expect(bloc.getRemoteConfigForLinks('broken'), isNull);
    expect(bloc.getRemoteConfig, isNotNull);
  });

  test('cor do tema', () {
    final bloc = build();
    addTearDown(bloc.close);
    expect(bloc.getThemeColor(), isNull);
    final value = ThemeColorValue(Colors.red, Colors.blue, false);
    bloc.updateThemeColor(value);
    expect(bloc.getThemeColor(), same(value));
  });
}
