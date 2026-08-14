// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_zero_paper_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferencesZeroPaperModel _$PreferencesZeroPaperModelFromJson(
        Map<String, dynamic> json) =>
    PreferencesZeroPaperModel(
      deliveryAnnouncements: $enumDecodeNullable(
          _$PreferencesZeroPaperEnumEnumMap, json['delivery_announcements']),
      deliveryActs: $enumDecodeNullable(
          _$PreferencesZeroPaperEnumEnumMap, json['delivery_acts']),
      deliverySlips: $enumDecodeNullable(
          _$PreferencesZeroPaperEnumEnumMap, json['delivery_slips']),
      deliveryStatements: $enumDecodeNullable(
          _$PreferencesZeroPaperEnumEnumMap, json['delivery_statements']),
      allUnits: json['all_units'] as bool?,
    );

Map<String, dynamic> _$PreferencesZeroPaperModelToJson(
        PreferencesZeroPaperModel instance) =>
    <String, dynamic>{
      'delivery_announcements':
          _$PreferencesZeroPaperEnumEnumMap[instance.deliveryAnnouncements],
      'delivery_acts': _$PreferencesZeroPaperEnumEnumMap[instance.deliveryActs],
      'delivery_slips':
          _$PreferencesZeroPaperEnumEnumMap[instance.deliverySlips],
      'delivery_statements':
          _$PreferencesZeroPaperEnumEnumMap[instance.deliveryStatements],
      'all_units': instance.allUnits,
    };

const _$PreferencesZeroPaperEnumEnumMap = {
  PreferencesZeroPaperEnum.printed: 'printed',
  PreferencesZeroPaperEnum.digital: 'digital',
  PreferencesZeroPaperEnum.printed_digital: 'printed_digital',
};
