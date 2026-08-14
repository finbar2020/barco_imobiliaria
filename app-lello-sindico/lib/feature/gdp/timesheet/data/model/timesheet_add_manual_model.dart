import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_entity.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_add_manual_enum.dart';

part 'timesheet_add_manual_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetAddManualModel {
  final String numCra;
  final DateTime date;
  final TimesheetAddManualEnum type;
  final String justification;
  final List<String> marks;
  final bool single;
  TimesheetAddManualModel({
    required this.numCra,
    required this.date,
    required this.type,
    required this.justification,
    required this.marks,
    required this.single,
  });

  factory TimesheetAddManualModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetAddManualModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetAddManualModelToJson(this);

  static TimesheetAddManualModel? fromEntity(
          TimesheetAddManualEntity? entity) =>
      entity == null
          ? null
          : (TimesheetAddManualModel(
              numCra: entity.numCra,
              date: entity.date,
              type: entity.type,
              justification: entity.justification,
              marks: entity.marks,
              single: entity.single,
            ));

  TimesheetAddManualEntity toEntity() => TimesheetAddManualEntity(
        numCra: numCra,
        date: date,
        type: type,
        justification: justification,
        marks: marks,
        single: single,
      );
}
