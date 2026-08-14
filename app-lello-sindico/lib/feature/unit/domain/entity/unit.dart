import 'package:lello/feature/vehicles/domain/entities/vehicle_entity.dart';

import 'unit_simple.dart';

class Unit {
  String? id;
  String? title;
  String? condominiumId;
  String? group;
  int? residentCount;
  int? vehicleCount;
  bool? adimplente;
  bool? agreement;
  String? billingStatus;
  bool? usesApp;
  String? fixedPhone;
  String? mobilePhone;
  DateTime? lastUpdated;
  List<Vehicle>? vehicles;

  Unit({
    this.id,
    this.title,
    this.adimplente,
    this.group,
    this.agreement,
    this.residentCount,
    this.vehicleCount,
    this.condominiumId,
    this.billingStatus,
    this.usesApp,
    this.fixedPhone,
    this.mobilePhone,
    this.lastUpdated,
    this.vehicles,
  });

  factory Unit.fromUnitSimple(UnitSimple unitSimple) {
    return Unit(
      id: unitSimple.id,
      title: unitSimple.title,
    );
  }
}
