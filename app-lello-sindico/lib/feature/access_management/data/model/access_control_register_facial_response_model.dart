import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/access_management/domain/entity/access_control_register_facial_response.dart';

part 'access_control_register_facial_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessControlRegisterFacialResponseModel {
  String? status;
  String? message;
  String? codigo;
  bool? success;
  DateTime? timestamp;

  AccessControlRegisterFacialResponseModel({
    this.status,
    this.message,
    this.codigo,
    this.success,
    this.timestamp,
  });

  factory AccessControlRegisterFacialResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccessControlRegisterFacialResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AccessControlRegisterFacialResponseModelToJson(this);

  static AccessControlRegisterFacialResponseModel? fromEntity(
          AccessControlRegisterFacialResponse? entity) =>
      entity == null
          ? null
          : (AccessControlRegisterFacialResponseModel()
            ..status = entity.status
            ..message = entity.message
            ..codigo = entity.codigo
            ..success = entity.success
            ..timestamp = entity.timestamp);

  AccessControlRegisterFacialResponse toEntity() =>
      AccessControlRegisterFacialResponse()
        ..status = status
        ..message = message
        ..codigo = codigo
        ..success = success
        ..timestamp = timestamp;
}
