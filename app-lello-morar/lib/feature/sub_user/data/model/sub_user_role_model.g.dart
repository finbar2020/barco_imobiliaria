// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_user_role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubUserRoleModel _$SubUserRoleModelFromJson(Map<String, dynamic> json) =>
    SubUserRoleModel()
      ..role = json['role'] as String?
      ..description = json['description'] as String?
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$SubUserRoleModelToJson(SubUserRoleModel instance) =>
    <String, dynamic>{
      'role': instance.role,
      'description': instance.description,
      'enabled': instance.enabled,
    };
