// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/vehicle_entity.dart';

part 'vehicle_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VehicleModel {
  final String id;
  final String type;
  final String? identificationNumber;
  final String? model;
  final String? color;
  final String unitId;
  final bool rentedSpace;

  VehicleModel({
    required this.id,
    required this.type,
    this.identificationNumber,
    this.model,
    this.color,
    required this.unitId,
    required this.rentedSpace,
  });

  Vehicle toEntity() {
    return Vehicle(
      id: id,
      type: type,
      identificationNumber: identificationNumber,
      model: model,
      color: color,
      idUnity: unitId,
      rentedSpace: rentedSpace,
    );
  }

  factory VehicleModel.fromEntity(Vehicle vehicle) {
    return VehicleModel(
      id: vehicle.id,
      type: vehicle.type,
      identificationNumber: vehicle.identificationNumber,
      model: vehicle.model,
      color: vehicle.color,
      unitId: vehicle.idUnity,
      rentedSpace: vehicle.rentedSpace,
    );
  }

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);
  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);
}
