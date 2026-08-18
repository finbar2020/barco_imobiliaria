import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/vehicles/data/model/vehicle_model.dart';
import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

void main() {
  test('fromJson e toJson preservam a placa e a unidade', () {
    final model = VehicleModel.fromJson({
      'id': 'v1',
      'type': 'carro',
      'identification_number': 'ABC1D23',
      'model': 'Onix',
      'color': 'Prata',
      'unit_id': 'u1',
      'rented_space': false,
    });
    expect(model.toJson()['identification_number'], 'ABC1D23');
    expect(model.toEntity().idUnity, 'u1');
  });

  test('fromEntity espelha os campos da entidade', () {
    final model = VehicleModel.fromEntity(
      Vehicle(
        id: 'v3',
        type: 'moto',
        identificationNumber: 'XYZ',
        model: 'CG',
        color: 'Vermelha',
        idUnity: 'u8',
        rentedSpace: true,
      ),
    );
    expect(model.unitId, 'u8');
    expect(model.rentedSpace, isTrue);
  });
}
