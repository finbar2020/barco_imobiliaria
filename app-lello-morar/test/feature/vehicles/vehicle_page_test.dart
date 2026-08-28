import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';
import 'package:morar/feature/vehicles/presentation/pages/vehicle_page.dart';
import 'package:morar/feature/vehicles/presentation/widgets/vehicle_widget.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'vehicle_page_helpers.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
  });

  VehicleController controller() => harness.resolve<VehicleController>();

  testWidgets('lista os veículos da unidade com placa, cor e criador',
      (tester) async {
    harness.http.on('GET', vehiclesListPath, body: [
      vehicleJson('1', creator: creatorJson('appmorar', name: 'Ana')),
      vehicleJson('2',
          type: 'MOTO',
          plate: null,
          color: 'preto',
          creator: creatorJson('appsindico')),
      vehicleJson('3',
          type: 'BICICLETA',
          plate: null,
          color: '',
          creator: creatorJson('portaria')),
    ]);

    await pumpPage(tester, VehiclePage(), observer: observer,
        surface: const Size(400, 900));

    expect(harness.http.requests.single.url.path, vehiclesListPath);
    expect(find.byType(VehicleContainer), findsNWidgets(3));
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('Carro'), findsOneWidget);
    expect(find.text('Moto'), findsOneWidget);
    expect(find.text('Bicicleta'), findsOneWidget);
    expect(find.text('ABC1234'), findsOneWidget);
    // Moto sem placa mostra o aviso; bicicleta não mostra placa.
    expect(find.text('me_vehicles_no_plate'), findsOneWidget);
    expect(find.text('blue'), findsOneWidget);
    expect(find.text('black'), findsOneWidget);
    expect(find.text('accountability_others'), findsOneWidget);
    expect(find.text('creator_vehicle Ana'), findsOneWidget);
    expect(find.text('creator_vehicle_sindico'), findsOneWidget);
    expect(find.text('creator_vehicle_concierge'), findsOneWidget);
    expect(find.text('me_vehicles_add'), findsOneWidget);

    await expectLater(
      find.byType(VehiclePage),
      matchesGoldenFile('goldens/vehicle_page.png'),
    );
  });

  testWidgets('sem veículos mostra a mensagem de vazio', (tester) async {
    harness.http.on('GET', vehiclesListPath, body: []);

    await pumpPage(tester, VehiclePage());

    expect(find.text('me_vehicles_empty'), findsOneWidget);
    expect(find.byType(VehicleContainer), findsNothing);
  });

  testWidgets('erro na api mostra o widget de erro, retry recarrega e voltar fecha',
      (tester) async {
    harness.http.failAll();

    await pumpPushed(tester, VehiclePage(), observer: observer);
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(controller().vehicleBloc.state, isA<VehicleLoadingFailedState>());

    harness.http.on('GET', vehiclesListPath, body: [vehicleJson('9')]);
    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(find.byType(VehicleContainer), findsOneWidget);

    // Volta a falhar para testar o botão de voltar do widget de erro.
    harness.http.failAll();
    controller().getVehicle();
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    await tester.tap(find.text('error_handling_widget_button_back').first);
    await tester.pumpAndSettle();
    expect(observer.popped, hasLength(1));
    expect(find.byType(VehiclePage), findsNothing);
  });

  testWidgets('sem unidade na sessão falha sem chamar a api', (tester) async {
    useSessionWithoutUnit(harness);

    await pumpPage(tester, VehiclePage());

    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(harness.http.requests, isEmpty);
  });

  testWidgets('estados de loading e desconhecido mostram o indicador',
      (tester) async {
    harness.http.on('GET', vehiclesListPath, body: []);
    await pumpPage(tester, VehiclePage());
    final bloc = controller().vehicleBloc;

    await emitAndPump(tester, bloc, const VehicleLoadingDataInProgressState());
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitAndPump(tester, bloc, const VehicleIsEmptyState());
    expect(find.byType(LoadingWidget), findsOneWidget);

    // Estado sem tratamento específico cai no indicador genérico.
    await emitAndPump(tester, bloc, const VehicleAddedState([]));
    expect(find.byType(LoadingWidget), findsNothing);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('tocar em um veículo abre a edição com o veículo como argumento',
      (tester) async {
    harness.http.on('GET', vehiclesListPath, body: [vehicleJson('1')]);
    await pumpPage(tester, VehiclePage(), observer: observer);

    await tester.tap(find.byType(VehicleContainer));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.editVehiclePage);
    expect(findRoute(ApplicationRoute.editVehiclePage), findsOneWidget);
    final args = observer.pushed.last.settings.arguments as Vehicle;
    expect(args.id, '1');
    expect(args.identificationNumber, 'ABC1234');
  });

  testWidgets('botão de adicionar loga o evento e abre a página de novo veículo',
      (tester) async {
    harness.http.on('GET', vehiclesListPath, body: []);
    fakeAnalytics.reset();
    await pumpPage(tester, VehiclePage(), observer: observer);

    await tester.tap(find.text('me_vehicles_add'));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.newVehiclePage);
    expect(findRoute(ApplicationRoute.newVehiclePage), findsOneWidget);
    expect(fakeAnalytics.eventNames,
        contains('veiculo_acessar_adicionar_novo_veiculo'));
  });

  testWidgets('seta de voltar fecha a página', (tester) async {
    harness.http.on('GET', vehiclesListPath, body: []);
    await pumpPushed(tester, VehiclePage(), observer: observer);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(observer.popped, hasLength(1));
    expect(find.byType(VehiclePage), findsNothing);
  });

  testWidgets('VehicleContainer usa a altura informada', (tester) async {
    await pumpApp(
      tester,
      VehicleContainer(height: 80, child: const Text('x')),
    );
    final size = tester.getSize(find.byType(VehicleContainer));
    expect(size.height, 80);
    expect(find.text('x'), findsOneWidget);
  });
}
