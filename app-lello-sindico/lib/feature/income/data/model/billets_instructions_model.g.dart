// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billets_instructions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletsInstructionsModel _$BilletsInstructionsModelFromJson(
        Map<String, dynamic> json) =>
    BilletsInstructionsModel()
      ..lateBillet = json['late_billet'] as String?
      ..secondBillet = json['second_billet'] as String?
      ..afterMaturity = json['after_maturity'] as String?;

Map<String, dynamic> _$BilletsInstructionsModelToJson(
        BilletsInstructionsModel instance) =>
    <String, dynamic>{
      'late_billet': instance.lateBillet,
      'second_billet': instance.secondBillet,
      'after_maturity': instance.afterMaturity,
    };
