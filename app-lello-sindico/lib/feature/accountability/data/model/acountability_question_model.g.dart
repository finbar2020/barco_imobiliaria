// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityQuestionTypeModel _$AccountabilityQuestionTypeModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityQuestionTypeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      idCompany: (json['id_company'] as num?)?.toInt() ?? 0,
      idSupervisor: (json['id_supervisor'] as num?)?.toInt() ?? 0,
      idRequestPpc: (json['id_request_ppc'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AccountabilityQuestionTypeModelToJson(
        AccountabilityQuestionTypeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'id_company': instance.idCompany,
      'id_supervisor': instance.idSupervisor,
      'id_request_ppc': instance.idRequestPpc,
    };
