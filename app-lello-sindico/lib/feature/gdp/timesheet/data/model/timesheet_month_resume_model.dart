import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_month_resume_entity.dart';

part 'timesheet_month_resume_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetMonthResumeModel {
  int extraHours;
  int delays;
  int vacations;
  int fouls;
  int extraHoursHundred;
  int otherExtraHours;

  TimesheetMonthResumeModel({
    this.extraHours = 0,
    this.delays = 0,
    this.vacations = 0,
    this.fouls = 0,
    this.extraHoursHundred = 0,
    this.otherExtraHours = 0,
  });

  factory TimesheetMonthResumeModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetMonthResumeModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetMonthResumeModelToJson(this);

  static TimesheetMonthResumeModel? fromEntity(
          TimesheetMonthResumeEntity? entity) =>
      entity == null
          ? null
          : (TimesheetMonthResumeModel()
            ..extraHours = entity.extraHours
            ..delays = entity.delays
            ..vacations = entity.vacations
            ..fouls = entity.fouls
            ..extraHoursHundred = entity.extraHoursHundred
            ..otherExtraHours = entity.otherExtraHours);

  TimesheetMonthResumeEntity toEntity() => TimesheetMonthResumeEntity(
      extraHours: extraHours,
      delays: delays,
      vacations: vacations,
      fouls: fouls,
      extraHoursHundred: extraHoursHundred,
      otherExtraHours: otherExtraHours);
}
