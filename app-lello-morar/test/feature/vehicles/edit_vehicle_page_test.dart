import 'dart:convert';

import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';
import 'package:morar/feature/vehicles/presentation/pages/edit_vehicle_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_remove_case_page.dart';
import 'package:morar/feature/vehicles/presentation/pages/sucess_update_case_page.dart';

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
    installFakeInAppReview();
  });

  VehicleController controller() => harness.resolve<VehicleController>();

  Future<void> pumpEdit(WidgetTester tester, {Vehicle? vehicle}) => pumpPage(
        tester,
        EditVehiclePage(),
        arguments: vehicle ?? vehicleEntity(),
        observer: observer,
        surface: const Size(500, 1500),
      );

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

  Map<String, dynamic> lastBody() =>
      jsonDecode(harness.http.requests.last.body) as Map<String, dynamic>;

  testWidgets('preenche o formulário com os dados do veículo', (tester) async {
    await pumpEdit(
      tester,
      vehicle: vehicleEntity(
          rentedSpace: true, additionalInfo: 'vaga 12', color: 'Azul'),
    );

    expect(find.text('me_vehicles_edit'), findsOneWidget);
    expect(find.text('CARRO'), findsOneWidget);
    expect(find.text('ABC1234'), findsOneWidget);
    expect(find.text('Gol'), findsOneWidget);
    expect(find.text('blue'), findsOneWidget);
    expect(find.text('vaga 12'), findsOneWidget);
    expect(find.text('me_vehicles_delete'), findsOneWidget);
    expect(find.text('conclude'), findsOneWidget);

    await expectLater(
      find.byType(EditVehiclePage),
      matchesGoldenFile('goldens/edit_vehicle_page.png'),
    );
  });

  testWidgets('sem informações adicionais mostra o placeholder',
      (tester) async {
    await pumpEdit(tester, vehicle: vehicleEntity(additionalInfo: null));

    expect(find.text('me_vehicles_additional_info_empty'), findsOneWidget);
  });

  testWidgets('seta de voltar abre a lista de veículos', (tester) async {
    await pumpEdit(tester);

    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle();

    expect(observer.pushedNames.last, ApplicationRoute.vehiclePage);
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  testWidgets('concluir atualiza o veículo e abre a página de sucesso',
      (tester) async {
    harness.http.on('PUT', vehiclePath, body: [vehicleJson('v1')]);
    await pumpEdit(tester);

    await tester.enterText(find.byType(TextField).first, 'XYZ9876');
    await tester.pumpAndSettle();
    expect(find.text('XYZ9876'), findsOneWidget);
    await pick(tester, 'blue', 'green');
    await tester.enterText(find.byType(TextField).at(1), 'Onix');
    await tester.enterText(find.byType(TextField).last, 'vaga coberta');
    await tester.tap(find.text('yes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    final request = harness.http.requests.single;
    expect(request.method, 'PUT');
    expect(request.url.path, vehiclePath);
    final body = lastBody();
    expect(body['id'], 'v1');
    expect(body['type'], 'CARRO');
    expect(body['identification_number'], 'XYZ9876');
    expect(body['color'], 'Verde');
    expect(body['model'], 'Onix');
    expect(body['rented_space'], isTrue);
    expect(body['additional_info'], 'vaga coberta');
    expect(controller().vehicleBloc.state, isA<VehicleUpdatedState>());
    expect(find.byType(VehicleUpdateSucessPage), findsOneWidget);
    expect(find.text('me_vehicles_update_success'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);

    // Concluir na página de sucesso volta para a lista de veículos.
    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();
    expect(observer.pushedNames.last, ApplicationRoute.vehiclePage);
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  testWidgets('trocar para bicicleta esconde a placa e salva sem ela',
      (tester) async {
    harness.http.on('PUT', vehiclePath, body: [vehicleJson('v1')]);
    await pumpEdit(tester);

    await pick(tester, 'CARRO', 'me_vehicles_bike');
    expect(find.text('me_vehicles_plate'), findsNothing);
    await tester.tap(find.text('no'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    final body = lastBody();
    expect(body['type'], 'Bicicleta');
    expect(body['identification_number'], isNull);
    expect(body['rented_space'], isFalse);
    expect(find.byType(VehicleUpdateSucessPage), findsOneWidget);
  });

  testWidgets('trocar para moto e apagar a placa mostra o aviso', (tester) async {
    await pumpEdit(tester);

    await pick(tester, 'CARRO', 'me_vehicles_motorcycle');
    await tester.enterText(find.byType(TextField).first, '');
    await tester.pumpAndSettle();
    expect(find.text('validation_required'), findsOneWidget);

    await tester.tap(find.text('conclude'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('me_vehicles_fill_vehicle_plate'), findsOneWidget);
    expect(harness.http.requests, isEmpty);
    await tester.pump(const Duration(seconds: 4));
    await tester.pumpAndSettle();
  });

  testWidgets('placa inválida mostra o erro do formato', (tester) async {
    await pumpEdit(tester);

    await tester.enterText(find.byType(TextField).first, 'A1');
    await tester.pumpAndSettle();

    expect(find.text('invalid_license_plate_format'), findsOneWidget);
  });

  testWidgets('erro 400 ao atualizar mostra o widget de erro e retry volta ao formulário',
      (tester) async {
    harness.http.on('PUT', vehiclePath,
        status: 400,
        body: {'status': 400, 'failure': 'placa_duplicada', 'title': 'Dup'});
    await pumpEdit(tester);

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();

    expect(controller().vehicleBloc.state, isA<VehicleAddingFailedState>());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(find.text('placa_duplicada'), findsWidgets);

    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();
    expect(controller().vehicleBloc.state, isA<VehicleIsEmptyState>());
    expect(find.text('conclude'), findsOneWidget);

    // Voltar do widget de erro também reinicia o estado.
    harness.http.on('PUT', vehiclePath, status: 500, body: {'message': 'x'});
    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    await tester.tap(find.text('error_handling_widget_button_back').first);
    await tester.pumpAndSettle();
    expect(find.text('conclude'), findsOneWidget);
  });

  testWidgets('excluir pede confirmação; voltar fecha o diálogo', (tester) async {
    await pumpEdit(tester);

    await tester.tap(find.text('me_vehicles_delete'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('me_vehicles_sure_delete'), findsOneWidget);
    expect(find.text('Edifício Lello - 101'), findsOneWidget);

    await tester.tap(find.text('BACK'));
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsNothing);
    expect(harness.http.requests, isEmpty);
  });

  testWidgets('confirmar a exclusão remove o veículo e abre a página de sucesso',
      (tester) async {
    harness.http.on('DELETE', '$vehiclePath/v1', body: {});
    fakeAnalytics.reset();
    await pumpEdit(tester);

    await tester.tap(find.text('me_vehicles_delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONFIRM'));
    await tester.pumpAndSettle();

    final request = harness.http.requests.single;
    expect(request.method, 'DELETE');
    expect(request.url.path, '$vehiclePath/v1');
    expect(controller().vehicleBloc.state, isA<VehicleRemovedState>());
    expect(find.byType(VehicleRemovedSucessPage), findsOneWidget);
    expect(find.text('me_vehicles_delete_success'), findsOneWidget);
    expect(fakeAnalytics.eventNames, contains('veiculo_acessar_excluir_veiculo'));

    await tester.tap(find.text('conclude'));
    await tester.pumpAndSettle();
    expect(findRoute(ApplicationRoute.vehiclePage), findsOneWidget);
  });

  testWidgets('falha ao excluir mostra a mensagem de erro', (tester) async {
    harness.http.on('DELETE', '$vehiclePath/v1', status: 500, body: {'message': 'x'});
    await pumpEdit(tester);

    await tester.tap(find.text('me_vehicles_delete'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('CONFIRM'));
    await tester.pumpAndSettle();

    expect(controller().vehicleBloc.state, isA<DeleteVehicleErrorState>());
    expect(find.text('warning_failed_message'), findsOneWidget);
  });

  testWidgets('falha de carregamento também mostra a mensagem de erro',
      (tester) async {
    await pumpEdit(tester);

    await emitState(tester, controller().vehicleBloc,
        const VehicleLoadingFailedState('x'));

    expect(find.text('warning_failed_message'), findsOneWidget);
  });

  testWidgets('estados de loading mostram o indicador', (tester) async {
    await pumpEdit(tester);
    final bloc = controller().vehicleBloc;

    await emitAndPump(tester, bloc, const VehicleLoadingDeleteInProgressState());
    expect(find.byType(LoadingWidget), findsOneWidget);

    await emitAndPump(tester, bloc, const VehicleLoadingUpdateInProgressState());
    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.text('conclude'), findsNothing);
  });
}
