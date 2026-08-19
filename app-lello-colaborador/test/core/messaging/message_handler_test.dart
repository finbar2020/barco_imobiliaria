import 'dart:convert';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/messaging/message_handler.dart';
import 'package:colaborador/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/page/timesheet_page.dart';
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/test_application_container.dart';

class _FakeSendPushCallback extends Fake implements SendPushCallback {
  final calls = <SendPushCallbackParams>[];

  @override
  Future<Try<bool>> call(SendPushCallbackParams? params) async {
    calls.add(params!);
    return Success(true);
  }
}

class _FakeGhostUsecase extends Fake implements GhostNotificationUsecase {
  final calls = <GhostNotificationParams>[];

  @override
  Future<Try<String?>> call(GhostNotificationParams params) async {
    calls.add(params);
    return Success('ok');
  }
}

class _FakeNotificationController extends Fake
    implements NotificationController {
  int listCalls = 0;

  @override
  Future getNotificationList() async => listCalls++;
}

const _localNotificationsChannel =
    MethodChannel('dexterous.com/flutter/local_notifications');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _FakeSendPushCallback sendPush;
  late _FakeGhostUsecase ghost;
  late _FakeNotificationController notificationController;
  late List<MethodCall> localNotificationCalls;

  Future<MessageHandlerState> pumpHandler(
    WidgetTester tester, {
    Map<String, WidgetBuilder> extraRoutes = const {},
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: SharedApplicationRoute.home,
        routes: {
          SharedApplicationRoute.home: (_) => MessageHandler(
                notificationController: notificationController,
                appWidget: const SizedBox(key: Key('app')),
              ),
          ApplicationRoute.timesheet: (_) => const SizedBox(
                key: Key('timesheet'),
              ),
          SharedApplicationRoute.comfort: (_) => const SizedBox(
                key: Key('comfort'),
              ),
          SharedApplicationRoute.login: (_) => const SizedBox(
                key: Key('login'),
              ),
          ...extraRoutes,
        },
      ),
    );
    await tester.pump();
    return tester.state<MessageHandlerState>(find.byType(MessageHandler));
  }

  setUp(() async {
    await setUpFakeFirebase();
    SharedPreferences.setMockInitialValues({});
    isFirstBuild = true;

    AndroidFlutterLocalNotificationsPlugin.registerWith();
    localNotificationCalls = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localNotificationsChannel, (call) async {
      localNotificationCalls.add(call);
      return call.method == 'initialize' ? true : null;
    });

    final scope = await installTestApplicationContainer();
    addTearDown(scope.dispose);

    sendPush = _FakeSendPushCallback();
    ghost = _FakeGhostUsecase();
    notificationController = _FakeNotificationController();
    final locator = ApplicationContainer.instance().locator;
    // O container de teste já registra fakes desses dois tipos; aqui trocamos
    // pelos que capturam as chamadas.
    if (locator.isRegistered<SendPushCallback>()) {
      await locator.unregister<SendPushCallback>();
    }
    if (locator.isRegistered<GhostNotificationUsecase>()) {
      await locator.unregister<GhostNotificationUsecase>();
    }
    locator.registerSingleton<SendPushCallback>(sendPush);
    locator.registerSingleton<GhostNotificationUsecase>(ghost);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localNotificationsChannel, null);
  });

  testWidgets('abrir pelo push confirma o clique e redireciona',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessageOpenedApp.add(
      const RemoteMessage(
        data: {'id': '7', 'redirectPath': 'ESPELHO_PONTO', 'redirectId': '202601'},
      ),
    );
    await tester.pumpAndSettle();

    expect(sendPush.calls.single.notificationId, '7');
    expect(notificationController.listCalls, 1);
    expect(find.byKey(const Key('timesheet')), findsOneWidget);
  });

  testWidgets('renderiza o app recebido e inicializa as notificações locais',
      (tester) async {
    await pumpHandler(tester);

    expect(find.byKey(const Key('app')), findsOneWidget);
    expect(
      localNotificationCalls.map((c) => c.method),
      contains('initialize'),
    );
  });

  testWidgets('notificação silenciosa é tratada como ghost notification',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessage.add(
      const RemoteMessage(data: {'id': '99', 'tipoNotification': 'ESTOU_VIVO'}),
    );
    await tester.pumpAndSettle();

    expect(ghost.calls, isNotEmpty);
    expect(ghost.calls.last.id, '99');
    expect(ghost.calls.last.type, 'ESTOU_VIVO');
    expect(sendPush.calls, isEmpty);
  });

  testWidgets('notificação visível confirma o recebimento e exibe localmente',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessage.add(
      const RemoteMessage(
        data: {'id': '5'},
        notification: RemoteNotification(title: 'Oi', body: 'Corpo'),
      ),
    );
    await tester.pumpAndSettle();

    expect(sendPush.calls.single.notificationId, '5');
    expect(sendPush.calls.single.type, NotificationCallbackType.CLICOU);
    expect(notificationController.listCalls, 1);
    expect(localNotificationCalls.map((c) => c.method), contains('show'));
    expect(ghost.calls, isEmpty);
  });

  testWidgets('espelho de ponto recebe o período da notificação',
      (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(
      NotificationModel(redirectPath: 'ESPELHO_PONTO', redirectId: '202512'),
    );
    await tester.pumpAndSettle();

    final args = ModalRoute.of(
      tester.element(find.byKey(const Key('timesheet'))),
    )!.settings.arguments;
    expect(args, isA<TimesheetPageArgs>());
    expect((args as TimesheetPageArgs).period, '202512');
  });

  testWidgets('comodidades abrem a página de parceiros com a origem correta',
      (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(
      NotificationModel(redirectPath: 'COMODIDADES_PARCEIRO', redirectId: '15'),
    );
    await tester.pumpAndSettle();

    final args = ModalRoute.of(
      tester.element(find.byKey(const Key('comfort'))),
    )!.settings.arguments;
    expect(args, isA<ComfortPageArgs>());
    expect((args as ComfortPageArgs).comfortNotificationContext, '15');
    expect(args.route, FeaturesRoutesEnum.COMODIDADES_PARCEIRO);
  });

  testWidgets('rota conhecida do app é aberta diretamente', (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(
      NotificationModel(redirectPath: SharedApplicationRoute.login),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('login')), findsOneWidget);
  });

  testWidgets('redirecionamento desconhecido apenas volta para a home',
      (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(NotificationModel(redirectPath: 'ROTA_INEXISTENTE'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app')), findsOneWidget);
    expect(find.byKey(const Key('timesheet')), findsNothing);
  });

  testWidgets('redirecionamento sem rota mapeada volta para a home',
      (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(NotificationModel(redirectPath: 'BOLETOS'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('app')), findsOneWidget);
  });

  testWidgets('payload nulo não dispara nenhuma ação', (tester) async {
    final state = await pumpHandler(tester);

    state.selectNotification(null);
    await tester.pumpAndSettle();

    expect(sendPush.calls, isEmpty);
    expect(find.byKey(const Key('app')), findsOneWidget);
  });

  testWidgets('tocar na notificação local confirma o clique e redireciona',
      (tester) async {
    final state = await pumpHandler(tester);

    state.selectNotification(
      json.encode({'id': '11', 'redirectPath': 'ESPELHO_PONTO'}),
    );
    await tester.pumpAndSettle();

    expect(sendPush.calls.single.notificationId, '11');
    expect(find.byKey(const Key('timesheet')), findsOneWidget);
  });

  testWidgets('detalhes da notificação usam o módulo como canal',
      (tester) async {
    final state = await pumpHandler(tester);

    final details = state.setNotificationDetailsAndroid(
      NotificationModel(module: 'ponto'),
      'canal',
      'nome',
      'descricao',
    );

    expect(details.android!.channelId, 'ponto');
    expect(details.android!.channelName, 'ponto');
    expect(details.android!.channelDescription, 'descricao');
  });

  testWidgets('push que abriu o app encerrado redireciona no primeiro build',
      (tester) async {
    await setUpFakeFirebase(
      initialMessage: const RemoteMessage(
        data: {'redirectPath': 'ESPELHO_PONTO', 'redirectId': '202510'},
      ),
    );

    await pumpHandler(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timesheet')), findsOneWidget);
    expect(isFirstBuild, isFalse);
  });

  testWidgets('depois do dispose o handler para de ouvir os pushes',
      (tester) async {
    await pumpHandler(tester);
    await tester.pumpWidget(const SizedBox());
    await tester.pump();

    FirebaseMessagingPlatform.onMessage.add(
      const RemoteMessage(data: {'id': '42', 'tipoNotification': 'ESTOU_VIVO'}),
    );
    FirebaseMessagingPlatform.onMessageOpenedApp.add(
      const RemoteMessage(data: {'id': '43', 'redirectPath': 'ESPELHO_PONTO'}),
    );
    await tester.pumpAndSettle();

    expect(ghost.calls, isEmpty);
    expect(sendPush.calls, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('notificação guardada em segundo plano é reprocessada',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesKeys.backgroundNotification: json.encode({
        'data': {'redirectPath': 'ESPELHO_PONTO', 'redirectId': '202511'},
      }),
    });

    await pumpHandler(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('timesheet')), findsOneWidget);
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(SharedPreferencesKeys.backgroundNotification),
      isNull,
    );
  });
}
