// condominium_life_validation.dart
import 'package:lib_facedetection/lib_facedetection.dart';

class CondominiumLifeValidation {
  final int referencia;
  final bool requireLivenessCheck;
  final int? qteActionsLifeValidation;
  final bool? isRandomActionsLifeValidation;
  final List<LifeValidationTypeEnum>? actionsLifeValidation;

  CondominiumLifeValidation({
    required this.referencia,
    required this.requireLivenessCheck,
    this.qteActionsLifeValidation,
    this.isRandomActionsLifeValidation,
    this.actionsLifeValidation,
  });
}
