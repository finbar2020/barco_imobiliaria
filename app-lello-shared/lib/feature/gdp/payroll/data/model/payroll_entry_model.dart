import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll_entry.dart';

part 'payroll_entry_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PayrollEntryModel {
  String? id;
  String? title;
  double? value;

  PayrollEntryModel();

  factory PayrollEntryModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollEntryModelFromJson(json);
  Map<String, dynamic> toJson() => _$PayrollEntryModelToJson(this);

  static PayrollEntryModel? fromEntity(PayrollEntry? entity) => entity == null
      ? null
      : (PayrollEntryModel()
        ..id = entity.id
        ..title = entity.title
        ..value = entity.value);

  PayrollEntry toEntity() => PayrollEntry()
    ..id = this.id
    ..title = this.title
    ..value = this.value;
}
