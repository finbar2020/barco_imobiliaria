import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/data/model/timesheet_employee_marks_model.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_action_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_detail_entity.dart';

part 'timesheet_employee_detail_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetEmployeeDetailModel {
  final DateTime startDateOfAssessment;
  final DateTime endDateOfAssessment;
  final dynamic signatureId;
  final bool employeeSigned;
  final bool syndicateSigned;
  final TimesheetActionEnum action;
  final List<TimesheetEmployeeMarksModel> markings;
  TimesheetEmployeeDetailModel({
    required this.startDateOfAssessment,
    required this.endDateOfAssessment,
    required this.signatureId,
    required this.employeeSigned,
    required this.syndicateSigned,
    required this.action,
    required this.markings,
  });

  factory TimesheetEmployeeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEmployeeDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetEmployeeDetailModelToJson(this);

  static TimesheetEmployeeDetailModel? fromEntity(
          TimesheetEmployeeDetailEntity? entity) =>
      entity == null
          ? null
          : (TimesheetEmployeeDetailModel(
              startDateOfAssessment: entity.startDateOfAssessment,
              endDateOfAssessment: entity.endDateOfAssessment,
              signatureId: entity.signatureId,
              employeeSigned: entity.employeeSigned,
              syndicateSigned: entity.syndicateSigned,
              action: entity.action,
              markings: entity.markings
                  .map((e) => TimesheetEmployeeMarksModel.fromEntity(e)!)
                  .toList(),
            ));

  TimesheetEmployeeDetailEntity toEntity() => TimesheetEmployeeDetailEntity(
        startDateOfAssessment: startDateOfAssessment,
        endDateOfAssessment: endDateOfAssessment,
        signatureId: signatureId,
        employeeSigned: employeeSigned,
        syndicateSigned: syndicateSigned,
        action: action,
        markings: markings.map((e) => e.toEntity()).toList(),
      );
}
