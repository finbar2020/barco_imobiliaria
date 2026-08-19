import 'dart:convert';

import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_by_status_usecase.dart';
import 'package:colaborador/feature/digital_point/domain/use_case/get_points/get_points_usecase.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_bloc.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/fixtures.dart';

class _FakeConnectivity extends Fake implements AppConnectivity {
  @override
  bool isConnected(List<ConnectivityResult> result) => true;
}

class _FakeRegisterFcm extends Fake implements RegisterFcm {}

class _FakeGetToken extends Fake implements GetToken {
  @override
  Future<Try<AccessToken?>> call(GetTokenParams? params) async =>
      Success(AccessToken()..accessToken = 't');
}

class _FakeGhost extends Fake implements GhostNotificationUsecase {}

class _FakeAuthStore extends Fake implements AuthenticationStore {}

class _FakeGetPoints extends Fake implements GetPointsUsecase {
  @override
  Future<Try<List<DigitalPointEntity>>> call(GetPointsParam params) async =>
      Success([testPoint()]);
}

class _FakeGetByStatus extends Fake implements GetPointsByStatusUsecase {
  bool fail = false;

  @override
  Future<Try<List<DigitalPointEntity>>> call(
    GetPointsByStatusParam params,
  ) async {
    if (fail) return Rejection(UnknownFailure('status'));
    return Success([testPoint()]);
  }
}

class _FailGetPoints extends Fake implements GetPointsUsecase {
  @override
  Future<Try<List<DigitalPointEntity>>> call(GetPointsParam params) async =>
      Rejection(UnknownFailure('points'));
}

class _PrefsSessionBloc extends Fake implements SessionBloc {
  _PrefsSessionBloc({this.personalization = true});

  final bool personalization;

  @override
  SessionState get state => const SessionInitialState();

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  Session? get getSession => testSession();

  @override
  bool get iSPreferencesPersonalizationActive => personalization;

  @override
  bool checkRback(String rbac) => true;
}

class _LoadedSessionBloc extends Fake implements SessionBloc {
  _LoadedSessionBloc({this.canRegister = true});

  final bool canRegister;
  final _session = testSession();

  @override
  SessionState get state => SessionLoadedState(
        session: _session,
        isTabletSession: false,
      );

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  Session? get getSession => _session;

  @override
  bool get iSPreferencesPersonalizationActive => true;

  @override
  bool checkRback(String rbac) => true;

  @override
  bool get canRegisterPoint => canRegister;
}

class _LoadedSessionBlocWithCondo extends Fake implements SessionBloc {
  _LoadedSessionBlocWithCondo(this._session);

  final Session _session;

  @override
  SessionState get state => SessionLoadedState(
        session: _session,
        isTabletSession: false,
      );

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  Session? get getSession => _session;

  @override
  bool get iSPreferencesPersonalizationActive => true;

  @override
  bool checkRback(String rbac) => true;
}

HomeController _controller(
  SessionBloc sessionBloc, {
  GetPointsUsecase? getPoints,
  GetPointsByStatusUsecase? getByStatus,
}) {
  final bloc = HomeBloc(
    registerFcm: _FakeRegisterFcm(),
    sessionBloc: sessionBloc,
    deviceIdentifierService: DeviceIdentifierService(),
  );
  addTearDown(bloc.close);
  final controller = HomeController(
    getPointsUsecase: getPoints ?? _FakeGetPoints(),
    getPointsByStatusUsecase: getByStatus ?? _FakeGetByStatus(),
    sessionBloc: sessionBloc,
    connectivity: _FakeConnectivity(),
    homeBloc: bloc,
    authenticationStore: _FakeAuthStore(),
    getToken: _FakeGetToken(),
  );
  controller.ghostNotificationUsecase = _FakeGhost();
  return controller;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeController helpers', () {
    test('checkShowOnboarding sem dados retorna true', () {
      final controller = _controller(_PrefsSessionBloc());
      expect(controller.checkShowOnboarding(null), isTrue);
      expect(
        controller.checkShowOnboarding(
          json.encode({'onboarding': true}),
        ),
        isFalse,
      );
    });

    test('checkFavoritesCard decodifica favoritos', () {
      final controller = _controller(_PrefsSessionBloc());
      final favs = controller.checkFavoritesCard(
        json.encode({
          'favorites': [
            HomeItemEnum.proof.titleKey,
            HomeItemEnum.benefits.titleKey,
          ],
        }),
      );
      expect(favs, contains(HomeItemEnum.proof));
      expect(favs, contains(HomeItemEnum.benefits));
    });

    test('checkFavoritesCard vazio quando personalização desativada', () {
      final controller = _controller(_PrefsSessionBloc(personalization: false));
      final favs = controller.checkFavoritesCard(
        json.encode({'favorites': [HomeItemEnum.proof.titleKey]}),
      );
      expect(favs, isEmpty);
    });
  });

  group('HomeController pontos digitais', () {
    test('getDigitalPoints preenche lista', () async {
      final controller = _controller(_PrefsSessionBloc());
      await controller.getDigitalPoints();
      expect(controller.points, hasLength(1));
    });

    test('getDigitalPoints limpa em falha', () async {
      final controller = _controller(
        _PrefsSessionBloc(),
        getByStatus: _FakeGetByStatus()..fail = true,
      );
      await controller.getDigitalPoints();
      expect(controller.points, isEmpty);
    });

    test('getAllDigitalPointsWithLogs preenche e limpa em falha', () async {
      final ok = _controller(_PrefsSessionBloc());
      await ok.getAllDigitalPointsWithLogs();
      expect(ok.points, hasLength(1));

      final fail = _controller(
        _PrefsSessionBloc(),
        getPoints: _FailGetPoints(),
      );
      await fail.getAllDigitalPointsWithLogs();
      expect(fail.points, isEmpty);
    });
  });

  group('HomeController fetchMostAccessed', () {
    test('usa lista padrão sem favoritos salvos', () async {
      SharedPreferences.setMockInitialValues({});
      final controller = _controller(_LoadedSessionBloc());
      final list = await controller.fetchMostAccessedFromFirebaseOrLocal();
      expect(list, contains(HomeItemEnum.discounts));
      expect(list, contains(HomeItemEnum.registerDigitalPoint));
      expect(list, contains(HomeItemEnum.proof));
      expect(list, contains(HomeItemEnum.myDocuments));
    });

    test('carrega favoritos do SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE':
            json.encode({'onboarding': true}),
        'PREFERENCES_HOME_CARDS_EMPLOYEE': json.encode({
          'favorites': [HomeItemEnum.proof.titleKey],
        }),
      });
      final controller = _controller(_LoadedSessionBloc());
      final list = await controller.fetchMostAccessedFromFirebaseOrLocal();
      expect(list, contains(HomeItemEnum.proof));
    });

    test('remove registerDigitalPoint quando ponto não está aprovado', () async {
      SharedPreferences.setMockInitialValues({});
      final condo = testCondominium(
        digitalTimesheetStatus: DigitalTimesheetStatusEnum.notActivated,
      );
      final session = Session(me: testMe(condominiums: [condo]), condominium: condo);
      final controller = _controller(_LoadedSessionBlocWithCondo(session));
      await controller.getMostAccessedList(
        SessionLoadedState(session: session, isTabletSession: false),
      );
      expect(
        controller.mostAccessedCards,
        isNot(contains(HomeItemEnum.registerDigitalPoint)),
      );
    });

    test('remove sendTimeSheet quando pode marcar ponto', () async {
      SharedPreferences.setMockInitialValues({
        'PREFERENCES_HOME_CARDS_ONBOARDING_EMPLOYEE':
            json.encode({'onboarding': true}),
        'PREFERENCES_HOME_CARDS_EMPLOYEE': json.encode({
          'favorites': [
            HomeItemEnum.sendTimeSheet.titleKey,
            HomeItemEnum.proof.titleKey,
          ],
        }),
      });
      final condo = testCondominium(
        digitalTimesheetStatus: DigitalTimesheetStatusEnum.approved,
      );
      final session = Session(me: testMe(condominiums: [condo]), condominium: condo);
      final controller = _controller(_LoadedSessionBlocWithCondo(session));
      await controller.getMostAccessedList(
        SessionLoadedState(session: session, isTabletSession: false),
      );
      expect(controller.mostAccessedCards, contains(HomeItemEnum.proof));
      expect(controller.mostAccessedCards, isNot(contains(HomeItemEnum.sendTimeSheet)));
    });
  });

  group('HomeController.colaboradorHomeTimer', () {
    test('parar antes de iniciar não estoura', () {
      final controller = _controller(_PrefsSessionBloc());

      expect(controller.colaboradorHomeTimer, isNull);
      expect(controller.colaboradorHomeTimerStop, returnsNormally);
    });

    test('iniciar cria o temporizador', () async {
      final controller = _controller(_PrefsSessionBloc());

      controller.colaboradorHomeTimerStart();
      await Future<void>.delayed(const Duration(milliseconds: 50));

      expect(controller.colaboradorHomeTimer, isNotNull);
      controller.colaboradorHomeTimerStop();
    });
  });

  group('HomeItemEnum.priority', () {
    test('prioridades conhecidas', () {
      expect(
        HomeItemEnum.discounts.priority(),
        lessThan(HomeItemEnum.registerDigitalPoint.priority()),
      );
      expect(
        HomeItemEnum.registerDigitalPoint.priority(),
        lessThan(HomeItemEnum.proof.priority()),
      );
    });
  });
}
