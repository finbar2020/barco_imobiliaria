// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_management_send_invite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessManagementSendInviteModel _$AccessManagementSendInviteModelFromJson(
        Map<String, dynamic> json) =>
    AccessManagementSendInviteModel()
      ..cpf = json['cpf'] as String?
      ..name = json['name'] as String?
      ..phone = json['phone'] as String?
      ..email = json['email'] as String?
      ..userType = json['user_type'] as String?
      ..forwardType = json['forward_type'] as String?;

Map<String, dynamic> _$AccessManagementSendInviteModelToJson(
        AccessManagementSendInviteModel instance) =>
    <String, dynamic>{
      'cpf': instance.cpf,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'user_type': instance.userType,
      'forward_type': instance.forwardType,
    };
