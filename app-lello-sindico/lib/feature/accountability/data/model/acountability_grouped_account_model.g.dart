// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_grouped_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityGroupedAccaountModel _$AccountabilityGroupedAccaountModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityGroupedAccaountModel(
      account: (json['account'] as num).toInt(),
      description: json['description'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => AccountabilityGroupedAccaountEntrieModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountabilityGroupedAccaountModelToJson(
        AccountabilityGroupedAccaountModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'description': instance.description,
      'entries': instance.entries,
    };
