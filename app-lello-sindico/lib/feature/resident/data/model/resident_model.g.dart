// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resident_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ResidentModel _$ResidentModelFromJson(Map<String, dynamic> json) =>
    ResidentModel(
      id: json['id'] as String?,
      typeAccess: json['type_access'] as String?,
      name: json['name'] as String?,
      cpf: json['cpf'] as String?,
      email: json['email'] as String?,
      accessControlBiometricStatus:
          json['access_control_biometric_status'] as String?,
      fixedPhone: json['fixed_phone'] as String?,
      mobilePhone: json['mobile_phone'] as String?,
      useApp: json['use_app'] as bool?,
      unit: json['unit'] == null
          ? null
          : UnitModel.fromJson(json['unit'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ResidentModelToJson(ResidentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type_access': instance.typeAccess,
      'name': instance.name,
      'cpf': instance.cpf,
      'email': instance.email,
      'access_control_biometric_status': instance.accessControlBiometricStatus,
      'fixed_phone': instance.fixedPhone,
      'mobile_phone': instance.mobilePhone,
      'use_app': instance.useApp,
      'unit': instance.unit,
    };
