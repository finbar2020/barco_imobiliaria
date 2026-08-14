// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_control_send_invite_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessControlSendInviteModel _$AccessControlSendInviteModelFromJson(
        Map<String, dynamic> json) =>
    AccessControlSendInviteModel()
      ..cpf = json['cpf'] as String?
      ..name = json['name'] as String?
      ..phone = json['phone'] as String?
      ..userType = json['user_type'] as String?
      ..forwardType = json['forward_type'] as String?
      ..foreignDocument = json['foreign_document'] as String?
      ..foreignDocumentType = json['foreign_document_type'] as String?;

Map<String, dynamic> _$AccessControlSendInviteModelToJson(
        AccessControlSendInviteModel instance) =>
    <String, dynamic>{
      'cpf': instance.cpf,
      'name': instance.name,
      'phone': instance.phone,
      'user_type': instance.userType,
      'forward_type': instance.forwardType,
      'foreign_document': instance.foreignDocument,
      'foreign_document_type': instance.foreignDocumentType,
    };
