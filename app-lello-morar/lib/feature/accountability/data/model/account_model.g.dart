// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel()
  ..id = json['id'] as String?
  ..number = json['number'] as String?
  ..name = json['name'] as String?
  ..condominiumId = json['condominium_id'] as String?;

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'name': instance.name,
      'condominium_id': instance.condominiumId,
    };
