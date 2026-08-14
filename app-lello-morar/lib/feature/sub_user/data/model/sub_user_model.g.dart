// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubUserModel _$SubUserModelFromJson(Map<String, dynamic> json) => SubUserModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      cpf: json['cpf'] as String?,
      expiresAt: json['expires_at'] == null
          ? null
          : DateTime.parse(json['expires_at'] as String),
      role: json['role'] as String?,
      roleDescription: json['role_description'] as String?,
      accessRenewalRequestDate: json['access_renewal_request_date'] == null
          ? null
          : DateTime.parse(json['access_renewal_request_date'] as String),
      blocked: json['blocked'] as bool?,
      useApp: json['use_app'] as bool?,
      mainUser: json['main_user'] as bool?,
      unitId: json['unit_id'] as String?,
      registered: json['registered'] as bool?,
      notificationParameter: json['notification_parameter'] as String?,
      useFacialBiometric: json['use_facial_biometric'] as bool?,
      accessRenewalRequestStatus:
          json['access_renewal_request_status'] as String?,
      picture: json['picture'] as String?,
      creator: json['creator'] == null
          ? null
          : ConciergeCreator.fromJson(json['creator'] as Map<String, dynamic>),
      flagBoletoEmail: json['flag_boleto_email'] as bool?,
    );

Map<String, dynamic> _$SubUserModelToJson(SubUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'expires_at': instance.expiresAt?.toIso8601String(),
      'access_renewal_request_date':
          instance.accessRenewalRequestDate?.toIso8601String(),
      'cpf': instance.cpf,
      'role': instance.role,
      'role_description': instance.roleDescription,
      'blocked': instance.blocked,
      'use_app': instance.useApp,
      'main_user': instance.mainUser,
      'unit_id': instance.unitId,
      'registered': instance.registered,
      'flag_boleto_email': instance.flagBoletoEmail,
      'notification_parameter': instance.notificationParameter,
      'access_renewal_request_status': instance.accessRenewalRequestStatus,
      'use_facial_biometric': instance.useFacialBiometric,
      'picture': instance.picture,
      'creator': instance.creator,
    };
