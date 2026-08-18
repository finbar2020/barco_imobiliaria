import 'package:essentials/essentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vehicles/data/datasource/vehicle_datasource.dart';
import 'package:lello/feature/vehicles/data/model/vehicle_model.dart';
import 'package:lello/feature/vehicles/data/repository/vehicle_repository.dart';
import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';
import 'package:lello/feature/vehicles/domain/enums/vehicle_type.dart';
import 'package:lello/feature/vehicles/domain/repository/i_vehicle_repository.dart';
import 'package:lello/feature/vehicles/domain/usecases/get_vehicles_usecase.dart';

class _FakeVehicleRepo extends Fake implements VehicleRepository {
  Object? last;

  @override
  Future<Try<List<Vehicle>>> list(
    String condominiumId,
    String unitId, {
    String? query,
    bool? loadAll,
  }) async {
    last = '$condominiumId|$unitId|$query|$loadAll';
    return Success([
      Vehicle(
        id: 'v1',
        type: 'carro',
        identificationNumber: 'ABC1D23',
        model: 'Onix',
        color: 'Prata',
        idUnity: unitId,
        rentedSpace: false,
      ),
    ]);
  }
}

class _FakeVehicleDataSource extends Fake implements VehicleRemoteDataSource {
  @override
  Future<List<VehicleModel>> list(
    String condominiumId,
    String unitId, {
    String? query,
    bool? loadAll,
  }) async {
    return [
      VehicleModel(
        id: 'v2',
        type: 'moto',
        identificationNumber: 'XYZ9A87',
        model: 'CG 160',
        color: 'Preta',
        unitId: unitId,
        rentedSpace: true,
      ),
    ];
  }
}

void main() {
  test('lista veículos do condomínio e da unidade', () async {
    final repo = _FakeVehicleRepo();
    final result = await GetVehiclesUsecase(repository: repo).call(
      ParamsGetVehiclesUsecase(condominiumId: 'c1', unitId: 'u1', query: 'onix'),
    );
    expect(result is Success<List<Vehicle>>, isTrue);
    expect((result as Success<List<Vehicle>>).get().single.model, 'Onix');
    expect(repo.last, 'c1|u1|onix|null');
  });

  test('rejeita condomínio vazio', () async {
    final result = await GetVehiclesUsecase(repository: _FakeVehicleRepo())
        .call(ParamsGetVehiclesUsecase(condominiumId: '', unitId: 'u1'));
    expect(result is Rejection, isTrue);
  });

  test('repositório mapeia model para entidade', () async {
    final result = await VehicleRepositoryImpl(
      remoteDataSource: _FakeVehicleDataSource(),
    ).list('c1', 'u9');
    expect(result is Success<List<Vehicle>>, isTrue);
    final vehicle = (result as Success<List<Vehicle>>).get().single;
    expect(vehicle.id, 'v2');
    expect(vehicle.idUnity, 'u9');
    expect(vehicle.rentedSpace, isTrue);
  });

  test('tipos de veículo expõem chave de API e de tradução', () {
    expect(VehicleType.carro.toApi(), 'carro');
    expect(VehicleType.moto.toApi(), 'moto');
    expect(VehicleType.bicicleta.toApi(), 'bicicleta');
    expect(VehicleType.other.toApi(), 'outros');
    expect(VehicleType.carro.toFormattedStringKey(), 'vehicle_type_car');
    expect(VehicleType.other.toFormattedStringKey(), 'vehicle_type_other');
  });
}
