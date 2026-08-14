// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual_timesheet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManualTimeSheetModel _$ManualTimeSheetModelFromJson(
        Map<String, dynamic> json) =>
    ManualTimeSheetModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      fileHash: json['file_hash'] as String?,
    );

Map<String, dynamic> _$ManualTimeSheetModelToJson(
        ManualTimeSheetModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'file_hash': instance.fileHash,
    };
