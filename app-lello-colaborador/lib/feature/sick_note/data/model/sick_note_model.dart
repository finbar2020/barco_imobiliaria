import 'package:colaborador/feature/sick_note/domain/entity/sick_note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'sick_note_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SickNoteModel {
  final DateTime? date;
  final String? fileHash;
  final String? fileExtension;
  final int? sickNoteDays;

  SickNoteModel({
    required this.date,
    required this.fileHash,
    required this.fileExtension,
    required this.sickNoteDays,
  });

  factory SickNoteModel.fromJson(Map<String, dynamic> json) =>
      _$SickNoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$SickNoteModelToJson(this);

  static SickNoteModel fromEntity(SickNoteEntity sickNote) => SickNoteModel(
        date: sickNote.date,
        fileHash: sickNote.fileTempHash,
        fileExtension: sickNote.typeFile,
        sickNoteDays: sickNote.sickNoteDays,
      );

  SickNoteEntity toEntity() => SickNoteEntity(
        date: date,
        fileTempHash: fileHash,
        typeFile: fileExtension,
        sickNoteDays: sickNoteDays
      );
}
