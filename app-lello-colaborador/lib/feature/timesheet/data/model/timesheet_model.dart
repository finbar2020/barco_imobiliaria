import 'package:colaborador/feature/timesheet/data/model/timesheet_element_model.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_element.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';

part 'timesheet_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetModel {
  DateTime dateFrom;
  DateTime dateTo;
  DateTime? dateLiberation;
  String timesheetStatus;
  List<TimesheetElementModel> timesheetElements;

  TimesheetModel({
    required this.dateFrom,
    required this.dateTo,
    required this.dateLiberation,
    required this.timesheetStatus,
    required this.timesheetElements,
  });

  factory TimesheetModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimesheetModelToJson(this);

  static TimesheetModel? fromEntity(Timesheet? entity) => entity == null
      ? null
      : TimesheetModel(
          dateLiberation: entity.dateLiberation,
          dateFrom: entity.dateFrom,
          dateTo: entity.dateTo,
          timesheetStatus:
              enumToString(entity.timesheetStatus) ?? "notAssigned",
          timesheetElements: entity.timesheetElements
              .map((e) => TimesheetElementModel.fromEntity(e))
              .cast<TimesheetElementModel>()
              .toList(),
        );

  Timesheet toEntity() => Timesheet(
        dateLiberation: dateLiberation,
        dateFrom: dateFrom,
        dateTo: dateTo,
        timesheetStatus:
            stringToEnum(TimesheetStatusEnum.values, timesheetStatus) ??
                TimesheetStatusEnum.notAssigned,
        timesheetElements: timesheetElements
            .map((e) => e.toEntity())
            .cast<TimesheetElement>()
            .toList(),
      );
}
