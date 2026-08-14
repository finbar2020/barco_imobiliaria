// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'me_password_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MePasswordModel _$MePasswordModelFromJson(Map<String, dynamic> json) =>
    MePasswordModel(
      cpf: json['cpf'] as String?,
      originPassword: json['origin_password'] as String?,
      password: json['password'] as String?,
    );

Map<String, dynamic> _$MePasswordModelToJson(MePasswordModel instance) =>
    <String, dynamic>{
      'cpf': instance.cpf,
      'origin_password': instance.originPassword,
      'password': instance.password,
    };
