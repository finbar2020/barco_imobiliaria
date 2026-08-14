// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'billet_instructions_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BilletInstructionsModel _$BilletInstructionsModelFromJson(
        Map<String, dynamic> json) =>
    BilletInstructionsModel(
      lateBillet: json['late_billet'] as String?,
      secondBillet: json['second_billet'] as String?,
      afterMaturity: json['after_maturity'] as String?,
    );

Map<String, dynamic> _$BilletInstructionsModelToJson(
        BilletInstructionsModel instance) =>
    <String, dynamic>{
      'late_billet': instance.lateBillet,
      'second_billet': instance.secondBillet,
      'after_maturity': instance.afterMaturity,
    };
