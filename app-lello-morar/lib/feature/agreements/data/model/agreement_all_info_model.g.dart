// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_all_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementAllInfoModel _$AgreementAllInfoModelFromJson(
        Map<String, dynamic> json) =>
    AgreementAllInfoModel(
      quotes: (json['quotes'] as List<dynamic>)
          .map((e) => AgreementQuotaModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      agreements: (json['agreements'] as List<dynamic>)
          .map((e) => AgreementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rule: AgreementRuleModel.fromJson(json['rule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreementAllInfoModelToJson(
        AgreementAllInfoModel instance) =>
    <String, dynamic>{
      'quotes': instance.quotes,
      'agreements': instance.agreements,
      'rule': instance.rule,
    };
