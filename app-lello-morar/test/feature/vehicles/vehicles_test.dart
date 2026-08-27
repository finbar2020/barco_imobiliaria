import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:essentials/network/api_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_api.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_remote_data_source.dart';
import 'package:morar/feature/vehicles/data/data_source/vehicles_remote_data_sourece_impl.dart';
import 'package:morar/feature/vehicles/data/models/vehicles_model.dart';
import 'package:morar/feature/vehicles/data/repository/vehicles_repository_impl.dart';
import 'package:morar/feature/vehicles/domain/entity/concierge_creator.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';
import 'package:morar/feature/vehicles/domain/repository/vehicles_repository.dart';
import 'package:morar/feature/vehicles/domain/use_cases/delete_vehicles/delete_vehicle.dart';
import 'package:morar/feature/vehicles/domain/use_cases/delete_vehicles/delete_vehicle_impl.dart';
import 'package:morar/feature/vehicles/domain/use_cases/get_vehicles/get_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/get_vehicles/get_vehicles_impl.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/save_vehicles/save_vehicles_impl.dart';
import 'package:morar/feature/vehicles/domain/use_cases/update_vehicles/update_vehicles.dart';
import 'package:morar/feature/vehicles/domain/use_cases/update_vehicles/update_vehicles_impl.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_event.dart';
import 'package:morar/feature/vehicles/presentation/bloc/vehicle_state.dart';
import 'package:morar/feature/vehicles/presentation/controllers/vehicle_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';
import '../../helpers/pump_app.dart';

class MockApi extends Mock implements VehicleApi {}

Vehicle _vehicle({String? type = 'CARRO', String? plate = 'ABC1234', String? color = 'Azul'}) => Vehicle(
      id: 'v1',
      type: type,
      model: 'Gol',
      color: color,
      unitId: 'u1',
      identificationNumber: plate,
      rentedSpace: true,
      additionalInfo: 'info',
      creator: ConciergeCreator(name: 'Ana', id: 'c', type: ConciergeCreatorType.appmorar),
    );

class _FakeDataSource extends Fake implements VehicleRemoteDataSource {
  _FakeDataSource({this.error});
  final Object? error;
  @override
  Future<List<VehicleModel>?> getVehiclesList(String unityId) async {
    if (error != null) throw error!;
    return [VehicleModel(id: unityId)];
  }

  @override
  Future<List<VehicleModel>?> insertVehicle(VehicleModel vehicleModel) async {
    if (error != null) throw error!;
    return [vehicleModel];
  }

  @override
  Future<List<VehicleModel>?> put(VehicleModel vehicleModel, String id) async {
    if (error != null) throw error!;
    return null;
  }

  @override
  Future<String> delete(String id) async {
    if (error != null) throw error!;
    return '';
  }
}

class _FakeRepository extends Fake implements VehicleRepository {
  _FakeRepository({this.failure});
  final Failure? failure;
  final calls = <String>[];
  @override
  Future<Try<List<Vehicle>>> getVehicleList(String unitId) async {
    calls.add('get:$unitId');
    if (failure != null) return Rejection(failure!);
    return Success([_vehicle()]);
  }

  @override
  Future<Try<List<Vehicle>>> post(Vehicle vehicle) async {
    calls.add('post:${vehicle.unitId}');
    if (failure != null) return Rejection(failure!);
    return Success([vehicle]);
  }

  @override
  Future<Try<List<Vehicle>>> put(Vehicle vehicle, String? vehicleId) async {
    calls.add('put:${vehicle.id}');
    if (failure != null) return Rejection(failure!);
    return Success([vehicle]);
  }

  @override
  Future<Try<String>> delete(String vehicleId) async {
    calls.add('delete:$vehicleId');
    if (failure != null) return Rejection(failure!);
    return Success('');
  }
}

Future<List<dynamic>> _collect(Bloc bloc, Future<void> Function() run) async {
  final states = <dynamic>[];
  final sub = bloc.stream.listen(states.add);
  await run();
  await Future<void>.delayed(const Duration(milliseconds: 20));
  await sub.cancel();
  return states;
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  group('Vehicle', () {
    test('validação, ícone e placa', () {
      expect(_vehicle().isNotValid, isNull);
      expect(_vehicle(type: null).isNotValid, 'me_vehicles_fill_vehicle_type');
      expect(_vehicle(plate: null).isNotValid, 'me_vehicles_fill_vehicle_plate');
      expect(_vehicle(type: 'BICICLETA', plate: null, color: null).isNotValid,
          'me_vehicles_fill_vehicle_color');
      expect(_vehicle().setSvgIcon(), 'assets/vehicles_icon.svg');
      expect(_vehicle(type: 'MOTO').setSvgIcon(), 'assets/moto_icon.svg');
      expect(_vehicle(type: 'BICICLETA').setSvgIcon(), 'assets/ic_bicicleta.svg');
      expect(_vehicle(type: 'x').setSvgIcon(), 'assets/vehicles_icon.svg');
      expect(_vehicle().showPlateInfo(), isTrue);
      expect(_vehicle(type: 'bicicleta').showPlateInfo(), isFalse);
      expect(_vehicle().copyWith(model: 'Uno').model, 'Uno');
      expect(_vehicle().copyWith().id, 'v1');
    });

    testWidgets('textos dependentes de contexto', (tester) async {
      await pumpApp(tester, const Text('x'), localized: true);
      final context = tester.element(find.text('x'));
      final vehicle = _vehicle();
      expect(vehicle.setType(context, 'me_vehicles_motorcycle'), 'Moto');
      expect(vehicle.setType(context, 'me_vehicles_car'), 'Carro');
      expect(vehicle.setType(context, 'ME_VEHICLES_BIKE'), 'Bicicleta');
      expect(vehicle.setType(context, 'Outro'), 'Outro');
      expect(vehicle.getCor(context, 'AZUL'), 'blue');
      expect(vehicle.getCor(context, 'marrom'), 'brown');
      expect(vehicle.getCor(context, 'verde'), 'green');
      expect(vehicle.getCor(context, 'vermelho'), 'red');
      expect(vehicle.getCor(context, 'branco'), 'white');
      expect(vehicle.getCor(context, 'amarelo'), 'yellow');
      expect(vehicle.getCor(context, 'prata'), 'silver');
      expect(vehicle.getCor(context, 'preto'), 'black');
      expect(vehicle.getCor(context, 'cinza'), 'gray');
      expect(vehicle.getCor(context, 'roxo'), 'accountability_others');
      expect(vehicle.getCor(context, ''), 'accountability_others');
      expect(vehicle.setTypeCor(context, 'blue'), 'Azul');
      expect(vehicle.setTypeCor(context, 'gray'), 'Cinza');
      expect(vehicle.setTypeCor(context, 'xpto'), 'Outros');
      expect(vehicle.setTypeCor(context, null), isNull);
      expect(vehicle.descriptionText(context), 'creator_vehicle Ana');
      expect(
        vehicle.copyWith(creator: ConciergeCreator(type: ConciergeCreatorType.appsindico)).descriptionText(context),
        'creator_vehicle_sindico',
      );
      expect(
        vehicle.copyWith(creator: ConciergeCreator(type: ConciergeCreatorType.portaria)).descriptionText(context),
        'creator_vehicle_concierge',
      );
      expect(Vehicle().descriptionText(context), 'creator_vehicle_concierge');
    });
  });

  test('VehicleModel e ConciergeCreator', () {
    final model = VehicleModel.fromEntity(_vehicle())!;
    final json = jsonDecode(jsonEncode(model.toJson())) as Map<String, dynamic>;
    expect(json['identification_number'], 'ABC1234');
    expect(json['concierge_creator']['type'], 'appmorar');
    final entity = VehicleModel.fromJson(json).toEntity();
    expect(entity.creator!.name, 'Ana');
    expect(entity.rentedSpace, isTrue);
    expect(VehicleModel.fromEntity(null)!.id, isNull);
    expect(ConciergeCreator.fromJson({'name': 'n', 'type': 'portaria'}).type, ConciergeCreatorType.portaria);
  });

  test('use cases', () async {
    final repo = _FakeRepository();
    expect((await DeleteVehiceleImpl(repository: repo)(DeleteVehicleParam(''))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect((await GetVehicleImpl(repository: repo)(GetVehicleParam(unityId: ''))).fold((f) => f, (_) => null),
        isA<InvalidDataOriginFailure>());
    final update = UpDateVehicleImpl(repository: repo);
    expect((await update(UpDateVehicleParam(vehicle: _vehicle(type: null)))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect((await update(UpDateVehicleParam(vehicle: _vehicle(plate: null)))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect((await update(UpDateVehicleParam(vehicle: _vehicle(color: null)))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect((await update(UpDateVehicleParam(vehicle: _vehicle(type: 'Bicicleta', plate: null)))).fold((_) => null, (l) => l.length), 1);

    await DeleteVehiceleImpl(repository: repo)(DeleteVehicleParam('v1'));
    await GetVehicleImpl(repository: repo)(GetVehicleParam(unityId: 'u1'));
    await SaveVehicleImpl(repository: repo)(SaveVehicleParam(_vehicle()));
    expect(repo.calls, ['put:v1', 'delete:v1', 'get:u1', 'post:u1']);

    // Corrigido: `validate` agora é chamado por `call` e devolve `null`
    // para o veículo válido (placa opcional apenas para bicicleta).
    final save = SaveVehicleImpl(repository: repo);
    expect(save.validate(SaveVehicleParam(_vehicle(type: null))), isA<InvalidParamFailure>());
    expect(save.validate(SaveVehicleParam(_vehicle(plate: null))), isA<InvalidParamFailure>());
    expect(save.validate(SaveVehicleParam(_vehicle(color: null))), isA<InvalidParamFailure>());
    expect(save.validate(SaveVehicleParam(_vehicle())), isNull);
    expect(save.validate(SaveVehicleParam(_vehicle(type: 'Bicicleta', plate: null))), isNull);
    expect((await save(SaveVehicleParam(_vehicle(type: null)))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect((await save(SaveVehicleParam(_vehicle(plate: null)))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect((await save(SaveVehicleParam(_vehicle(color: null)))).fold((f) => f, (_) => null),
        isA<InvalidParamFailure>());
    expect(repo.calls.where((c) => c == 'post:u1').length, 1);
  });

  group('VehicleRepositoryImpl', () {
    test('sucesso', () async {
      final repo = VehicleRepositoryImpl(remoteDataSource: _FakeDataSource());
      expect((await repo.getVehicleList('u')).fold((_) => null, (l) => l.single.id), 'u');
      expect((await repo.post(_vehicle())).fold((_) => null, (l) => l.single.model), 'Gol');
      expect((await repo.put(_vehicle(), 'v1')).fold((_) => null, (l) => l), isEmpty);
      expect((await repo.delete('v1')).fold((_) => null, (r) => r), '');
    });

    test('ApiFailure 400 vira KnownFailure', () async {
      final api400 = ApiFailure.fromJson({'status': 400, 'failure': 'placa_invalida', 'title': 't'});
      final repo = VehicleRepositoryImpl(remoteDataSource: _FakeDataSource(error: api400));
      final post = (await repo.post(_vehicle())).fold((f) => f, (_) => null) as KnownFailure;
      expect(post.code, 'placa_invalida');
      expect(post.message, 't');
      final put = (await repo.put(_vehicle(), 'v1')).fold((f) => f, (_) => null) as KnownFailure;
      expect(put.code, 'placa_invalida');

      final api500 = ApiFailure.fromJson({'status': 500});
      final repo500 = VehicleRepositoryImpl(remoteDataSource: _FakeDataSource(error: api500));
      expect((await repo500.post(_vehicle())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo500.put(_vehicle(), 'v1')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });

    test('exceções genéricas', () async {
      final repo = VehicleRepositoryImpl(remoteDataSource: _FakeDataSource(error: Exception('x')));
      expect((await repo.getVehicleList('u')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.post(_vehicle())).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.put(_vehicle(), 'v1')).fold((f) => f, (_) => null), isA<UnknownFailure>());
      expect((await repo.delete('v1')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    });
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(VehicleModel());
    final ds = VehicleRemoteDataSourceImpl(api: api);
    final list = Response<dynamic>(http.Response(jsonEncode([{'id': 'v1'}]), 200), null);
    when(() => api.getVehiclesList('u')).thenAnswer((_) async => list);
    when(() => api.post(any())).thenAnswer((_) async => list);
    when(() => api.put(any())).thenAnswer((_) async => list);
    when(() => api.delete('v1')).thenAnswer((_) async => Response<dynamic>(http.Response('', 200), null));
    when(() => api.delete('e')).thenAnswer((_) async => Response<dynamic>(http.Response('', 500), null, error: 'err'));
    expect((await ds.getVehiclesList('u'))!.single.id, 'v1');
    expect((await ds.insertVehicle(VehicleModel()))!.single.id, 'v1');
    expect((await ds.put(VehicleModel(), 'v1'))!.single.id, 'v1');
    expect(await ds.delete('v1'), '');
    expect(() => ds.delete('e'), throwsA('err'));
  });

  test('bloc', () async {
    final bloc = VehiclesBloc();
    expect(bloc.state, const VehicleIsEmptyState());
    final session = testSession();
    final states = await _collect(bloc, () async {
      bloc
        ..add(const LoadingInProgressEvent())
        ..add(const VehicleAddingFailedEvent(error: 'e', message: 'm'))
        ..add(VehicleAddSuccessEvent(vehicles: [_vehicle()]))
        ..add(const LoadingInProgressDataEvent())
        ..add(const VehicleLoadingFailedEvent(error: 'e'))
        ..add(VehicleLoadedDataEvent(vehicles: [_vehicle()], session: session))
        ..add(const VehicleLoadingUpdateInProgressEvent())
        ..add(const UpdateVehicleEvent())
        ..add(const VehicleDeleteLoadingEvent())
        ..add(const VehicleDeleteErrorEvent(error: 'e'))
        ..add(const VehicleDeleteSuccessEvent())
        ..add(const VehicleIsEmptyEvent());
    });
    await bloc.close();
    expect(states.map((s) => s.runtimeType).toList(), [
      VehicleLoadingAddInProgressState,
      VehicleAddingFailedState,
      VehicleAddedState,
      VehicleLoadingDataInProgressState,
      VehicleLoadingFailedState,
      VehicleIsLoadedDataState,
      VehicleLoadingUpdateInProgressState,
      VehicleUpdatedState,
      VehicleLoadingDeleteInProgressState,
      DeleteVehicleErrorState,
      VehicleRemovedState,
      VehicleIsEmptyState,
    ]);
    expect(const VehicleAddingFailedState('e', 'm').props, ['e', 'm']);
    expect(const VehicleAddingFailedEvent(error: 'e').props, ['e', null]);
    expect(VehicleLoadedDataEvent(vehicles: const [], session: session).props, [[], session]);
  });

  group('VehicleController', () {
    late VehiclesBloc bloc;
    setUp(() => bloc = VehiclesBloc());
    tearDown(() => bloc.close());

    VehicleController build({Failure? failure, FakeSessionBloc? session}) {
      final repo = _FakeRepository(failure: failure);
      return VehicleController(
        vehicleBloc: bloc,
        sessionBloc: session ?? FakeSessionBloc(),
        saveVehicle: SaveVehicleImpl(repository: repo),
        getVehiacle: GetVehicleImpl(repository: repo),
        deleteVehicle: DeleteVehiceleImpl(repository: repo),
        upDateVehicle: UpDateVehicleImpl(repository: repo),
      );
    }

    test('postVehicle', () async {
      fakeAnalytics.reset();
      var states = await _collect(bloc, () => build().postVehicle(_vehicle()));
      expect(states.last, isA<VehicleAddedState>());
      expect(fakeAnalytics.eventNames, contains('veiculo_acessar_adicionar_novo_veiculo_sucesso'));

      states = await _collect(bloc, () => build(failure: KnownFailure('placa', null)).postVehicle(_vehicle()));
      expect(states.last, const VehicleAddingFailedState('placa', 'placa'));
      states = await _collect(bloc, () => build(failure: UnknownFailure('x')).postVehicle(_vehicle()));
      expect(states.last, const VehicleAddingFailedState('impossible to add', null));
    });

    test('getVehicle', () async {
      var states = await _collect(bloc, build().getVehicle);
      expect(states.last, isA<VehicleIsLoadedDataState>());
      states = await _collect(bloc, build(failure: UnknownFailure('x')).getVehicle);
      expect(states.last, isA<VehicleLoadingFailedState>());
      final semUnidade = FakeSessionBloc();
      semUnidade.session.unity = Unity();
      states = await _collect(bloc, build(session: semUnidade).getVehicle);
      expect(states.last, const VehicleLoadingFailedState('not possible to load list'));
    });

    test('updateVehicle', () async {
      var states = await _collect(bloc, () => build().updateVehicle(_vehicle()));
      expect(states.last, const VehicleUpdatedState());
      states = await _collect(bloc, () => build(failure: KnownFailure('k', null)).updateVehicle(_vehicle()));
      expect(states.last, const VehicleAddingFailedState('k', 'k'));
      states = await _collect(bloc, () => build(failure: UnknownFailure('x')).updateVehicle(_vehicle()));
      expect(states.last, const VehicleAddingFailedState('impossible to update', null));
      states = await _collect(bloc, () => build().updateVehicle(_vehicle(type: null)));
      expect(states.last, const VehicleAddingFailedState('impossible to update', null));
    });

    test('excludedVehicle e restartState', () async {
      fakeAnalytics.reset();
      var states = await _collect(bloc, () => build().excludedVehicle('v1'));
      expect(states.last, const VehicleRemovedState());
      expect(fakeAnalytics.eventNames, contains('veiculo_acessar_excluir_veiculo'));
      states = await _collect(bloc, () => build(failure: UnknownFailure('x')).excludedVehicle('v1'));
      expect(states.last, const DeleteVehicleErrorState('not possible to delete'));
      states = await _collect(bloc, () async => build().restartState());
      expect(states.last, const VehicleIsEmptyState());
    });
  });
}
