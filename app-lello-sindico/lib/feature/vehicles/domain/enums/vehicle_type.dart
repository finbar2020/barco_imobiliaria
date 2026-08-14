enum VehicleType { carro, moto, bicicleta, other }

extension VehicleTypeExtension on VehicleType {
  String toApi() {
    switch (this) {
      case VehicleType.carro:
        return "carro";
      case VehicleType.moto:
        return "moto";
      case VehicleType.bicicleta:
        return "bicicleta";
      case VehicleType.other:
        return "outros";
      default:
        return "carro";
    }
  }

  String toFormattedStringKey() {
    switch (this) {
      case VehicleType.carro:
        return "vehicle_type_car";
      case VehicleType.moto:
        return "vehicle_type_motorcycle";
      case VehicleType.bicicleta:
        return "vehicle_type_bicycle";
      case VehicleType.other:
        return "vehicle_type_other";
      default:
        return "vehicle_type_car";
    }
  }
}
