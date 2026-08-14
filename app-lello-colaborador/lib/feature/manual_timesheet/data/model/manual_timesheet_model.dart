import 'package:colaborador/feature/manual_timesheet/domain/entity/manual_timesheet.dart';
import 'package:json_annotation/json_annotation.dart';

part 'manual_timesheet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ManualTimeSheetModel {
  final DateTime? date;
  final String? fileHash;

  ManualTimeSheetModel({
    required this.date,
    required this.fileHash,
  });

  factory ManualTimeSheetModel.fromJson(Map<String, dynamic> json) =>
      _$ManualTimeSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$ManualTimeSheetModelToJson(this);

  static ManualTimeSheetModel fromEntity(ManualTimeSheetEntity manualTimeSheet) => ManualTimeSheetModel(
        date: manualTimeSheet.date,
        fileHash: manualTimeSheet.fileTempHash,
      );

  ManualTimeSheetEntity toEntity() => ManualTimeSheetEntity(
        date: date,
        fileTempHash: fileHash,
      );
}
