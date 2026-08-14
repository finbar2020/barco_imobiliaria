import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_rate_response_entity.dart';

part 'ia_bella_rate_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaRateResponseModel {
  final String? responseId;
  final String? evaluationType;
  final String? justification;

  IaBellaRateResponseModel({
    this.responseId,
    this.evaluationType,
    this.justification,
  });

  factory IaBellaRateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaRateResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$IaBellaRateResponseModelToJson(this);

  static IaBellaRateResponseModel? fromEntity(
          IaBellaRateResponseEntity? entity) =>
      entity == null
          ? null
          : IaBellaRateResponseModel(
              responseId: entity.responseId,
              evaluationType: entity.evaluationType,
              justification: entity.justification,
            );

  IaBellaRateResponseEntity toEntity() => IaBellaRateResponseEntity(
        responseId: responseId,
        evaluationType: evaluationType,
        justification: justification,
      );
}
