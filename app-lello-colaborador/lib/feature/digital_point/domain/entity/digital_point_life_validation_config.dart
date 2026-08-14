import 'package:colaborador/feature/digital_point/domain/entity/condominium_life_validation.dart';
import 'package:colaborador/feature/digital_point/domain/entity/global_life_validation_config.dart';

class DigitalPointLifeValidationConfig {
  final bool enabled;
  final GlobalLifeValidationConfig globalConfig;
  final List<CondominiumLifeValidation> condominiums;

  DigitalPointLifeValidationConfig({
    required this.enabled,
    required this.globalConfig,
    required this.condominiums,
  });
  DigitalPointLifeValidationConfig.empty()
      : enabled = false,
        globalConfig = GlobalLifeValidationConfig.empty(),
        condominiums = const [];
}
