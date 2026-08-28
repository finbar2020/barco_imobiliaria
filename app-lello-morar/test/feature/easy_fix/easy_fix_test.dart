import 'dart:convert';

import 'package:chopper/chopper.dart' show Response;
import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_api.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_remote_data_source.dart';
import 'package:morar/feature/easy_fix/data/data_source/easy_fix_remote_data_source_impl.dart';
import 'package:morar/feature/easy_fix/data/model/city_model.dart';
import 'package:morar/feature/easy_fix/data/model/easy_fix_unit_model.dart';
import 'package:morar/feature/easy_fix/data/repository/easy_fix_repository_impl.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';
import 'package:morar/feature/easy_fix/domain/repository/easy_fix_repository.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_cities_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/get_easy_fix_unit_usecase.dart';
import 'package:morar/feature/easy_fix/domain/use_case/update_address_usecase.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_bloc.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_event.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_state.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';

import '../../helpers/firebase_mocks.dart';
import '../../helpers/fixtures.dart';

class MockApi extends Mock implements EasyFixApi {}

class _FakeDataSource extends Fake implements EasyFixRemoteDataSource {
  _FakeDataSource({this.fail = false});
  final bool fail;
  EasyFixUnitModel? updated;

  @override
  Future<EasyFixUnitModel> selectEasyFixUnit({required String condominiumId}) async {
    if (fail) throw Exception('x');
    return EasyFixUnitModel.fromEntity(EasyFixUnit.filled().copyWith(name: condominiumId));
  }

  @override
  Future<void> updateAddress({required String condominiumId, required EasyFixUnitModel model}) async {
    if (fail) throw Exception('x');
    updated = model;
  }

  @override
  Future<List<City>> selectCities({required String condominiumId, required String uf}) async {
    if (fail) throw Exception('x');
    return [City(ibgeCode: 1, name: uf)];
  }
}

class _FakeRepository extends Fake implements EasyFixRepository {
  final calls = <String>[];
  @override
  Future<Try<EasyFixUnit>> getEasyFixUnit({required String condominiumId}) async {
    calls.add('unit:$condominiumId');
    return Success(EasyFixUnit.filled());
  }

  @override
  Future<Try<void>> updateAddress({required String condominiumId, required EasyFixUnit unit}) async {
    calls.add('update:$condominiumId');
    return Success(null);
  }

  @override
  Future<Try<List<City>>> getCities({required String condominiumId, required String uf}) async {
    calls.add('cities:$condominiumId:$uf');
    return Success(const []);
  }
}

void main() {
  setUpAll(() async {
    await setUpFakeFirebase();
  });

  test('entidades', () {
    final unit = EasyFixUnit.filled();
    expect(unit, EasyFixUnit.filled());
    expect(unit.hashCode, EasyFixUnit.filled().hashCode);
    expect(unit.copyWith(name: 'n', addressCity: City(ibgeCode: 1, name: 'SP')),
        isNot(unit));
    expect(unit.copyWith().email, 'teste@gmail.com');
    expect(unit.toString(), contains('cep: 72889644'));
    expect(City(ibgeCode: 1, name: 'a'), City(ibgeCode: 1, name: 'a'));
    expect(City(ibgeCode: 1, name: 'a').hashCode, City(ibgeCode: 1, name: 'a').hashCode);
    expect(City(ibgeCode: 1, name: 'a') == City(ibgeCode: 2, name: 'a'), isFalse);
  });

  test('models', () {
    final city = CityModel.fromEntity(City(ibgeCode: 7, name: 'SP'));
    expect(city.toJson(), {'ibge_code': 7, 'name': 'SP'});
    expect(CityModel.fromJson(city.toJson()).toEntity(), City(ibgeCode: 7, name: 'SP'));

    final unit = EasyFixUnitModel.fromEntity(
        EasyFixUnit.filled().copyWith(addressCity: City(ibgeCode: 7, name: 'SP'), addressState: 'SP'));
    final json = jsonDecode(jsonEncode(unit.toJson())) as Map<String, dynamic>;
    expect(json['address_city']['name'], 'SP');
    expect(json['address_number'], '124');
    final back = EasyFixUnitModel.fromJson(json).toEntity();
    expect(back.addressCity, City(ibgeCode: 7, name: 'SP'));
    expect(back.addressState, 'SP');
    expect(EasyFixUnitModel.fromEntity(EasyFixUnit.filled()).addressCity, isNull);
  });

  test('use cases delegam', () async {
    final repo = _FakeRepository();
    await GetEasyFixUnitUsecase(repository: repo)(GetEasyFixUnitParam(condominiumId: 'c'));
    await UpdateAddressUsecase(repository: repo)(
        UpdateAddressParams(condominiumId: 'c', unit: EasyFixUnit.filled()));
    await GetCitiesUsecase(repository: repo)(GetCitiesParams(condominiumId: 'c', uf: 'SP'));
    expect(repo.calls, ['unit:c', 'update:c', 'cities:c:SP']);
  });

  test('repository', () async {
    final ds = _FakeDataSource();
    final repo = EasyFixRepositoryImpl(datasource: ds);
    expect((await repo.getEasyFixUnit(condominiumId: 'c')).fold((_) => null, (u) => u.name), 'c');
    expect((await repo.updateAddress(condominiumId: 'c', unit: EasyFixUnit.filled()))
        .fold((_) => 'erro', (_) => 'ok'), 'ok');
    expect(ds.updated!.cep, '72889644');
    expect((await repo.getCities(condominiumId: 'c', uf: 'RJ')).fold((_) => null, (l) => l.single.name), 'RJ');

    final bad = EasyFixRepositoryImpl(datasource: _FakeDataSource(fail: true));
    expect((await bad.getEasyFixUnit(condominiumId: 'c')).fold((f) => f, (_) => null), isA<UnknownFailure>());
    expect((await bad.updateAddress(condominiumId: 'c', unit: EasyFixUnit.filled())).fold((f) => f, (_) => null),
        isA<UnknownFailure>());
    expect((await bad.getCities(condominiumId: 'c', uf: 'RJ')).fold((f) => f, (_) => null), isA<UnknownFailure>());
  });

  test('data source', () async {
    final api = MockApi();
    registerFallbackValue(EasyFixUnitModel.fromEntity(EasyFixUnit.filled()));
    final ds = EasyFixRemoteDataSourceImpl(api: api);
    when(() => api.getEasyFixUnit('c')).thenAnswer(
      (_) async => Response<dynamic>(
        http.Response(jsonEncode(EasyFixUnitModel.fromEntity(EasyFixUnit.filled()).toJson()), 200),
        null,
      ),
    );
    when(() => api.updateAddress('c', any())).thenAnswer(
      (_) async => Response<dynamic>(http.Response('{}', 200), null),
    );
    when(() => api.getCities('c', 'SP')).thenAnswer(
      (_) async => Response<dynamic>(http.Response(jsonEncode([{'ibge_code': 1, 'name': 'SP'}]), 200), null),
    );
    expect((await ds.selectEasyFixUnit(condominiumId: 'c')).address, 'Avenida Nida');
    await ds.updateAddress(condominiumId: 'c', model: EasyFixUnitModel.fromEntity(EasyFixUnit.filled()));
    expect((await ds.selectCities(condominiumId: 'c', uf: 'SP')).single, City(ibgeCode: 1, name: 'SP'));
  });

  test('bloc', () async {
    final bloc = ChangeAddressBloc();
    expect(bloc.state, const ChangeAddressInitialState());
    final states = <dynamic>[];
    final sub = bloc.stream.listen(states.add);
    bloc
      ..add(const ChangeAddressLoadingEvent())
      ..add(ChangeAddressLoadedEvent(unit: EasyFixUnit.filled()))
      ..add(ChangeAddressFailureEvent(failure: UnknownFailure('e')))
      ..add(const ChangeAddressSuccessEvent())
      ..add(const ChangeAddressEmptyEvent());
    await Future<void>.delayed(Duration.zero);
    await sub.cancel();
    await bloc.close();
    expect(states, [
      const ChangeAddressLoadingState(),
      ChangeAddressLoadedState(unit: EasyFixUnit.filled()),
      ChangeAddressFailureState(failure: UnknownFailure('e')),
      const ChangeAddressSuccessState(),
      const ChangeAddressInitialState(),
    ]);
    expect(ChangeAddressLoadedEvent(unit: EasyFixUnit.filled()).props.single, EasyFixUnit.filled());
  });

  group('ChangeAddressController', () {
    late ChangeAddressBloc bloc;
    late ChangeAddressController controller;

    setUp(() {
      bloc = ChangeAddressBloc();
      final repo = _FakeRepository();
      controller = ChangeAddressController(
        getCitiesUsecase: GetCitiesUsecase(repository: repo),
        getEasyFixUnitUsecase: GetEasyFixUnitUsecase(repository: repo),
        updateAddressUsecase: UpdateAddressUsecase(repository: repo),
        bloc: bloc,
        sessionBloc: FakeSessionBloc(),
      );
    });

    tearDown(() => bloc.close());

    test('setFields e updatedUnit', () {
      final unit = EasyFixUnit.filled().copyWith(
        addressState: 'SP',
        addressComplement: 'apto 1',
        addressCity: City(ibgeCode: 1, name: 'SP'),
        cellphone: '(11) 99822-2044',
      );
      controller.unit = unit;
      controller.setFields(unit);
      expect(controller.addressController.text, 'Avenida Nida');
      expect(controller.addressStateController.text, 'SP');
      expect(controller.addressComplementController.text, 'apto 1');
      controller.addressNumberController.text = '999';
      final updated = controller.updatedUnit;
      expect(updated.addressNumber, '999');
      expect(updated.cellphone, '11998222044');
      expect(updated.addressCity, City(ibgeCode: 1, name: 'SP'));
      expect(controller.session.condominium!.id, 'c1');
    });

    test('getEasyFixUnit com estado busca as cidades', () async {
      final states = <dynamic>[];
      final sub = bloc.stream.listen(states.add);
      final unit = await controller.getEasyFixUnit(condominiumId: 'c');
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();
      expect(unit, EasyFixUnit.filled());
      expect(states.last, isA<ChangeAddressLoadedState>());
      expect(controller.cities, isEmpty);
    });

    testWidgets('getStates lê o json de estados', (tester) async {
      final states = await controller.getStates();
      expect(states, contains('SP'));
      expect(states.length, greaterThan(20));
    });
  });
}
