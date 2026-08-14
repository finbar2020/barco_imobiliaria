// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceRuleModel _$InsuranceRuleModelFromJson(Map<String, dynamic> json) =>
    InsuranceRuleModel(
      name: json['name'] as String?,
      cost: (json['cost'] as num?)?.toDouble(),
    )
      ..id = json['id'] as String?
      ..description = json['description'] as String?
      ..linkTerms = json['link_terms'] as String?;

Map<String, dynamic> _$InsuranceRuleModelToJson(InsuranceRuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'cost': instance.cost,
      'link_terms': instance.linkTerms,
    };
