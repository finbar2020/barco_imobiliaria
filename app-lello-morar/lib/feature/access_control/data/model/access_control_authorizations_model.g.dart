// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_authorizations_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlAuthorizationsModel _$AccessControlAuthorizationsModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlAuthorizationsModel(
      id: json['id'] as String?,
      idUnit: json['id_unit'] as String?,
      idGest: json['id_gest'] as String?,
      start: json['start'] as String?,
      end: json['end'] as String?,
      recurrence: json['recurrence'] == null
          ? null
          : AccessControlRecurrenceModel.fromJson(
              json['recurrence'] as Map<String, dynamic>),
      idConcierge: json['id_concierge'] as String?,
      autorizationType: json['autorization_type'] as String?,
      useFacialBiometric: json['use_facial_biometric'] as bool?,
    );

Map<String, dynamic> _$AccessControlAuthorizationsModelToJson(
        AccessControlAuthorizationsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'id_unit': instance.idUnit,
      'id_gest': instance.idGest,
      'id_concierge': instance.idConcierge,
      'start': instance.start,
      'end': instance.end,
      'recurrence': instance.recurrence,
      'autorization_type': instance.autorizationType,
      'use_facial_biometric': instance.useFacialBiometric,
    };
