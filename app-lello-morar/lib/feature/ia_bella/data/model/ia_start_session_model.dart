import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_data_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_start_session_entity.dart';

part 'ia_start_session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaStartSessionModel {
  final String? timestamp;
  final int? statusCode;
  final IaBellaDataModel? data;
  final String? errorMessage;

  IaStartSessionModel({
    this.timestamp,
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  factory IaStartSessionModel.fromJson(Map<String, dynamic> json) =>
      _$IaStartSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$IaStartSessionModelToJson(this);

  static IaStartSessionModel? fromEntity(IaBellaStartSessionEntity? entity) =>
      entity == null
          ? null
          : (IaStartSessionModel(
              timestamp: entity.timestamp,
              statusCode: entity.statusCode,
              data: entity.data != null
                  ? IaBellaDataModel.fromEntity(entity.data)
                  : null,
              errorMessage: entity.errorMessage,
            ));

  IaBellaStartSessionEntity toEntity() => IaBellaStartSessionEntity(
        timestamp: timestamp,
        statusCode: statusCode,
        data: data?.toEntity(),
        errorMessage: errorMessage,
      );
}
