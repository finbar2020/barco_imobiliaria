// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_grouped_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityGroupedAccountModel _$AccountabilityGroupedAccountModelFromJson(
        Map<String, dynamic> json) =>
    AccountabilityGroupedAccountModel(
      account: (json['account'] as num).toInt(),
      description: json['description'] as String,
      entries: (json['entries'] as List<dynamic>)
          .map((e) => AccountabilityGroupedAccountEntrieModel.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccountabilityGroupedAccountModelToJson(
        AccountabilityGroupedAccountModel instance) =>
    <String, dynamic>{
      'account': instance.account,
      'description': instance.description,
      'entries': instance.entries,
    };
