import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'register_fcm_token_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterFcmTokenModel {
  String? token;
  List<String>? reference;
  String? type;
  String? deviceId;
  String? refreshToken;

  RegisterFcmTokenModel();

  factory RegisterFcmTokenModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterFcmTokenModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterFcmTokenModelToJson(this);

  static RegisterFcmTokenModel? fromEntity(RegisterFcmToken? entity) =>
      entity == null
          ? null
          : (RegisterFcmTokenModel()
            ..token = entity.token
            ..reference = entity.reference
            ..type = entity.type
            ..deviceId = entity.deviceId
            ..refreshToken = entity.refreshToken);

  RegisterFcmToken toEntity() => RegisterFcmToken()
    ..token = this.token
    ..reference = this.reference
    ..type = this.type
    ..deviceId = this.deviceId
    ..refreshToken = this.refreshToken;
}
