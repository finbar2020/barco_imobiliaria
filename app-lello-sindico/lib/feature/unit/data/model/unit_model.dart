// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:lello/feature/vehicles/data/model/vehicle_model.dart';

part 'unit_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitModel {
  final String? id;
  final String? title;
  final String? condominiumId;
  final String? group;
  final int? residentCount;
  final int? vehicleCount;
  final bool? adimplente;
  final bool? agreement;
  final String? billingStatus;
  final bool? usesApp;
  final String? fixedPhone;
  final String? mobilePhone;
  final DateTime? lastUpdated;
  final List<VehicleModel>? vehicles;

  UnitModel({
    this.id,
    this.title,
    this.condominiumId,
    this.group,
    this.residentCount,
    this.vehicleCount,
    this.adimplente,
    this.agreement,
    this.billingStatus,
    this.usesApp,
    this.fixedPhone,
    this.mobilePhone,
    this.lastUpdated,
    this.vehicles,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnitModelToJson(this);

  factory UnitModel.fromEntity(Unit? entity) {
    return UnitModel(
      id: entity?.id,
      adimplente: entity?.adimplente,
      title: entity?.title,
      agreement: entity?.agreement,
      group: entity?.group,
      condominiumId: entity?.condominiumId,
      residentCount: entity?.residentCount,
      vehicleCount: entity?.vehicleCount,
      billingStatus: entity?.billingStatus,
      usesApp: entity?.usesApp,
      fixedPhone: entity?.fixedPhone,
      mobilePhone: entity?.mobilePhone,
      lastUpdated: entity?.lastUpdated,
      vehicles:
          entity?.vehicles?.map((e) => VehicleModel.fromEntity(e)).toList(),
    );
  }

  Unit toEntity() {
    return Unit(
      adimplente: adimplente,
      agreement: agreement,
      billingStatus: billingStatus,
      condominiumId: condominiumId,
      fixedPhone: fixedPhone,
      group: group,
      id: id,
      lastUpdated: lastUpdated,
      mobilePhone: mobilePhone,
      residentCount: residentCount,
      title: title,
      usesApp: usesApp,
      vehicleCount: vehicleCount,
      vehicles: vehicles?.map((e) => e.toEntity()).toList(),
    );
  }

  UnitModel copyWith({
    String? id,
    String? title,
    String? condominiumId,
    String? group,
    int? residentCount,
    int? vehicleCount,
    bool? adimplente,
    bool? agreement,
    String? billingStatus,
    bool? usesApp,
    String? fixedPhone,
    String? mobilePhone,
    DateTime? lastUpdated,
    List<VehicleModel>? vehicles,
  }) {
    return UnitModel(
      id: id ?? this.id,
      title: title ?? this.title,
      condominiumId: condominiumId ?? this.condominiumId,
      group: group ?? this.group,
      residentCount: residentCount ?? this.residentCount,
      vehicleCount: vehicleCount ?? this.vehicleCount,
      adimplente: adimplente ?? this.adimplente,
      agreement: agreement ?? this.agreement,
      billingStatus: billingStatus ?? this.billingStatus,
      usesApp: usesApp ?? this.usesApp,
      fixedPhone: fixedPhone ?? this.fixedPhone,
      mobilePhone: mobilePhone ?? this.mobilePhone,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      vehicles: vehicles ?? this.vehicles,
    );
  }
}
