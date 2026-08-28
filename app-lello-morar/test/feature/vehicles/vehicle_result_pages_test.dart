import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/vehicles/presentation/pages/VehicleErrorPage.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_case_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_remove_case_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_update_case_page.dart';
import 'package:morar/feature/vehicles/presentation/widgets/secoundary_app_bar.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'vehicle_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late List<String> reviewCalls;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    reviewCalls = installFakeInAppReview();
  });

  testWidgets('página de veículo adicionado mostra a unidade e conclui',
      (tester) async {
    await pumpPage(tester, VehicleSucessPage(), observer: observer);

    expect(find.text('me_vehicles_add_success'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
    await expectLater(
      find.byType(VehicleSucessPage),
      matchesGoldenFile('goldens/vehicle_success_page.png'),
    );

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(reviewCalls, contains('isAvailable'));
    expect(observer.pushedNames.last, ApplicationRoute.vehiclePage);
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  testWidgets('página de veículo adicionado sem sessão mostra o traço',
      (tester) async {
    useSessionWithoutUnit(harness);

    await pumpPage(tester, VehicleSucessPage());

    expect(find.text(' - '), findsOneWidget);
  });

  testWidgets('página de veículo removido conclui voltando para a lista',
      (tester) async {
    await pumpPage(tester, VehicleRemovedSucessPage(), observer: observer);

    expect(find.text('me_vehicles_delete_success'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(reviewCalls, contains('isAvailable'));
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  testWidgets('página de veículo atualizado conclui voltando para a lista',
      (tester) async {
    await pumpPage(tester, VehicleUpdateSucessPage(), observer: observer);

    expect(find.text('me_vehicles_update_success'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(reviewCalls, contains('isAvailable'));
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  testWidgets('página de erro mostra as mensagens e tentar de novo volta',
      (tester) async {
    await pumpPushed(tester, const VehicleErrorPage(), observer: observer);

    expect(find.text('me_vehicles_add_error_general'), findsOneWidget);
    expect(find.text('me_vehicles_add_error_review'), findsOneWidget);
    await expectLater(
      find.byType(VehicleErrorPage),
      matchesGoldenFile('goldens/vehicle_error_page.png'),
    );

    await tester.tap(find.text('me_vehicles_try_again'));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(1));
    expect(find.byType(VehicleErrorPage), findsNothing);
  });

  testWidgets('VehicleAppBar mostra o título e chama o voltar', (tester) async {
    var pressed = 0;
    await pumpApp(
      tester,
      Scaffold(
        appBar: VehicleAppBar(title: 'Veículos', onPressed: () => pressed++),
      ),
      wrapInScaffold: false,
      shrinkWrap: false,
    );

    expect(find.text('Veículos'), findsOneWidget);
    expect(tester.widget<VehicleAppBar>(find.byType(VehicleAppBar)).preferredSize.height, 60);
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    expect(pressed, 1);
  });
}
