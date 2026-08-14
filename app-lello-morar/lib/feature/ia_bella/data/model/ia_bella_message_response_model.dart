import 'package:essentials/essentials.dart';
import 'package:morar/feature/ia_bella/data/model/ia_bella_data_model.dart';
import 'package:morar/feature/ia_bella/domain/entity/ia_bella_message_response_entity.dart';

part 'ia_bella_message_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class IaBellaMessageResponseModel {
  final String? timestamp;
  final int? statusCode;
  final IaBellaDataModel? data;
  final String? errorMessage;

  IaBellaMessageResponseModel({
    this.timestamp,
    this.statusCode,
    this.data,
    this.errorMessage,
  });

  factory IaBellaMessageResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IaBellaMessageResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$IaBellaMessageResponseModelToJson(this);

  static IaBellaMessageResponseModel? fromEntity(
          IaBellaMessageResponseEntity? entity) =>
      entity == null
          ? null
          : (IaBellaMessageResponseModel(
              timestamp: entity.timestamp,
              statusCode: entity.statusCode,
              data: entity.data != null
                  ? IaBellaDataModel.fromEntity(entity.data)
                  : null,
              errorMessage: entity.errorMessage,
            ));

  IaBellaMessageResponseEntity toEntity() => IaBellaMessageResponseEntity(
        timestamp: timestamp,
        statusCode: statusCode,
        data: data?.toEntity(),
        errorMessage: errorMessage,
      );
}
