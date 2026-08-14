import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_entity.dart';

part 'timesheet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetModel {
  final String? photo;
  final String name;
  final String? numCra;
  final String? jobPosition;
  final int? signatureId;
  final int? occurrences;
  final bool? signatureEmployee;
  final bool? signatureManager;
  final TimesheetActionEnum action;

  TimesheetModel({
    this.photo,
    required this.name,
    this.numCra,
    this.jobPosition,
    this.signatureId,
    this.occurrences,
    this.signatureEmployee,
    this.signatureManager,
    required this.action,
  });

  factory TimesheetModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetModelToJson(this);

  static TimesheetModel? fromEntity(TimesheetEntity? entity) => entity == null
      ? null
      : (TimesheetModel(
          photo: entity.photo,
          name: entity.name,
          numCra: entity.numCra,
          jobPosition: entity.jobPosition,
          signatureId: entity.signatureId,
          occurrences: entity.occurrences,
          signatureEmployee: entity.signatureEmployee,
          signatureManager: entity.signatureManager,
          action: entity.action,
        ));

  TimesheetEntity toEntity() => TimesheetEntity(
        photo: photo,
        name: name,
        numCra: numCra,
        jobPosition: jobPosition,
        signatureId: signatureId,
        occurrences: occurrences,
        signatureEmployee: signatureEmployee,
        signatureManager: signatureManager,
        action: action,
      );
}
