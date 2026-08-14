import 'package:colaborador/feature/digital_point/data/model/condominium_life_validation_model.dart';
import 'package:colaborador/feature/digital_point/data/model/global_life_validation_config_model.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_life_validation_config.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

part 'digital_point_life_validation_config_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class DigitalPointLifeValidationConfigModel {
  final bool enabled;
  final GlobalLifeValidationConfigModel globalConfig;
  final List<CondominiumLifeValidationModel> condominiums;

  DigitalPointLifeValidationConfigModel({
    required this.enabled,
    required this.globalConfig,
    required this.condominiums,
  });

  factory DigitalPointLifeValidationConfigModel.fromJson(
          Map<String, dynamic> json) =>
      _$DigitalPointLifeValidationConfigModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$DigitalPointLifeValidationConfigModelToJson(this);

  DigitalPointLifeValidationConfig toEntity() =>
      DigitalPointLifeValidationConfig(
        enabled: enabled,
        globalConfig: globalConfig.toEntity(),
        condominiums: condominiums.map((e) => e.toEntity()).toList(),
      );
}
