// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicles_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleModel _$VehicleModelFromJson(Map<String, dynamic> json) => VehicleModel(
      id: json['id'] as String?,
      type: json['type'] as String?,
      identificationNumber: json['identification_number'] as String?,
      model: json['model'] as String?,
      color: json['color'] as String?,
      unitId: json['unit_id'] as String?,
      rentedSpace: json['rented_space'] as bool?,
      additionalInfo: json['additional_info'] as String?,
      conciergeCreator: json['concierge_creator'] == null
          ? null
          : ConciergeCreator.fromJson(
              json['concierge_creator'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$VehicleModelToJson(VehicleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'identification_number': instance.identificationNumber,
      'model': instance.model,
      'color': instance.color,
      'unit_id': instance.unitId,
      'rented_space': instance.rentedSpace,
      'additional_info': instance.additionalInfo,
      'concierge_creator': instance.conciergeCreator,
    };
