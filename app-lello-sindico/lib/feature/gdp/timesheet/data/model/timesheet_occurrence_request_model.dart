import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_request_entity.dart';

part 'timesheet_occurrence_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetOccurrenceRequestModel {
  String numCra;
  String typeOccurrence;
  String date;
  TimesheetOccurrenceRequestModel({
    this.numCra = "",
    this.typeOccurrence = '',
    this.date = '',
  });

  factory TimesheetOccurrenceRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetOccurrenceRequestModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimesheetOccurrenceRequestModelToJson(this);

  static TimesheetOccurrenceRequestModel? fromEntity(
          TimesheetOccurrenceRequestEntity? entity) =>
      entity == null
          ? null
          : (TimesheetOccurrenceRequestModel(
              numCra: entity.numCra,
              typeOccurrence: entity.tipoControleOcorrencia,
              date: entity.date,
            ));

  TimesheetOccurrenceRequestEntity toEntity() =>
      TimesheetOccurrenceRequestEntity(
        tipoControleOcorrencia: typeOccurrence,
        numCra: numCra,
        date: date,
      );
}
