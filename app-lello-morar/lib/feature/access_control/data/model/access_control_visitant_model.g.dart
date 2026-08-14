// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_visitant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlVisitantModel _$AccessControlVisitantModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlVisitantModel(
      idGestUnit: json['id_gest_unit'] as String?,
      autorizarionType: (json['autorizarion_type'] as num?)?.toInt(),
      observation: json['observation'] as String?,
      gest: json['gest'] == null
          ? null
          : AccessControlModel.fromJson(json['gest'] as Map<String, dynamic>),
      units: (json['units'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : UnityModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$AccessControlVisitantModelToJson(
        AccessControlVisitantModel instance) =>
    <String, dynamic>{
      'id_gest_unit': instance.idGestUnit,
      'autorizarion_type': instance.autorizarionType,
      'observation': instance.observation,
      'gest': instance.gest,
      'units': instance.units,
    };
