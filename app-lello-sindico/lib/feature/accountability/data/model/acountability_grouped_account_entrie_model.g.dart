// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acountability_grouped_account_entrie_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountabilityGroupedAccaountEntrieModel
    _$AccountabilityGroupedAccaountEntrieModelFromJson(
            Map<String, dynamic> json) =>
        AccountabilityGroupedAccaountEntrieModel(
          id: (json['id'] as num).toInt(),
          date: DateTime.parse(json['date'] as String),
          value: (json['value'] as num).toDouble(),
          signal: json['signal'] as String,
          credit: (json['credit'] as num).toDouble(),
          debit: (json['debit'] as num).toDouble(),
          history: json['history'] as String,
        );

Map<String, dynamic> _$AccountabilityGroupedAccaountEntrieModelToJson(
        AccountabilityGroupedAccaountEntrieModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toIso8601String(),
      'value': instance.value,
      'signal': instance.signal,
      'credit': instance.credit,
      'debit': instance.debit,
      'history': instance.history,
    };
