// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreements_rules_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AgreementsRulesModel _$AgreementsRulesModelFromJson(
        Map<String, dynamic> json) =>
    AgreementsRulesModel(
      installmentQtd: (json['installment_qtd'] as num).toInt(),
      days: (json['days'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AgreementsRulesModelToJson(
        AgreementsRulesModel instance) =>
    <String, dynamic>{
      'installment_qtd': instance.installmentQtd,
      'days': instance.days,
    };
