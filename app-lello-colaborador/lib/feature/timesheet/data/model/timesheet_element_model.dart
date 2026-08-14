import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:json_annotation/json_annotation.dart';

part 'timesheet_element_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetElementModel {
  DateTime date;
  List<String> times;
  String journey;
  bool hasTreatment;
  bool dayOff;

  TimesheetElementModel({
    required this.date,
    required this.times,
    required this.journey,
    required this.hasTreatment,
    required this.dayOff,
  });

  factory TimesheetElementModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetElementModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimesheetElementModelToJson(this);

  static TimesheetElementModel? fromEntity(TimesheetElement? entity) =>
      entity == null
          ? null
          : TimesheetElementModel(
              date: entity.date,
              times: entity.times,
              journey: entity.journey,
              hasTreatment: entity.hasTreatment,
              dayOff: entity.dayOff,
            );

  TimesheetElement toEntity() => TimesheetElement(
        date: date,
        times: times,
        journey: journey,
        hasTreatment: hasTreatment,
        dayOff: dayOff,
      );
}
