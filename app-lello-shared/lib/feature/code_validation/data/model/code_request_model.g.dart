// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeRequestModel _$CodeRequestModelFromJson(Map<String, dynamic> json) =>
    CodeRequestModel()
      ..id = json['id'] as String?
      ..source = json['source'] as String?
      ..origin = json['origin'] as String?
      ..value = json['value'] as String?
      ..token = json['token'] as String?
      ..cpf = json['cpf'] as String?
      ..appSignature = json['app_signature'] as String?;

Map<String, dynamic> _$CodeRequestModelToJson(CodeRequestModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'origin': instance.origin,
      'value': instance.value,
      'token': instance.token,
      'cpf': instance.cpf,
      'app_signature': instance.appSignature,
    };
