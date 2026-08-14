import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/data/model/employee_model.dart';
import 'package:lello/feature/gdp/quick_fix/data/model/employee_report_item_model.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_type.dart';

part 'employee_report_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EmployeeReportModel {
  EmployeeReportType? type;
  EmployeeModel? employee;
  List<EmployeeReportItemModel>? items;
  String? stabilityDescription;
  DateTime? stabilityEnd;
  DateTime? stabilityStart;

  EmployeeReportModel();

  factory EmployeeReportModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeReportModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeReportModelToJson(this);

  static EmployeeReportModel? fromEntity(EmployeeReport? entity) =>
      entity == null
          ? null
          : (EmployeeReportModel()
            ..type = entity.type
            ..employee = EmployeeModel.fromEntity(entity.employee)
            ..items = entity.items
                    ?.map((e) => EmployeeReportItemModel.fromEntity(e)!)
                    .toList() ??
                []
            ..stabilityDescription = entity.stabilityDescription
            ..stabilityEnd = entity.stabilityEnd
            ..stabilityStart = entity.stabilityStart);

  EmployeeReport toEntity() => (EmployeeReport()
    ..type = this.type
    ..employee = this.employee?.toEntity()
    ..items = this.items?.map((e) => e.toEntity()).toList() ?? []
    ..stabilityDescription = this.stabilityDescription
    ..stabilityEnd = this.stabilityEnd
    ..stabilityStart = this.stabilityStart);
}
