import 'package:colaborador/feature/digital_point/domain/entity/global_life_validation_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
part 'global_life_validation_config_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class GlobalLifeValidationConfigModel {
  final bool requireLivenessCheck;
  final int qteActionsLifeValidation;
  final bool isRandomActionsLifeValidation;
  final List<LifeValidationTypeEnum> actionsLifeValidation;

  GlobalLifeValidationConfigModel({
    required this.requireLivenessCheck,
    required this.qteActionsLifeValidation,
    required this.isRandomActionsLifeValidation,
    required this.actionsLifeValidation,
  });

  factory GlobalLifeValidationConfigModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalLifeValidationConfigModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$GlobalLifeValidationConfigModelToJson(this);

  GlobalLifeValidationConfig toEntity() => GlobalLifeValidationConfig(
        requireLivenessCheck: requireLivenessCheck,
        qteActionsLifeValidation: qteActionsLifeValidation,
        isRandomActionsLifeValidation: isRandomActionsLifeValidation,
        actionsLifeValidation: actionsLifeValidation,
      );
}
