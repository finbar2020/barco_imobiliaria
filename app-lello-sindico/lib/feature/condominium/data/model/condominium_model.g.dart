// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CondominiumModel _$CondominiumModelFromJson(Map<String, dynamic> json) =>
    CondominiumModel(
      id: json['id'] as String,
      name: json['name'] as String?,
      number: json['number'] as String?,
      address: json['address'] as String?,
      regulationUrl: json['regulation_url'] as String?,
      reference: json['reference'] as String,
      useFacialBiometric: json['use_facial_biometric'] as bool? ?? false,
      managerAccessControlBiometricStatus:
          json['manager_access_control_biometric_status'] as String? ??
              "unavaliable",
      layout: json['layout'] == null
          ? null
          : LayoutModel.fromJson(json['layout'] as Map<String, dynamic>),
      notificationContext: json['notification_context'] as String?,
    );

Map<String, dynamic> _$CondominiumModelToJson(CondominiumModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'number': instance.number,
      'address': instance.address,
      'regulation_url': instance.regulationUrl,
      'reference': instance.reference,
      'use_facial_biometric': instance.useFacialBiometric,
      'manager_access_control_biometric_status':
          instance.managerAccessControlBiometricStatus,
      'layout': instance.layout,
      'notification_context': instance.notificationContext,
    };
