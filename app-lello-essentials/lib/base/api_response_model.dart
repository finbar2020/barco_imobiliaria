import 'package:essentials/base/api_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'api_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ApiResponseModel {
  bool success;
  String message;
  dynamic data;
  String errorCode;

  ApiResponseModel({
    this.success = false,
    this.message = '',
    this.data,
    this.errorCode = '',
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ApiResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ApiResponseModelToJson(this);

  static ApiResponseModel fromEntity(ApiResponse entity) => ApiResponseModel()
    ..success = entity.success
    ..message = entity.message ?? ""
    ..data = entity.data
    ..errorCode = entity.errorCode ?? "";

  ApiResponse toEntity() => ApiResponse()
    ..success = this.success
    ..message = this.message
    ..data = this.data
    ..errorCode = this.errorCode;
}
