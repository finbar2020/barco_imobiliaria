import 'dart:convert';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:firebase_messaging_platform_interface/firebase_messaging_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' hide MessageHandler;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/messaging/message_handler.dart';
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/presentation/page/home_navigation_page.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/firebase_mocks.dart';

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

  Future<dynamic> pumpHandler(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        initialRoute: SharedApplicationRoute.home,
        routes: {
          SharedApplicationRoute.home: (_) => MessageHandler(
                notificationController: notificationController,
                appWidget: const SizedBox(key: Key('app')),
              ),
          ApplicationRoute.mailing: (_) => const SizedBox(key: Key('mailing')),
        },
      ),
    );
    await tester.pump();
    // Corrigido: o handler guarda as assinaturas de `onMessage` e
    // `onMessageOpenedApp` e as cancela no `dispose`, então instâncias de
    // testes anteriores não continuam ouvindo o stream estático e as
    // asserções podem usar `single` para as chamadas ao ghost usecase.
    // O state do handler é privado; as chamadas abaixo passam por `dynamic`.
    return tester.state(find.byType(MessageHandler));
  }

  HomeNavigationPageArgs? homeArgs(WidgetTester tester) =>
      ModalRoute.of(tester.element(find.byType(MessageHandler)))!
          .settings
          .arguments as HomeNavigationPageArgs?;

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

    sendPush = _FakeSendPushCallback();
    ghost = _FakeGhostUsecase();
    notificationController = _FakeNotificationController();
    final locator = ApplicationContainer.instance().locator;
    await locator.reset(dispose: true);
    locator.registerSingleton<SendPushCallback>(sendPush);
    locator.registerSingleton<GhostNotificationUsecase>(ghost);
  });

  tearDown(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_localNotificationsChannel, null);
    await ApplicationContainer.instance().locator.reset(dispose: true);
  });

  testWidgets('renderiza o app recebido e inicializa as notificações locais',
      (tester) async {
    await pumpHandler(tester);

    expect(find.byKey(const Key('app')), findsOneWidget);
    expect(localNotificationCalls.map((c) => c.method), contains('initialize'));
  });

  testWidgets('abrir pelo push confirma o clique e redireciona para a home',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessageOpenedApp.add(
      const RemoteMessage(
        data: {'id': '7', 'redirectPath': 'BOLETOS', 'redirectId': '10'},
      ),
    );
    await tester.pumpAndSettle();

    expect(sendPush.calls.single.notificationId, '7');
    expect(sendPush.calls.single.type, NotificationCallbackType.CLICOU);
    expect(notificationController.listCalls, 1);
    final args = homeArgs(tester);
    expect(args?.redirectRoute?.rote, 'BOLETOS');
    expect(args?.redirectRoute?.objectId, '10');
    expect(args?.redirectRoute?.notificationId, '7');
  });

  testWidgets('notificação silenciosa é tratada como ghost notification',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessage.add(
      const RemoteMessage(data: {'id': '99', 'tipoNotification': 'ESTOU_VIVO'}),
    );
    await tester.pumpAndSettle();

    expect(ghost.calls.single.id, '99');
    expect(ghost.calls.single.type, 'ESTOU_VIVO');
    expect(sendPush.calls, isEmpty);
  });

  testWidgets('notificação silenciosa sem tipo atualiza o token do fcm',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessage.add(const RemoteMessage(data: {}));
    await tester.pumpAndSettle();

    expect(ghost.calls.single.id, '');
    expect(ghost.calls.single.type, 'UPDATE_FCM_TOKEN');
  });

  testWidgets('notificação visível confirma o recebimento e exibe localmente',
      (tester) async {
    await pumpHandler(tester);

    FirebaseMessagingPlatform.onMessage.add(
      const RemoteMessage(
        data: {'id': '5', 'module': 'boletos'},
        notification: RemoteNotification(title: 'Oi', body: 'Corpo'),
      ),
    );
    await tester.pumpAndSettle();

    expect(sendPush.calls.single.notificationId, '5');
    expect(sendPush.calls.single.type, NotificationCallbackType.RECEBEU);
    expect(notificationController.listCalls, 1);
    expect(localNotificationCalls.map((c) => c.method), contains('show'));
    expect(ghost.calls, isEmpty);
  });

  testWidgets('rota conhecida do app é aberta diretamente', (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(
      NotificationModel(redirectPath: ApplicationRoute.mailing),
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mailing')), findsOneWidget);
  });

  testWidgets('redirecionamento desconhecido vira notificações não lidas',
      (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(NotificationModel(redirectPath: 'ROTA_INEXISTENTE'));
    await tester.pumpAndSettle();

    expect(homeArgs(tester)?.redirectRoute?.rote, 'ROTA_INEXISTENTE');
    expect(find.byKey(const Key('app')), findsOneWidget);
  });

  testWidgets('sem caminho de redirecionamento nada acontece', (tester) async {
    final state = await pumpHandler(tester);

    state.switchRedirect(NotificationModel(id: '1'));
    await tester.pumpAndSettle();

    expect(homeArgs(tester), isNull);
  });

  testWidgets('payload nulo ou vazio não dispara nenhuma ação',
      (tester) async {
    final state = await pumpHandler(tester);

    state.selectNotification(null);
    state.selectNotification('');
    await tester.pumpAndSettle();

    expect(sendPush.calls, isEmpty);
    expect(homeArgs(tester), isNull);
  });

  testWidgets('tocar na notificação local confirma o clique e redireciona',
      (tester) async {
    final state = await pumpHandler(tester);

    state.selectNotification(
      json.encode({'id': '11', 'redirectPath': 'RESERVA_AREA'}),
    );
    await tester.pumpAndSettle();

    expect(sendPush.calls.single.notificationId, '11');
    expect(homeArgs(tester)?.redirectRoute?.rote, 'RESERVA_AREA');
  });

  testWidgets('detalhes da notificação usam o módulo como canal',
      (tester) async {
    final state = await pumpHandler(tester);

    final NotificationDetails details = state.setNotificationDetailsAndroid(
      NotificationModel(module: 'boletos'),
      'canal',
      'nome',
      'descricao',
    );
    final NotificationDetails fallback = state.setNotificationDetailsAndroid(
      NotificationModel(),
      'canal',
      'nome',
      'descricao',
    );

    expect(details.android!.channelId, 'boletos');
    expect(details.iOS!.threadIdentifier, 'boletos');
    expect(fallback.android!.channelId, 'canal');
    expect(fallback.android!.channelDescription, 'descricao');
  });

  testWidgets('push que abriu o app encerrado redireciona no primeiro build',
      (tester) async {
    await setUpFakeFirebase(
      initialMessage: const RemoteMessage(
        data: {'redirectPath': 'BOLETOS', 'redirectId': '3'},
      ),
    );

    await pumpHandler(tester);
    await tester.pumpAndSettle();

    expect(homeArgs(tester)?.redirectRoute?.rote, 'BOLETOS');
    expect(isFirstBuild, isFalse);
  });

  testWidgets('mensagem guardada em cache é reprocessada no primeiro build',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      SharedPreferencesKeys.ownerMessageDataCached: json.encode(
        NotificationModel(redirectPath: 'BOLETOS', redirectId: '4').toJson(),
      ),
    });

    await pumpHandler(tester);
    await tester.pumpAndSettle();

    expect(homeArgs(tester)?.redirectRoute?.objectId, '4');
    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(SharedPreferencesKeys.ownerMessageDataCached),
      isNull,
    );
  });

  testWidgets('salvar em cache guarda a notificação serializada',
      (tester) async {
    final state = await pumpHandler(tester);

    state.saveMessageInCache(data: NotificationModel(id: '77'));
    await tester.pumpAndSettle();

    final preferences = await SharedPreferences.getInstance();
    expect(
      preferences.getString(SharedPreferencesKeys.ownerMessageDataCached),
      contains('77'),
    );
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
      const RemoteMessage(data: {'id': '43', 'redirectPath': 'BOLETOS'}),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(ghost.calls, isEmpty);
    expect(sendPush.calls, isEmpty);
    expect(notificationController.listCalls, 0);
  });
}
