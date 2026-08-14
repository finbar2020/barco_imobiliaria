import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/payslip/domain/entity/payslipFile.dart';

part 'payslip_file_model.g.dart';

@JsonSerializable()
class PayslipFileModel {
  String? id;
  String? name;
  String? type;
  String? data;

  PayslipFileModel();

  factory PayslipFileModel.fromJson(Map<String, dynamic> json) =>
      _$PayslipFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayslipFileModelToJson(this);

  static PayslipFileModel? fromEntity(PayslipFile? entity) => entity == null
      ? null
      : (PayslipFileModel()
        ..id = entity.id
        ..name = entity.name
        ..type = entity.type
        ..data = entity.data);

  PayslipFile toEntity() => PayslipFile()
    ..id = id
    ..name = name
    ..type = type
    ..data = data;
}
