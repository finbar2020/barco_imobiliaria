import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_user_info_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/notification_icon.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/whatsapp_icon.dart';
import 'package:colaborador/feature/timesheet/presentation/timesheet_page/page/timesheet_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:essentials/essentials.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeNotificationController extends Fake
    implements NotificationController {
  _FakeNotificationController(this.bloc, {this.notificationsNotRead = 0});

  @override
  final NotificationListBloc bloc;

  @override
  int notificationsNotRead;
}

void main() {
  setUp(FlavorConfig.init);

  tearDown(resetTestApplicationContainer);

  Future<void> pumpUserInfo(
    WidgetTester tester, {
    bool circuitVisible = true,
    int notificationsNotRead = 0,
  }) async {
    final sessionBloc = LoadedSessionBloc();
    await installTestCircuitBreaker(
      sessionBloc: sessionBloc,
      circuitVisible: circuitVisible,
    );
    final bloc = NotificationListBloc();
    addTearDown(bloc.close);

    await pumpApp(
      tester,
      HomeUserInfoWidget(
        me: testMe(),
        reference: 'R1',
        notificationController: _FakeNotificationController(
          bloc,
          notificationsNotRead: notificationsNotRead,
        ),
        circuitBreakerController:
            ApplicationContainer.instance().resolve<CircuitBreakerController>(),
      ),
      localized: true,
      shrinkWrap: false,
      settle: false,
      surface: const Size(400, 120),
    );
    await tester.pump();
  }

  group('HomeUserInfoWidget', () {
    testWidgets('saúda o colaborador pelo primeiro nome', (tester) async {
      await pumpUserInfo(tester);

      expect(find.text('home_page_hi, Ana!'), findsOneWidget);
    });

    testWidgets('exibe ícone de notificações', (tester) async {
      await pumpUserInfo(tester);

      expect(find.byType(NotificationIcon), findsOneWidget);
    });

    testWidgets('exibe o atalho de whatsapp quando o circuito está liberado',
        (tester) async {
      await pumpUserInfo(tester);

      expect(find.byType(WhatsappIcon), findsOneWidget);
    });

    testWidgets('esconde o atalho de whatsapp com o circuito fechado',
        (tester) async {
      await pumpUserInfo(tester, circuitVisible: false);

      expect(find.byType(WhatsappIcon), findsNothing);
      expect(find.byType(NotificationIcon), findsOneWidget);
    });

    testWidgets('tocar no whatsapp abre a conversa de suporte', (tester) async {
      final launched = <MethodCall>[];
      for (final channel in const [
        MethodChannel('plugins.flutter.io/url_launcher'),
        MethodChannel('plugins.flutter.io/url_launcher_macos'),
      ]) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
          launched.add(call);
          return true;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        });
      }

      await pumpUserInfo(tester);

      await tester.tap(find.byType(WhatsappIcon));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(launched, isNotEmpty);
    });
  });

  group('HomeUserInfoWidget.switchRedirect', () {
    late LoadedSessionBloc sessionBloc;

    Future<BuildContext> pumpNavigator(WidgetTester tester) async {
      sessionBloc = LoadedSessionBloc();
      await installTestCircuitBreaker(sessionBloc: sessionBloc);
      final bloc = NotificationListBloc();
      addTearDown(bloc.close);

      await tester.pumpWidget(
        MaterialApp(
          initialRoute: SharedApplicationRoute.home,
          routes: {
            SharedApplicationRoute.home: (_) => const SizedBox(key: Key('h')),
            ApplicationRoute.timesheet: (_) => const SizedBox(key: Key('ts')),
            SharedApplicationRoute.comfort: (_) =>
                const SizedBox(key: Key('cf')),
            SharedApplicationRoute.login: (_) => const SizedBox(key: Key('lg')),
          },
        ),
      );
      return tester.element(find.byKey(const Key('h')));
    }

    HomeUserInfoWidget widget() => HomeUserInfoWidget(
          me: testMe(),
          reference: 'R1',
          notificationController: _FakeNotificationController(
            NotificationListBloc(),
          ),
          circuitBreakerController: ApplicationContainer.instance()
              .resolve<CircuitBreakerController>(),
        );

    testWidgets('espelho de ponto abre a tela com o período', (tester) async {
      final context = await pumpNavigator(tester);

      widget().switchRedirect('ESPELHO_PONTO', context, '202601', sessionBloc);
      await tester.pumpAndSettle();

      final args = ModalRoute.of(
        tester.element(find.byKey(const Key('ts'))),
      )!.settings.arguments;
      expect(args, isA<TimesheetPageArgs>());
      expect((args as TimesheetPageArgs).period, '202601');
    });

    testWidgets('comodidades abrem a tela de parceiros', (tester) async {
      final context = await pumpNavigator(tester);

      widget().switchRedirect('COMODIDADES', context, '7', sessionBloc);
      await tester.pumpAndSettle();

      final args = ModalRoute.of(
        tester.element(find.byKey(const Key('cf'))),
      )!.settings.arguments;
      expect(args, isA<ComfortPageArgs>());
      expect((args as ComfortPageArgs).comfortNotificationContext, '7');
    });

    testWidgets('rota conhecida do app é aberta direto', (tester) async {
      final context = await pumpNavigator(tester);

      widget().switchRedirect(
        SharedApplicationRoute.login,
        context,
        null,
        sessionBloc,
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('lg')), findsOneWidget);
    });

    testWidgets('redirecionamento desconhecido não navega', (tester) async {
      final context = await pumpNavigator(tester);

      widget().switchRedirect('ROTA_INEXISTENTE', context, null, sessionBloc);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('h')), findsOneWidget);
      expect(find.byKey(const Key('ts')), findsNothing);
    });

    testWidgets('rota sem tratamento específico não navega', (tester) async {
      final context = await pumpNavigator(tester);

      widget().switchRedirect('BOLETOS', context, null, sessionBloc);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('h')), findsOneWidget);
    });
  });
}
