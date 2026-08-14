// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_grouped_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityGroupedModel _$AccountabilityGroupedModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityGroupedModel(
      type: json['type'] as String,
      description: json['description'] as String,
      id: (json['id'] as num).toInt(),
      debits: (json['debits'] as num).toDouble(),
      credits: (json['credits'] as num).toDouble(),
      accounts: (json['accounts'] as List<dynamic>)
          .map((e) => AccountabilityGroupedAccaountModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountabilityGroupedModelToJson(
        AccountabilityGroupedModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'id': instance.id,
      'debits': instance.debits,
      'credits': instance.credits,
      'accounts': instance.accounts,
    };
