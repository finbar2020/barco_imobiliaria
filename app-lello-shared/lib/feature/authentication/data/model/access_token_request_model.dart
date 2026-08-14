import 'package:json_annotation/json_annotation.dart';

part 'access_token_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessTokenRequestModel {
  final grantType = "password";
  final String username;
  final String password;

  AccessTokenRequestModel({required this.username, required this.password});

  factory AccessTokenRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenRequestModelToJson(this);
}
