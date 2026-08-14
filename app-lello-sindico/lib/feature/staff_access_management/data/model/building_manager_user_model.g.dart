// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_manager_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BuildingManagerUserModel _$BuildingManagerUserModelFromJson(
        Map<String, dynamic> json) =>
    BuildingManagerUserModel(
      id: json['id'] as String? ?? "",
      name: json['name'] as String? ?? "",
      email: json['email'] as String? ?? "",
      phone: json['phone'] as String? ?? "",
      cpf: json['cpf'] as String? ?? "",
      accessType: $enumDecodeNullable(_$AccessTypeEnumMap, json['access_type']),
      reference: json['reference'] as String?,
      isActive: json['is_active'] as bool? ?? false,
      isRegistered: json['is_registered'] as bool? ?? false,
      usesFacialBiometrics: json['uses_facial_biometrics'] as bool? ?? false,
      hasAppUsage: json['has_app_usage'] as bool? ?? false,
      creatorUserId: json['creator_user_id'] as String?,
      gender: json['gender'] as String?,
      birthday: json['birthday'] as String?,
    );

Map<String, dynamic> _$BuildingManagerUserModelToJson(
        BuildingManagerUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'cpf': instance.cpf,
      'access_type': _$AccessTypeEnumMap[instance.accessType],
      'reference': instance.reference,
      'is_active': instance.isActive,
      'is_registered': instance.isRegistered,
      'uses_facial_biometrics': instance.usesFacialBiometrics,
      'has_app_usage': instance.hasAppUsage,
      'creator_user_id': instance.creatorUserId,
      'gender': instance.gender,
      'birthday': instance.birthday,
    };

const _$AccessTypeEnumMap = {
  AccessType.fullCondoPresident: 'fullCondoPresident',
  AccessType.fullCondoCouncilMember: 'fullCondoCouncilMember',
  AccessType.fullCondoRepresentative: 'fullCondoRepresentative',
  AccessType.fullBuildingManager: 'fullBuildingManager',
  AccessType.restrictedBuildingManager: 'restrictedBuildingManager',
  AccessType.fullJanitor: 'fullJanitor',
  AccessType.restrictedJanitor: 'restrictedJanitor',
  AccessType.fullJanitorGdp: 'fullJanitorGdp',
};
