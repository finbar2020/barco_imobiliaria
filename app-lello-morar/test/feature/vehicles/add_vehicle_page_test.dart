import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';
import 'package:morar/feature/vehicles/presentation/pages/VehicleErrorPage.dart';
import 'package:morar/feature/vehicles/presentation/pages/add_vehicle_page.dart';

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

  Finder dropdown(String hint) => find.ancestor(
        of: find.text(hint),
        matching: find.byType(DropdownButtonFormField<String>),
      );

  Future<void> pick(WidgetTester tester, String hint, String option) async {
    await tester.tap(dropdown(hint));
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
  }

  Future<void> pumpAdd(WidgetTester tester) => pumpPage(
        tester,
        AddVehiclePage(),
        observer: observer,
        surface: const Size(500, 1400),
        routes: {
          ApplicationRoute.vehicleErrorPage: (_) => const VehicleErrorPage(),
        },
      );

  testWidgets('mostra o formulário de novo veículo', (tester) async {
    await pumpAdd(tester);

    expect(find.text('me_vehicles_add_vehicle'), findsOneWidget);
    expect(find.text('payroll_type'), findsOneWidget);
    expect(find.text('choose_type'), findsOneWidget);
    expect(find.text('me_vehicles_plate'), findsOneWidget);
    expect(find.text('AAA-0000 ou AAA0A00'), findsOneWidget);
    expect(find.text('color'), findsOneWidget);
    expect(find.text('choose_color'), findsOneWidget);
    expect(find.text('me_vehicles_model_field'), findsOneWidget);
    expect(find.text('me_vehicles_rented_space'), findsOneWidget);
    expect(find.text('yes'), findsOneWidget);
    expect(find.text('no'), findsOneWidget);
    expect(find.text('me_vehicles_additional_info'), findsOneWidget);
    expect(find.text('add'), findsOneWidget);
    // Sem tocar no campo de placa não há erro de validação.
    expect(find.text('validation_required'), findsNothing);

    await expectLater(
      find.byType(AddVehiclePage),
      matchesGoldenFile('goldens/add_vehicle_page.png'),
    );
  });

  testWidgets('seta de voltar abre a lista de veículos', (tester) async {
    await pumpAdd(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.vehiclePage);
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  /// Corrigido: `Vehicle.setType` é nulo-seguro (`value?.toUpperCase()`),
  /// então tocar em "adicionar" sem tipo chega ao `isNotValid` e mostra o
  /// aviso `me_vehicles_fill_vehicle_type` em vez de lançar `_TypeError`.
  testWidgets('adicionar sem tipo mostra o aviso de tipo e não chama a api',
      (tester) async {
    await pumpAdd(tester);

    await tester.tap(find.text('add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);
    expect(find.text('me_vehicles_fill_vehicle_type'), findsOneWidget);
    // O `_isSubmitting` já foi marcado: a placa vazia mostra o obrigatório.
    expect(find.text('validation_required'), findsOneWidget);
    expect(harness.http.requests, isEmpty);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('carro sem placa avisa; placa inválida mostra erro no campo',
      (tester) async {
    await pumpAdd(tester);
    await pick(tester, 'choose_type', 'me_vehicles_car');

    // Corrigido: o formatter converte para maiúsculas antes de filtrar
    // [A-Z0-9-], então minúsculas digitadas viram maiúsculas.
    await tester.enterText(find.byType(TextField).first, 'ab1');
    await tester.pumpAndSettle();
    expect(find.text('AB1'), findsOneWidget);
    expect(find.text('invalid_license_plate_format'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    await tester.tap(find.text('add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('me_vehicles_fill_vehicle_plate'), findsOneWidget);
    expect(harness.http.requests, isEmpty);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('carro com placa mas sem cor avisa', (tester) async {
    await pumpAdd(tester);
    await pick(tester, 'choose_type', 'me_vehicles_car');
    await tester.enterText(find.byType(TextField).first, 'ABC1D23');
    await tester.pumpAndSettle();
    expect(find.text('invalid_license_plate_format'), findsNothing);

    await tester.tap(find.text('add'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('me_vehicles_fill_vehicle_color'), findsOneWidget);
    expect(harness.http.requests, isEmpty);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('bicicleta esconde a placa e salva sem ela', (tester) async {
    harness.http.on('POST', vehiclePath, body: [vehicleJson('n1')]);
    fakeAnalytics.reset();
    await pumpAdd(tester);

    await pick(tester, 'choose_type', 'me_vehicles_bike');
    expect(find.text('me_vehicles_plate'), findsNothing);
    expect(find.text('AAA-0000 ou AAA0A00'), findsNothing);

    await pick(tester, 'choose_color', 'accountability_others');
    await tester.enterText(find.byType(TextField).first, 'Caloi');
    await tester.enterText(find.byType(TextField).last, 'guardada no bicicletário');
    await tester.tap(find.text('yes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();

    final request = harness.http.requests.single;
    expect(request.method, 'POST');
    expect(request.url.path, vehiclePath);
    final body = jsonDecode(request.body) as Map<String, dynamic>;
    expect(body['type'], 'Bicicleta');
    expect(body['identification_number'], isNull);
    expect(body['color'], 'Outros');
    expect(body['model'], 'Caloi');
    expect(body['rented_space'], isTrue);
    expect(body['additional_info'], 'guardada no bicicletário');
    expect(body['unit_id'], 'u1');
    expect(controller().vehicleBloc.state, isA<VehicleAddedState>());
    expect(observer.pushedNames.last, ApplicationRoute.vehicleSucceeded);
    expect(findRoute(ApplicationRoute.vehicleSucceeded), findsOneWidget);
    expect(fakeAnalytics.eventNames,
        contains('veiculo_acessar_adicionar_novo_veiculo_sucesso'));
  });

  testWidgets('moto com placa válida salva com o tipo e cor mapeados',
      (tester) async {
    harness.http.on('POST', vehiclePath, body: [vehicleJson('n2')]);
    await pumpAdd(tester);

    await pick(tester, 'choose_type', 'me_vehicles_motorcycle');
    await tester.enterText(find.byType(TextField).first, 'ABC-1234');
    await pick(tester, 'choose_color', 'red');
    await tester.tap(find.text('yes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('no'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();

    final body =
        jsonDecode(harness.http.requests.single.body) as Map<String, dynamic>;
    expect(body['type'], 'Moto');
    expect(body['identification_number'], 'ABC-1234');
    expect(body['color'], 'Vermelho');
    expect(body['rented_space'], isFalse);
    expect(findRoute(ApplicationRoute.vehicleSucceeded), findsOneWidget);
  });

  testWidgets('erro 400 conhecido abre a página de erro e voltar retorna ao formulário',
      (tester) async {
    harness.http.on('POST', vehiclePath,
        status: 400,
        body: {
          'status': 400,
          'failure': 'placa_duplicada',
          'title': 'Placa já cadastrada'
        });
    await pumpAdd(tester);

    await pick(tester, 'choose_type', 'me_vehicles_car');
    await tester.enterText(find.byType(TextField).first, 'ABC1234');
    await pick(tester, 'choose_color', 'blue');
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();

    final state = controller().vehicleBloc.state;
    expect(state, isA<VehicleAddingFailedState>());
    expect((state as VehicleAddingFailedState).failed, 'placa_duplicada');
    expect(observer.pushedNames.last, ApplicationRoute.vehicleErrorPage);
    expect(find.byType(VehicleErrorPage), findsOneWidget);
    expect(find.text('me_vehicles_add_error_general'), findsOneWidget);

    await tester.tap(find.text('me_vehicles_try_again'));
    await tester.pumpAndSettle();
    expect(find.byType(VehicleErrorPage), findsNothing);
    expect(find.byType(AddVehiclePage), findsOneWidget);
  });

  testWidgets('erro desconhecido também abre a página de erro', (tester) async {
    harness.http.on('POST', vehiclePath, status: 500, body: {'message': 'x'});
    await pumpAdd(tester);

    await pick(tester, 'choose_type', 'me_vehicles_car');
    await tester.enterText(find.byType(TextField).first, 'ABC1234');
    await pick(tester, 'choose_color', 'gray');
    await tester.tap(find.text('add'));
    await tester.pumpAndSettle();

    final state = controller().vehicleBloc.state as VehicleAddingFailedState;
    expect(state.failed, 'impossible to add');
    expect(find.byType(VehicleErrorPage), findsOneWidget);
  });

  testWidgets('estado de loading mostra o indicador', (tester) async {
    await pumpAdd(tester);

    await emitAndPump(tester, controller().vehicleBloc,
        const VehicleLoadingAddInProgressState());

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.text('add'), findsNothing);
  });
}
