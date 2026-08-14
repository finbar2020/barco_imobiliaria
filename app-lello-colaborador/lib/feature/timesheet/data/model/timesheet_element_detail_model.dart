import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element_detail.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_point_flag_enum.dart';
import 'package:essentials/essentials.dart';

part 'timesheet_element_detail_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetElementDetailModel {
  String time;
  String timesheetFlag;
  DateTime date;

  TimesheetElementDetailModel({
    required this.time,
    required this.timesheetFlag,
    required this.date,
  });

  factory TimesheetElementDetailModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetElementDetailModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimesheetElementDetailModelToJson(this);

  static TimesheetElementDetailModel? fromEntity(
          TimesheetElementDetail? entity) =>
      entity == null
          ? null
          : TimesheetElementDetailModel(
              time: entity.time,
              date: entity.date,
              timesheetFlag: enumToString(entity.timesheetFlag) ?? "none",
            );

  TimesheetElementDetail? toEntity() => TimesheetElementDetail(
        time: time,
        date: date,
        timesheetFlag:
            stringToEnum(TimesheetPointFlagEnum.values, timesheetFlag) ??
                TimesheetPointFlagEnum.none,
      );
}
