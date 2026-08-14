// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletModel _$BilletModelFromJson(Map<String, dynamic> json) => BilletModel(
      id: json['id'] as String?,
      unit: json['unit'] == null
          ? null
          : UnitModel.fromJson(json['unit'] as Map<String, dynamic>),
      value: (json['value'] as num?)?.toDouble(),
      period: json['period'] == null
          ? null
          : DateTime.parse(json['period'] as String),
      bankPeriod: json['bank_period'] == null
          ? null
          : DateTime.parse(json['bank_period'] as String),
      situation: json['situation'] as String?,
      invoice: (json['invoice'] as num?)?.toInt(),
      nrBillet: json['nr_billet'] as String?,
      code: json['code'] as String?,
      instructions: json['instructions'] == null
          ? null
          : BilletsInstructionsModel.fromJson(
              json['instructions'] as Map<String, dynamic>),
      founds: (json['founds'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : BilletsFoundsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BilletModelToJson(BilletModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'unit': instance.unit,
      'value': instance.value,
      'period': instance.period?.toIso8601String(),
      'bank_period': instance.bankPeriod?.toIso8601String(),
      'situation': instance.situation,
      'invoice': instance.invoice,
      'nr_billet': instance.nrBillet,
      'code': instance.code,
      'instructions': instance.instructions,
      'founds': instance.founds,
    };
