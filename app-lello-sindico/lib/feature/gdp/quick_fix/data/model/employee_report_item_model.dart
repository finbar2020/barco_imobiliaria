import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/quick_fix/domain/entity/employee_report_item.dart';

part 'employee_report_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EmployeeReportItemModel {
  String? description;
  Object? value;

  EmployeeReportItemModel();

  factory EmployeeReportItemModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeReportItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeReportItemModelToJson(this);

  static EmployeeReportItemModel? fromEntity(EmployeeReportItem? entity) =>
      entity == null
          ? null
          : (EmployeeReportItemModel()
            ..description = entity.description
            ..value = entity.value);

  EmployeeReportItem toEntity() => EmployeeReportItem()
    ..description = this.description
    ..value = this.value;
}
