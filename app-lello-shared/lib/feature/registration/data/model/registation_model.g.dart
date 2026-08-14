// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationModel _$RegistrationModelFromJson(Map<String, dynamic> json) =>
    RegistrationModel(
      name: json['name'] as String?,
      cpf: json['cpf'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      password: json['password'] as String?,
      token: json['token'] as String?,
      termsAndConditionsCheck: json['terms_and_conditions_check'] as bool?,
    );

Map<String, dynamic> _$RegistrationModelToJson(RegistrationModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cpf': instance.cpf,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'token': instance.token,
      'terms_and_conditions_check': instance.termsAndConditionsCheck,
    };
