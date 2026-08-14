// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sick_note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SickNoteModel _$SickNoteModelFromJson(Map<String, dynamic> json) =>
    SickNoteModel(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      fileHash: json['file_hash'] as String?,
      fileExtension: json['file_extension'] as String?,
      sickNoteDays: (json['sick_note_days'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SickNoteModelToJson(SickNoteModel instance) =>
    <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'file_hash': instance.fileHash,
      'file_extension': instance.fileExtension,
      'sick_note_days': instance.sickNoteDays,
    };
