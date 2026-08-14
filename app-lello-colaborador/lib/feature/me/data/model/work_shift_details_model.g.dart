// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_shift_details_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkShiftDetailsModel _$WorkShiftDetailsModelFromJson(
        Map<String, dynamic> json) =>
    WorkShiftDetailsModel(
      badageNumber: json['badage_number'] as String,
      entry1: json['entry1'] as String,
      out1: json['out1'] as String,
      entry2: json['entry2'] as String,
      out2: json['out2'] as String,
      isDayOff: json['is_day_off'] as bool,
      date: DateTime.parse(json['date'] as String),
      reference: json['reference'] as String,
    );

Map<String, dynamic> _$WorkShiftDetailsModelToJson(
        WorkShiftDetailsModel instance) =>
    <String, dynamic>{
      'badage_number': instance.badageNumber,
      'entry1': instance.entry1,
      'out1': instance.out1,
      'entry2': instance.entry2,
      'out2': instance.out2,
      'is_day_off': instance.isDayOff,
      'date': instance.date.toIso8601String(),
      'reference': instance.reference,
    };
