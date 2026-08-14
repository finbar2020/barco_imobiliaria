// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'condominium_balance_detail_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummaryModel _$SummaryModelFromJson(Map<String, dynamic> json) => SummaryModel()
  ..name = json['name'] as String?
  ..debits = (json['debits'] as num?)?.toDouble()
  ..credits = (json['credits'] as num?)?.toDouble();

Map<String, dynamic> _$SummaryModelToJson(SummaryModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'debits': instance.debits,
      'credits': instance.credits,
    };
