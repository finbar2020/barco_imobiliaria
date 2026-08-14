import 'package:lib_facedetection/lib_facedetection.dart';

class GlobalLifeValidationConfig {
  final bool requireLivenessCheck;
  final int qteActionsLifeValidation;
  final bool isRandomActionsLifeValidation;
  final List<LifeValidationTypeEnum> actionsLifeValidation;

  GlobalLifeValidationConfig({
    required this.requireLivenessCheck,
    required this.qteActionsLifeValidation,
    required this.isRandomActionsLifeValidation,
    required this.actionsLifeValidation,
  });

  GlobalLifeValidationConfig.empty({
    this.requireLivenessCheck = false,
    this.qteActionsLifeValidation = 0,
    this.isRandomActionsLifeValidation = false,
    this.actionsLifeValidation = const [],
  });
}
