// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_lello_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationLelloUserModel _$RegistrationLelloUserModelFromJson(
        Map<String, dynamic> json) =>
    RegistrationLelloUserModel()
      ..name = json['name'] as String?
      ..cpf = json['cpf'] as String?
      ..emails =
          (json['emails'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..phones =
          (json['phones'] as List<dynamic>?)?.map((e) => e as String?).toList()
      ..registered = json['registered'] as bool?
      ..contexts = (json['contexts'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList();

Map<String, dynamic> _$RegistrationLelloUserModelToJson(
        RegistrationLelloUserModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'cpf': instance.cpf,
      'emails': instance.emails,
      'phones': instance.phones,
      'registered': instance.registered,
      'contexts': instance.contexts,
    };
