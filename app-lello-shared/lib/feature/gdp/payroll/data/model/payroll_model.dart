import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/payroll/domain/entity/payroll.dart';

part 'payroll_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PayrollModel {
  DateTime? period;
  String? type;
  double? value;
  double? discounts;
  double? balance;

  PayrollModel();

  factory PayrollModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollModelFromJson(json);
  Map<String, dynamic> toJson() => _$PayrollModelToJson(this);

  static PayrollModel? fromEntity(Payroll? entity) => entity == null
      ? null
      : (PayrollModel()
        ..period = entity.period
        ..type = entity.type
        ..value = entity.value
        ..discounts = entity.discounts
        ..balance = entity.balance);

  Payroll toEntity() => Payroll()
    ..period = this.period
    ..period = this.period
    ..type = this.type
    ..value = this.value
    ..discounts = this.discounts
    ..balance = this.balance;
}
