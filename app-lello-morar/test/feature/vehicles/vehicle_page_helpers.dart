import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/me/domain/entity/me.dart';
import 'package:morar/feature/session/domain/entity/session.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

/// JSON de um veículo como a API `/concierge/vehicle/{unit_id}` devolve.
Map<String, dynamic> vehicleJson(
  String id, {
  String type = 'CARRO',
  String? plate = 'ABC1234',
  String color = 'Azul',
  String model = 'Gol',
  bool rentedSpace = false,
  String? additionalInfo,
  Map<String, dynamic>? creator,
}) =>
    {
      'id': id,
      'type': type,
      'identification_number': plate,
      'model': model,
      'color': color,
      'unit_id': 'u1',
      'rented_space': rentedSpace,
      'additional_info': additionalInfo,
      'concierge_creator': creator,
    };

Map<String, dynamic> creatorJson(String type, {String name = 'Ana'}) => {
      'id': 'c1',
      'name': name,
      'type': type,
    };

/// Entidade pronta para a `EditVehiclePage` (chega via `arguments`).
Vehicle vehicleEntity({
  String id = 'v1',
  String? type = 'CARRO',
  String? plate = 'ABC1234',
  String? color = 'Azul',
  String? model = 'Gol',
  bool? rentedSpace = false,
  String? additionalInfo,
  ConciergeCreator? creator,
}) =>
    Vehicle(
      id: id,
      type: type,
      model: model,
      color: color,
      unitId: 'u1',
      identificationNumber: plate,
      rentedSpace: rentedSpace,
      additionalInfo: additionalInfo,
      creator: creator,
    );

/// Deixa a sessão do [harness] sem condomínio/unidade (usuário sem
/// vínculos). Também atualiza o `state`, que o FakeSessionBloc congela no
/// construtor.
void useSessionWithoutUnit(PageHarness harness) {
  final me = Me()
    ..id = 'm1'
    ..name = 'ana silva'
    ..cpf = '12345678901'
    ..condominiums = null;
  final session = Session()..me = me;
  harness.sessionBloc.session = session;
  harness.sessionBloc.currentState = SessionLoadedState(session);
}

/// Emite [state] no [bloc] e dá os frames necessários para o BlocBuilder
/// reagir, sem `pumpAndSettle` (loading tem animação infinita).
Future<void> emitAndPump(WidgetTester tester, Bloc bloc, Object state) async {
  await emitState(tester, bloc, state, settle: false);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 50));
}

const vehiclesListPath = '/concierge/vehicle/u1';
const vehiclePath = '/concierge/vehicle';

const _inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');

/// `AppReview.call` consulta o in_app_review: responde "indisponível" e
/// registra os métodos chamados.
List<String> installFakeInAppReview() {
  final calls = <String>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(_inAppReviewChannel, (call) async {
    calls.add(call.method);
    return false;
  });
  addTearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, null);
  });
  return calls;
}

/// Chave do botão da página "lançadora" usada por [pumpPushed].
const launcherButtonKey = Key('launcher-push');

/// Monta uma página vazia e empurra [page] por cima dela (rota
/// [routeName]), para que `Navigator.pop` da página sob teste tenha para
/// onde voltar.
Future<void> pumpPushed(
  WidgetTester tester,
  Widget page, {
  String routeName = '/pushed-page',
  Object? arguments,
  RecordingNavigatorObserver? observer,
  Map<String, WidgetBuilder> routes = const {},
  Size surface = const Size(400, 800),
  bool settle = true,
}) async {
  await pumpPage(
    tester,
    Builder(
      builder: (context) => Scaffold(
        key: const Key('launcher'),
        body: ElevatedButton(
          key: launcherButtonKey,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              settings: RouteSettings(name: routeName, arguments: arguments),
              builder: (_) => page,
            ),
          ),
          child: const Text('abrir'),
        ),
      ),
    ),
    observer: observer,
    routes: routes,
    surface: surface,
  );
  await tester.tap(find.byKey(launcherButtonKey));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }
}
