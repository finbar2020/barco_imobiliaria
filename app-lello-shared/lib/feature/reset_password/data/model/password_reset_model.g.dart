// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_reset_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PasswordResetModel _$PasswordResetModelFromJson(Map<String, dynamic> json) =>
    PasswordResetModel()
      ..password = json['password'] as String?
      ..cpf = json['cpf'] as String?
      ..token = json['token'] as String?;

Map<String, dynamic> _$PasswordResetModelToJson(PasswordResetModel instance) =>
    <String, dynamic>{
      'password': instance.password,
      'cpf': instance.cpf,
      'token': instance.token,
    };
