import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RefreshTokenRequestModel {
  final String token;
  final String refreshToken;

  RefreshTokenRequestModel({required this.token, required this.refreshToken});

  factory RefreshTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RefreshTokenRequestModelToJson(this);
}
