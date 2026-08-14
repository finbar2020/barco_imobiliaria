import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_vacation_entity.dart';

part 'timesheet_occurrence_vacation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetOccurrenceVacationModel {
  String name;
  String numCra;
  String initDate;
  String endDate;
  String receiptUrl;
  String archiveName;

  TimesheetOccurrenceVacationModel({
    this.numCra = "",
    this.name = '',
    this.initDate = '',
    this.endDate = '',
    this.receiptUrl = '',
    this.archiveName = '',
  });

  factory TimesheetOccurrenceVacationModel.fromJson(
          Map<String, dynamic> json) =>
      _$TimesheetOccurrenceVacationModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimesheetOccurrenceVacationModelToJson(this);

  static TimesheetOccurrenceVacationModel? fromEntity(
          TimesheetOccurrenceVacationEntity? entity) =>
      entity == null
          ? null
          : (TimesheetOccurrenceVacationModel()
            ..numCra = entity.numCra
            ..name = entity.name
            ..initDate = entity.initDate
            ..endDate = entity.endDate
            ..receiptUrl = entity.receiptUrl
            ..archiveName = entity.archiveName);

  TimesheetOccurrenceVacationEntity toEntity() =>
      TimesheetOccurrenceVacationEntity(
          numCra: numCra,
          name: name,
          initDate: initDate,
          endDate: endDate,
          receiptUrl: receiptUrl,
          archiveName: archiveName);
}
