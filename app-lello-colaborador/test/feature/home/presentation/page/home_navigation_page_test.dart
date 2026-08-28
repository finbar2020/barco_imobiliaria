import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/home/presentation/bloc/home_state.dart';
import 'package:colaborador/feature/home/presentation/page/home_navigation_page.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:colaborador/feature/home/presentation/widget/home_navigation_loaded_offline_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/home_navigation_loaded_online_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity_plus_platform_interface/connectivity_plus_platform_interface.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/firebase_mocks.dart';
import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeConnectivityPlatform extends ConnectivityPlatform {
  @override
  Future<List<ConnectivityResult>> checkConnectivity() async =>
      [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      const Stream.empty();
}

class _FakeNotificationController extends Fake
    implements NotificationController {
  _FakeNotificationController(this.bloc);

  @override
  final NotificationListBloc bloc;

  @override
  int notificationsNotRead = 0;

  int listCalls = 0;

  @override
  Future<void> getNotificationList({bool loading = true}) async => listCalls++;
}

const _localNotifications =
    MethodChannel('dexterous.com/flutter/local_notifications');

const _locOverrides = {
  'home_navigation_home': 'Home',
  'home_navigation_my_documents': 'Docs',
  'home_navigation_advantages': 'Clube',
  'home_navigation_digital_point': 'Ponto',
};

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeNotificationController notificationController;
  late NotificationListBloc notificationBloc;

  setUp(() async {
    await setUpFakeFirebase();
    ConnectivityPlatform.instance = _FakeConnectivityPlatform();
    AndroidFlutterLocalNotificationsPlugin.registerWith();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localNotifications,
            (call) async => call.method == 'initialize' ? true : null);
    notificationBloc = NotificationListBloc();
    notificationController = _FakeNotificationController(notificationBloc);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localNotifications, null);
    await notificationBloc.close();
    await resetTestApplicationContainer();
  });

  Future<TestApplicationContainerScope> pumpPage(
    WidgetTester tester, {
    SessionState? sessionState,
  }) async {
    final scope = await installTestApplicationContainer();
    ApplicationContainer.instance()
        .locator
        .registerSingleton<NotificationController>(notificationController);

    await pumpApp(
      tester,
      const HomeNavigationPage(),
      localized: true,
      wrapInScaffold: false,
      shrinkWrap: false,
      settle: false,
      locOverrides: _locOverrides,
      surface: const Size(480, 1000),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return scope;
  }

  /// O relógio da home usa `Timer.periodic` e só se cancela no tick seguinte
  /// ao dispose.
  Future<void> unmount(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 1));
    }
  }

  group('myBackgroundMessageHandler', () {
    test('devolve os dados quando a mensagem os traz', () async {
      final resultado = await myBackgroundMessageHandler({
        'data': {'id': '1'},
      });

      expect(resultado, {'id': '1'});
    });

    test('dados que não são um mapa são ignorados', () {
      expect(myBackgroundMessageHandler(const {'data': 'texto'}), isNull);
    });

    test('devolve nulo quando não há dados', () {
      expect(myBackgroundMessageHandler(const {'outro': 1}), isNull);
    });
  });

  group('HomeBlocBuilder', () {
    Future<TestApplicationContainerScope> pumpBuilder(
      WidgetTester tester,
      HomeState state, {
      bool connected = true,
    }) async {
      final scope = await installTestApplicationContainer();
      addTearDown(scope.dispose);
      scope.homeController.isConnected = connected;
      scope.homeBloc.emit(state);

      await pumpApp(
        tester,
        HomeBlocBuilder(
          registerController: scope.registerPointController,
          controller: scope.homeController,
          sessionState: SessionLoadedState(
            session: testSession(),
            isTabletSession: false,
          ),
          notificationController: notificationController,
        ),
        localized: true,
        wrapInScaffold: false,
        shrinkWrap: false,
        settle: false,
        locOverrides: _locOverrides,
        surface: const Size(480, 1000),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      // O controller dispara `HomeLoadEvent` durante os primeiros frames;
      // reaplicamos o estado desejado depois disso.
      scope.homeBloc.emit(state);
      await tester.pump();
      return scope;
    }

    testWidgets('home carregada e conectada mostra a versão online',
        (tester) async {
      await pumpBuilder(tester, const HomeLoadedState(digitalPoints: []));

      expect(find.byType(HomeNavigationLoadedOnlineWidget), findsOneWidget);

      await unmount(tester);
    });

    testWidgets('home carregada sem conexão mostra a versão offline',
        (tester) async {
      await pumpBuilder(
        tester,
        const HomeLoadedState(digitalPoints: []),
        connected: false,
      );

      expect(find.byType(HomeNavigationLoadedOfflineWidget), findsOneWidget);

      await unmount(tester);
    });

    testWidgets('home carregando mostra o aviso de espera', (tester) async {
      await pumpBuilder(tester, const HomeLoadingState());

      expect(find.byType(LoadingHomeWidget), findsOneWidget);
      expect(find.text('home_page_fetching_profile'), findsOneWidget);
      expect(find.text('please_wait'), findsOneWidget);

      await unmount(tester);
    });

    testWidgets('estado desconhecido não renderiza nada', (tester) async {
      final scope = await installTestApplicationContainer();
      addTearDown(scope.dispose);
      scope.homeBloc.emit(HomeInitialState());

      await pumpApp(
        tester,
        HomeBlocBuilder(
          registerController: scope.registerPointController,
          controller: scope.homeController,
          sessionState: SessionLoadedState(
            session: testSession(),
            isTabletSession: false,
          ),
          notificationController: notificationController,
        ),
        localized: true,
        wrapInScaffold: false,
        shrinkWrap: false,
        settle: false,
        locOverrides: _locOverrides,
        surface: const Size(480, 1000),
      );
      await tester.pump();

      expect(find.byType(HomeNavigationLoadedOnlineWidget), findsNothing);
      expect(find.byType(LoadingHomeWidget), findsNothing);

      await unmount(tester);
    });
  });
}
