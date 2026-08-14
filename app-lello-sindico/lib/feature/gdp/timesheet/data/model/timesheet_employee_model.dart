import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_employee.dart';

part 'timesheet_employee_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetEmployeeModel {
  String? id;
  String? name;
  DateTime? dob;
  String? role;
  DateTime? hiringDate;
  String? status;
  String? imageHash;
  String? numCra;
  String? turn;

  TimesheetEmployeeModel();

  factory TimesheetEmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetEmployeeModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimesheetEmployeeModelToJson(this);

  static TimesheetEmployeeModel? fromEntity(TimesheetEmployee? entity) =>
      entity == null
          ? null
          : (TimesheetEmployeeModel()
            ..id = entity.id
            ..name = entity.name
            ..dob = entity.dob
            ..role = entity.role
            ..hiringDate = entity.hiringDate
            ..status = entity.status
            ..imageHash = entity.imageHash
            ..numCra = entity.numCra
            ..turn = entity.turn);

  TimesheetEmployee toEntity() => TimesheetEmployee()
    ..id = id
    ..name = name
    ..dob = dob
    ..role = role
    ..hiringDate = hiringDate
    ..status = status
    ..imageHash = imageHash
    ..numCra = numCra
    ..turn = turn;
}
