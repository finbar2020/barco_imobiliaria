import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/feature/gdp/payslip/domain/entity/payslip.dart';

part 'payslip_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PayslipModel {
  String? name;
  String? description;
  String? type;
  DateTime? processingDate;

  PayslipModel();

  factory PayslipModel.fromJson(Map<String, dynamic> json) =>
      _$PayslipModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayslipModelToJson(this);

  static PayslipModel? fromEntity(Payslip? entity) => entity == null
      ? null
      : (PayslipModel()
        ..name = entity.name
        ..description = entity.description
        ..type = entity.type
        ..processingDate = entity.processingDate);

  Payslip toEntity() => Payslip()
    ..name = name
    ..description = description
    ..type = type
    ..processingDate = processingDate;
}
