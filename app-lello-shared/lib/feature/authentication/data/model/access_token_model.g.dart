// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessTokenModel _$AccessTokenModelFromJson(Map<String, dynamic> json) =>
    AccessTokenModel()
      ..accessToken = json['access_token'] as String?
      ..refreshToken = json['refresh_token'] as String?
      ..firebaseToken = json['firebase_token'] as String?
      ..userId = json['user_id'] as String?
      ..expiresIn = (json['expires_in'] as num?)?.toInt()
      ..roles = (json['roles'] as List<dynamic>?)
          ?.map((e) => RoleModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..selectedRole = json['selected_role'] as String?
      ..selectedRolePermissions =
          (json['selected_role_permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList()
      ..customRolePermissions =
          (json['custom_role_permissions'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList();

Map<String, dynamic> _$AccessTokenModelToJson(AccessTokenModel instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'refresh_token': instance.refreshToken,
      'firebase_token': instance.firebaseToken,
      'user_id': instance.userId,
      'expires_in': instance.expiresIn,
      'roles': instance.roles,
      'selected_role': instance.selectedRole,
      'selected_role_permissions': instance.selectedRolePermissions,
      'custom_role_permissions': instance.customRolePermissions,
    };
