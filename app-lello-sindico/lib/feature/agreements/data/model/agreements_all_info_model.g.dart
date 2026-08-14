// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_all_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsAllInfoModel _$AgreementsAllInfoModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsAllInfoModel(
      agreements: (json['agreements'] as List<dynamic>)
          .map((e) => AgreementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rule: AgreementsRulesModel.fromJson(json['rule'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AgreementsAllInfoModelToJson(
        AgreementsAllInfoModel instance) =>
    <String, dynamic>{
      'agreements': instance.agreements,
      'rule': instance.rule,
    };
