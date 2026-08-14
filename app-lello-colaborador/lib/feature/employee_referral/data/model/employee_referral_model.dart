import 'package:colaborador/feature/employee_referral/domain/entity/employee_referral.dart';
import 'package:json_annotation/json_annotation.dart';

part 'employee_referral_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EmployeeReferralModel {
  final String? description;
  final String? city;
  final String? region;
  final String? hash;

  EmployeeReferralModel({
    required this.description,
    required this.city,
    required this.region,
    required this.hash,
  });

  factory EmployeeReferralModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeeReferralModelFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeReferralModelToJson(this);

  static EmployeeReferralModel fromEntity(
          EmployeeReferralEntity employeeReferral) =>
      EmployeeReferralModel(
        description: employeeReferral.description,
        city: employeeReferral.city,
        region: employeeReferral.region,
        hash: employeeReferral.fileTempHash,
      );

  EmployeeReferralEntity toEntity() => EmployeeReferralEntity(
        description: description,
        city: city,
        region: region,
        fileTempHash: hash,
      );
}
