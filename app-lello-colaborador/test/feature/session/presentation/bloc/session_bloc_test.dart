import 'dart:io';

import 'package:colaborador/core/stores/session_store.dart';
import 'package:colaborador/feature/me/domain/use_case/log_me_out/log_me_out.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/domain/use_case/load_session/load_session.dart';
import 'package:colaborador/feature/session/domain/use_case/save_session/save_session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart' hide isNotNull, isNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:workmanager/workmanager.dart' as wm;
import 'package:workmanager_platform_interface/workmanager_platform_interface.dart';

import '../../../../helpers/firebase_mocks.dart';
import '../../../../helpers/fixtures.dart';

class _FakeLoadSession extends Fake implements LoadSession {
  _FakeLoadSession({this.local, this.remote});

  Session? local;
  Session? remote;
  final origins = <DataOrigin>[];

  @override
  Future<Try<Session>> call(DataOrigin? params) async {
    origins.add(params!);
    if (params == DataOrigin.local) {
      if (local == null) return Rejection(UnknownFailure('sem cache'));
      return Success(local!);
    }
    if (remote == null) {
      return Rejection(UnknownFailure('sem remoto'));
    }
    return Success(remote!);
  }
}

class _FakeSaveSession extends Fake implements SaveSession {
  final saved = <Session?>[];

  @override
  Future<Try<Session?>> call(Session? params) async {
    saved.add(params);
    return Success(params);
  }
}

class _FakeSwitchRoles extends Fake implements SwitchRoles {
  final calls = <SwitchParams?>[];

  @override
  Future<Try<AccessToken?>> call(SwitchParams? params) async {
    calls.add(params);
    return Success(AccessToken()..accessToken = 'token');
  }
}

class _FakeLogMeOut extends Fake implements LogMeOut {
  int calls = 0;

  @override
  Future<Try<Nothing>> call() async {
    calls++;
    return Success(Nothing());
  }
}

class _FakeAuthenticationStore extends Fake implements AuthenticationStore {
  _FakeAuthenticationStore(this.bloc, {this.rbacAllowed = true});

  @override
  final AuthenticationBloc bloc;

  final bool rbacAllowed;
  final switchedRoles = <String?>[];
  bool loggedOut = false;

  @override
  bool checkRback(String rbac) => rbacAllowed;

  @override
  Future<void> logout() async => loggedOut = true;

  @override
  Future<void> switchRole({
    bool isUpdate = false,
    dynamic me,
    String? role,
    AccessToken? token,
  }) async {
    switchedRoles.add(role);
  }
}

late AuthenticationBloc _authenticationBloc;
late _FakeSaveSession _saveSession;
late SessionStore _store;
late _FakeAuthenticationStore _authStore;
late _FakeLogMeOut _logMeOut;

SessionBloc _bloc(_FakeLoadSession loadSession, {bool rbacAllowed = true}) {
  _authenticationBloc = AuthenticationBloc();
  _saveSession = _FakeSaveSession();
  _store = SessionStore();
  _authStore = _FakeAuthenticationStore(
    _authenticationBloc,
    rbacAllowed: rbacAllowed,
  );
  _logMeOut = _FakeLogMeOut();

  final bloc = SessionBloc(
    authenticationStore: _authStore,
    saveSession: _saveSession,
    loadSession: loadSession,
    baseUrl: 'http://localhost',
    switchRoles: _FakeSwitchRoles(),
    logMeOut: _logMeOut,
    store: _store,
  );
  addTearDown(() async {
    await bloc.close();
    await _authenticationBloc.close();
  });
  return bloc;
}

class _FakeWorkmanagerPlatform extends WorkmanagerPlatform {
  final tasks = <String>[];
  final delays = <Duration?>[];

  @override
  Future<void> registerOneOffTask(
    String uniqueName,
    String taskName, {
    Map<String, dynamic>? inputData,
    Duration? initialDelay,
    Constraints? constraints,
    ExistingWorkPolicy? existingWorkPolicy,
    BackoffPolicy? backoffPolicy,
    Duration? backoffPolicyDelay,
    String? tag,
    OutOfQuotaPolicy? outOfQuotaPolicy,
    ForegroundServiceConfig? foregroundServiceConfig,
    bool expedited = false,
  }) async {
    tasks.add(taskName);
    delays.add(initialDelay);
  }
}

/// Escala de hoje com os quatro horários ainda no futuro.
WorkShiftDetails _escalaDeHoje({bool isDayOff = false}) {
  final agora = DateTime.now();
  final base = DateTime(agora.year, agora.month, agora.day);
  String hora(Duration offset) {
    final h = agora.add(offset);
    final hh = h.hour.toString().padLeft(2, '0');
    final mm = h.minute.toString().padLeft(2, '0');
    return hh + ':' + mm + ':00';
  }

  return WorkShiftDetails(
    badageNumber: '1',
    entry1: hora(const Duration(hours: 1)),
    out1: hora(const Duration(hours: 2)),
    entry2: hora(const Duration(hours: 3)),
    out2: hora(const Duration(hours: 4)),
    isDayOff: isDayOff,
    date: base,
    reference: 'R1',
  );
}

Session _sessionComEscala({bool isDayOff = false}) {
  final condo = testCondominium(
    workShiftDetails: [_escalaDeHoje(isDayOff: isDayOff)],
  );
  return Session(me: testMe(condominiums: [condo]), condominium: condo);
}

Future<SessionState> _waitFor(
  SessionBloc bloc,
  bool Function(SessionState) test,
) =>
    bloc.stream.firstWhere(test);

void main() {
  setUpAll(() async {
    final dir = Directory.systemTemp.createTempSync('colaborador_hive');
    Hive.init(dir.path);
  });

  late FakeRemoteConfigPlatform remoteConfig;

  setUp(() async {
    remoteConfig = await setUpFakeFirebase(
      remoteConfigValues: {
        'button_no_auth_points_list': '{"references":["R1"]}',
      },
    );
  });

  group('SessionBloc', () {
    test('inicializa o remote config ao ser criado', () async {
      _bloc(_FakeLoadSession());

      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(remoteConfig.fetches, greaterThan(0));
      expect(remoteConfig.activations, greaterThan(0));
    });

    test('carrega a sessão remota', () async {
      final session = testSession();
      final bloc = _bloc(_FakeLoadSession(remote: session));

      bloc.beginLoadSession();

      final loaded = await _waitFor(bloc, (s) => s is SessionLoadedState)
          as SessionLoadedState;
      expect(loaded.session.me.name, 'ana silva');

      await Future<void>.delayed(const Duration(milliseconds: 50));
      // O load guarda a sessão no store (o save só acontece em update/logout).
      expect(_store.session?.me.name, 'ana silva');
    });

    test('sem remoto usa o cache local', () async {
      final bloc = _bloc(_FakeLoadSession(local: testSession()));

      bloc.beginLoadSession();

      final loaded = await _waitFor(bloc, (s) => s is SessionLoadedState)
          as SessionLoadedState;
      expect(loaded.session.me.name, 'ana silva');
    });

    test('sem remoto e sem cache emite falha', () async {
      final bloc = _bloc(_FakeLoadSession());

      bloc.beginLoadSession();

      expect(
        await _waitFor(bloc, (s) => s is SessionFailedState),
        isA<SessionFailedState>(),
      );
    });

    test('updateMe reemite a sessão com o colaborador atualizado', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);

      final novoMe = testMe()..name = 'ana atualizada';
      final proximoEstado = _waitFor(
        bloc,
        (s) => s is SessionLoadedState && s.session.me.name == 'ana atualizada',
      );
      bloc.updateMe(novoMe);

      final estado = await proximoEstado as SessionLoadedState;
      expect(estado.session.me.name, 'ana atualizada');
      expect(bloc.getSession?.me.name, 'ana atualizada');
      expect(_store.session?.me.name, 'ana atualizada');
      expect(_saveSession.saved.last?.me.name, 'ana atualizada');
    });

    test('fechar o bloc não estoura', () async {
      final bloc = SessionBloc(
        authenticationStore: _FakeAuthenticationStore(AuthenticationBloc()),
        saveSession: _FakeSaveSession(),
        loadSession: _FakeLoadSession(),
        baseUrl: 'http://localhost',
        switchRoles: _FakeSwitchRoles(),
        logMeOut: _FakeLogMeOut(),
        store: SessionStore(),
      );

      await expectLater(bloc.close(), completes);
    });

    test('logout limpa a sessão salva', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);

      bloc.logout();

      await _waitFor(bloc, (s) => s is SessionInitialState);
      await Future<void>.delayed(const Duration(milliseconds: 50));
      expect(_saveSession.saved, contains(null));
    });

    test('logout com restartApp emite falha de sessão', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);

      bloc.logout(restartApp: true);

      expect(
        await _waitFor(bloc, (s) => s is SessionFailedState),
        isA<SessionFailedState>(),
      );
    });

    test('showButtonNoAuthPointList lê a lista do remote config', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.showButtonNoAuthPointList('R1'), isTrue);
      expect(bloc.showButtonNoAuthPointList('R2'), isFalse);
    });
  });

  group('SessionBloc reação à autenticação', () {
    test('autenticação bem-sucedida carrega a sessão', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));

      _authenticationBloc.add(
        AuthenticateEvent(
          accessToken: AccessToken()..accessToken = 'token',
          onLogin: true,
        ),
      );

      expect(
        await _waitFor(bloc, (s) => s is SessionLoadedState),
        isA<SessionLoadedState>(),
      );
    });

    test('sessão não autorizada derruba a sessão com erro', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);

      _authenticationBloc.add(
        UnauthorizedEvent(
          error: KnownFailure('401', 'expirou'),
          restartApp: true,
        ),
      );

      expect(
        await _waitFor(bloc, (s) => s is SessionFailedState),
        isA<SessionFailedState>(),
      );
    });
  });

  group('SessionBloc utilidades', () {
    test('logoutPipeline encerra sessão em todas as camadas', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);

      final result = await bloc.logoutPipeline();

      expect(result, isA<Success<Nothing>>());
      expect(_logMeOut.calls, 1);
      expect(_authStore.loggedOut, isTrue);
      await _waitFor(bloc, (s) => s is SessionInitialState);
    });

    test('stopSchedulerTask desliga o agendamento', () {
      final bloc = _bloc(_FakeLoadSession());

      expect(bloc.doSchedule, isTrue);
      bloc.stopSchedulerTask();
      expect(bloc.doSchedule, isFalse);
    });

    test('getSession só devolve a sessão quando carregada', () async {
      final bloc = _bloc(_FakeLoadSession(remote: testSession()));

      expect(bloc.getSession, isNull);

      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);

      expect(bloc.getSession, isNotNull);
    });

    test('permissões seguem o rbac da autenticação', () {
      expect(_bloc(_FakeLoadSession()).canRegisterPoint, isTrue);
      expect(
        _bloc(_FakeLoadSession(), rbacAllowed: false).canRegisterPoint,
        isFalse,
      );
    });

    test('agenda os lembretes de ponto da escala do dia', () async {
      wm.Workmanager();
      final workmanager = _FakeWorkmanagerPlatform();
      WorkmanagerPlatform.instance = workmanager;

      final bloc = _bloc(_FakeLoadSession(remote: _sessionComEscala()));
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(workmanager.tasks, [
        'verificar-ponto-entry1Date-Task',
        'verificar-ponto-out1Date-Task',
        'verificar-ponto-entry2Date-Task',
        'verificar-ponto-out2Date-Task',
      ]);
      expect(workmanager.delays.every((d) => d!.isNegative == false), isTrue);
    });

    test('folga não agenda lembrete', () async {
      wm.Workmanager();
      final workmanager = _FakeWorkmanagerPlatform();
      WorkmanagerPlatform.instance = workmanager;

      final bloc = _bloc(
        _FakeLoadSession(remote: _sessionComEscala(isDayOff: true)),
      );
      bloc.beginLoadSession();
      await _waitFor(bloc, (s) => s is SessionLoadedState);
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(workmanager.tasks, isEmpty);
    });

    test('baseUrl é o configurado na criação', () {
      expect(_bloc(_FakeLoadSession()).getBaseUrl(), 'http://localhost');
    });

    test('personalização da home vem do remote config', () async {
      remoteConfig.values = {'home_personalization_active': 'true'};
      final bloc = _bloc(_FakeLoadSession());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.iSPreferencesPersonalizationActive, isTrue);
    });

    test('sem remote config a lista de pontos offline fica escondida',
        () async {
      remoteConfig.values = {};
      final bloc = _bloc(_FakeLoadSession());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(bloc.showButtonNoAuthPointList('R1'), isFalse);
    });
  });
}
