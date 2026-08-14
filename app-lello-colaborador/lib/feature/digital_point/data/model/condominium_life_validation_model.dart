import 'package:colaborador/feature/digital_point/domain/entity/condominium_life_validation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lib_facedetection/lib_facedetection.dart';
part 'condominium_life_validation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumLifeValidationModel {
  final int referencia;
  final bool requireLivenessCheck;
  final int? qteActionsLifeValidation;
  final bool? isRandomActionsLifeValidation;
  final List<LifeValidationTypeEnum>? actionsLifeValidation;

  CondominiumLifeValidationModel({
    required this.referencia,
    required this.requireLivenessCheck,
    this.qteActionsLifeValidation,
    this.isRandomActionsLifeValidation,
    this.actionsLifeValidation,
  });

  factory CondominiumLifeValidationModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumLifeValidationModelFromJson(json);

  Map<String, dynamic> toJson() => _$CondominiumLifeValidationModelToJson(this);

  CondominiumLifeValidation toEntity() => CondominiumLifeValidation(
        referencia: referencia,
        requireLivenessCheck: requireLivenessCheck,
        qteActionsLifeValidation: qteActionsLifeValidation,
        isRandomActionsLifeValidation: isRandomActionsLifeValidation,
        actionsLifeValidation: actionsLifeValidation,
      );
}
