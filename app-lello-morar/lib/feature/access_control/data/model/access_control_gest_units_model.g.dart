// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_gest_units_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlGestUnitsModel _$AccessControlGestUnitsModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlGestUnitsModel(
      authorizations: (json['authorizations'] as List<dynamic>?)
              ?.map((e) => e == null
                  ? null
                  : AccessControlAuthorizationsModel.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
    )
      ..idGestUnit = json['id_gest_unit'] as String?
      ..unit = json['unit'] == null
          ? null
          : UnityModel.fromJson(json['unit'] as Map<String, dynamic>)
      ..relation = json['relation'] as String?
      ..autorizationType = json['autorization_type'] as String?
      ..observation = json['observation'] as String?;

Map<String, dynamic> _$AccessControlGestUnitsModelToJson(
        AccessControlGestUnitsModel instance) =>
    <String, dynamic>{
      'id_gest_unit': instance.idGestUnit,
      'unit': instance.unit,
      'relation': instance.relation,
      'autorization_type': instance.autorizationType,
      'observation': instance.observation,
      'authorizations': instance.authorizations,
    };
