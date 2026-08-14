import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee_marks_entity.dart';

part 'timesheet_employee_marks_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetEmployeeMarksModel {
  final String craNumber;
  final String reference;
  final DateTime? referenceDate;
  final String type;
  final String receivedMarking;
  final int occurrenceDuration;
  final bool outOfRadius;
  TimesheetEmployeeMarksModel({
    this.craNumber = '',
    this.reference = '',
    this.referenceDate,
    required this.type,
    this.receivedMarking = '',
    this.occurrenceDuration = 0,
    this.outOfRadius = false,
  });

  factory TimesheetEmployeeMarksModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEmployeeMarksModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetEmployeeMarksModelToJson(this);

  static TimesheetEmployeeMarksModel? fromEntity(
          TimesheetEmployeeMarksEntity? entity) =>
      entity == null
          ? null
          : (TimesheetEmployeeMarksModel(
              craNumber: entity.craNumber,
              reference: entity.reference,
              type: entity.type,
              referenceDate: entity.referenceDate,
              receivedMarking: entity.receivedMarking,
              occurrenceDuration: entity.occurrenceDuration,
              outOfRadius: entity.outOfRadius,
            ));

  TimesheetEmployeeMarksEntity toEntity() => TimesheetEmployeeMarksEntity(
        craNumber: craNumber,
        reference: reference,
        referenceDate: referenceDate ?? DateTime.now(),
        type: type,
        receivedMarking: receivedMarking,
        occurrenceDuration: occurrenceDuration,
        outOfRadius: outOfRadius,
      );
}
