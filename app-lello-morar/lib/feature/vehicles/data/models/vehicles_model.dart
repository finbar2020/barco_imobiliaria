// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/vehicles/domain/entity/vehicles.dart';

import '../../domain/entity/concierge_creator.dart';

part 'vehicles_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class VehicleModel {
  final String? id;
  final String? type;
  final String? identificationNumber;
  final String? model;
  final String? color;
  final String? unitId;
  final bool? rentedSpace;
  final String? additionalInfo;
  final ConciergeCreator? conciergeCreator;

  VehicleModel({
    this.id,
    this.type,
    this.identificationNumber,
    this.model,
    this.color,
    this.unitId,
    this.rentedSpace,
    this.additionalInfo,
    this.conciergeCreator,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleModelToJson(this);

  static VehicleModel? fromEntity(Vehicle? entity) {
    return VehicleModel(
      id: entity?.id,
      type: entity?.type,
      model: entity?.model,
      unitId: entity?.unitId,
      color: entity?.color,
      identificationNumber: entity?.identificationNumber,
      rentedSpace: entity?.rentedSpace,
      additionalInfo: entity?.additionalInfo,
      conciergeCreator: entity?.creator,
    );
  }

  Vehicle toEntity() => Vehicle(
        id: this.id,
        type: this.type,
        model: this.model,
        unitId: this.unitId,
        color: this.color,
        identificationNumber: this.identificationNumber,
        rentedSpace: this.rentedSpace,
        additionalInfo: this.additionalInfo,
        creator: this.conciergeCreator,
      );
}
