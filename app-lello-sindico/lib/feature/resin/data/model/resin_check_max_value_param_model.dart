import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/resin/domain/entity/resin_check_max_value_param.dart';

part 'resin_check_max_value_param_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ResinCheckMaxValueParamModel {
  bool canRequest;
  String message;
  bool emailSended;

  ResinCheckMaxValueParamModel({
    required this.canRequest,
    required this.message,
    required this.emailSended,
  });

  factory ResinCheckMaxValueParamModel.fromJson(Map<String, dynamic> json) =>
      _$ResinCheckMaxValueParamModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResinCheckMaxValueParamModelToJson(this);

  static ResinCheckMaxValueParamModel fromEntity(
          ResinCheckMaxValueParam entity) =>
      ResinCheckMaxValueParamModel(
        canRequest: entity.canRequest,
        message: entity.message,
        emailSended: entity.emailSended,
      );

  ResinCheckMaxValueParam toEntity() => ResinCheckMaxValueParam(
        canRequest: this.canRequest,
        message: message,
        emailSended: this.emailSended,
      );
}
