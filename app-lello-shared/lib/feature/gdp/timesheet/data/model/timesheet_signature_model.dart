import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/data/model/employee_model.dart';
import 'package:shared_features/feature/gdp/timesheet/domain/entity/timesheet_signature.dart';

part 'timesheet_signature_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetSignatureModel {
  int? id;
  EmployeeModel? employee;
  DateTime? signatureDateTime;
  DateTime? periodDate;
  bool? approvedFlag;
  String? typeSignature;

  TimesheetSignatureModel();

  factory TimesheetSignatureModel.fromJson(Map<String, dynamic> json) =>
      _$TimesheetSignatureModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimesheetSignatureModelToJson(this);

  static TimesheetSignatureModel? fromEntity(TimesheetSignature? entity) =>
      entity == null
          ? null
          : (TimesheetSignatureModel()
            ..id = entity.id
            ..employee = EmployeeModel.fromEntity(entity.employee)
            ..signatureDateTime = entity.signatureDateTime
            ..periodDate = entity.periodDate
            ..approvedFlag = entity.approvedFlag
            ..typeSignature = entity.typeSignature);

  TimesheetSignature toEntity() => TimesheetSignature()
    ..id = this.id
    ..employee = this.employee?.toEntity()
    ..signatureDateTime = this.signatureDateTime
    ..periodDate = this.periodDate
    ..approvedFlag = this.approvedFlag
    ..typeSignature = this.typeSignature;
}
