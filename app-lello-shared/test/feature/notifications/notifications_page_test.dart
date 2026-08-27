import 'package:essentials/enum/app_origin_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_tile.dart';
import 'package:shared_features/feature/notifications/presentation/widgets/notification_list_widget.dart';
import 'package:shared_features/shared_features.dart';

import '../../helpers/pump_app.dart';
import 'notifications_support.dart';

void main() {
  late NotificationsHarness harness;
  late List<SingleNotification> tapped;
  late int closed;

  setUpAll(initDates);

  setUp(() {
    tapped = [];
    closed = 0;
  });

  Widget buildPage(NotificationController controller,
      {AppOriginEnum origin = AppOriginEnum.owner}) {
    return NotificationListPage(
      closeOverlay: () => closed++,
      dialogBloc: null,
      notificationController: controller,
      homeBloc: null,
      HomeNavigationPage: const DummyHomePage(),
      sessionBloc: harness.sessionBloc,
      onTap: tapped.add,
      appOriginEnum: origin,
      applicationContainer: harness.container,
    );
  }

  testWidgets('carrega a lista na abertura e mostra as notificações',
      (tester) async {
    harness = NotificationsHarness();
    harness.stubList([
      notificationJson(id: 'a', title: 'Boleto disponível', date: DateTime.now()),
      notificationJson(
          id: 'b',
          title: 'Ocorrência',
          module: 'OCORRENCIA',
          markRead: true,
          date: DateTime(2025, 3, 7, 8)),
    ]);
    final controller = harness.buildController();

    await pumpPage(tester, buildPage(controller),
        providers: withNotificationAssets);

    expect(find.byType(NotificationListTile), findsNWidgets(2));
    expect(find.text('Boleto disponível'), findsOneWidget);
    expect(find.text('Ocorrência'), findsOneWidget);
    expect(find.text('Esta semana'), findsOneWidget);
    expect(find.text('Março de 2025'), findsOneWidget);
    expect(find.text('Não lida'), findsOneWidget);
    expect(find.text('Condomínio Teste - R1'), findsOneWidget);
    expect(find.byType(CustomAppBar), findsNothing);
    expect(harness.requestedPaths, contains(harness.listPath));

    await expectLater(
      find.byType(NotificationListPage),
      matchesGoldenFile('goldens/notification_list_page.png'),
    );
  });

  testWidgets('colaborador ganha a CustomAppBar e a lista vazia mostra aviso',
      (tester) async {
    harness = NotificationsHarness(origin: AppOriginEnum.employee);
    harness.stubList([]);
    final controller = harness.buildController();

    await pumpPage(tester, buildPage(controller, origin: AppOriginEnum.employee),
        providers: withNotificationAssets);

    expect(find.byType(CustomAppBar), findsOneWidget);
    expect(find.text('dont_have_notifications'), findsOneWidget);
    expect(find.byType(NotificationListTile), findsNothing);

    // Tocar no corpo fecha o overlay.
    await tester.tap(find.text('dont_have_notifications'));
    await tester.pump();
    expect(closed, 1);

    await expectLater(
      find.byType(NotificationListPage),
      matchesGoldenFile('goldens/notification_list_page_empty.png'),
    );
  });

  testWidgets('erro mostra a mensagem e "tentar novamente" recarrega',
      (tester) async {
    harness = NotificationsHarness();
    harness.http.failAll();
    final controller = harness.buildController();

    await pumpPage(tester, buildPage(controller),
        providers: withNotificationAssets);

    expect(find.text('warning_failed_message'), findsOneWidget);
    expect(find.text('try_again'), findsOneWidget);

    harness.stubList([notificationJson(id: 'a', title: 'Nova')]);
    await tester.tap(find.text('try_again'));
    await tester.pumpAndSettle();

    expect(find.text('Nova'), findsOneWidget);
    expect(find.byType(NotificationListTile), findsOneWidget);
  });

  testWidgets('erro permite puxar para recarregar', (tester) async {
    harness = NotificationsHarness();
    harness.http.failAll();
    final controller = harness.buildController();
    await pumpPage(tester, buildPage(controller),
        providers: withNotificationAssets);
    final before = harness.http.requests.length;

    await tester.fling(
        find.text('warning_failed_message'), const Offset(0, 300), 1000);
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(harness.http.requests.length, greaterThan(before));
  });

  testWidgets('estado de loading mostra o indicador e o vazio não desenha nada',
      (tester) async {
    harness = NotificationsHarness();
    harness.stubList([]);
    final controller = harness.buildController();
    await pumpPage(tester, buildPage(controller),
        settle: false, providers: withNotificationAssets);

    await emitState(tester, controller.bloc, NotificationListLoadingState(),
        settle: false);
    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await emitState(tester, controller.bloc, NotificationListEmptyState(),
        settle: false);
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(NotificationListWidget), findsNothing);
  });

  testWidgets('não recarrega quando o bloc já tem a página carregada',
      (tester) async {
    harness = NotificationsHarness();
    harness.stubList([]);
    final controller = harness.buildController();
    // ignore: invalid_use_of_visible_for_testing_member
    controller.bloc.emit(NotificationListPageState(
        notificationsNotRead: 0, notificationList: [buildNotification()]));

    await pumpPage(tester, buildPage(controller),
        providers: withNotificationAssets);

    expect(harness.http.requests, isEmpty);
    expect(find.byType(NotificationListTile), findsOneWidget);
  });
}
