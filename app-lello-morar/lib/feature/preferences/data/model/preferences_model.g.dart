// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PreferencesModel _$PreferencesModelFromJson(Map<String, dynamic> json) =>
    PreferencesModel(
      zeroPaper: json['zero_paper'] == null
          ? null
          : PreferencesZeroPaperModel.fromJson(
              json['zero_paper'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PreferencesModelToJson(PreferencesModel instance) =>
    <String, dynamic>{
      'zero_paper': instance.zeroPaper,
    };
