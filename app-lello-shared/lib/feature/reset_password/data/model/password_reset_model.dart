import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'password_reset_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PasswordResetModel {
  String? password;
  String? cpf;
  String? token;

  PasswordResetModel();

  factory PasswordResetModel.fromJson(Map<String, dynamic> json) =>
      _$PasswordResetModelFromJson(json);
  Map<String, dynamic> toJson() => _$PasswordResetModelToJson(this);

  static PasswordResetModel? fromEntity(PasswordReset? entity) => entity == null
      ? null
      : (PasswordResetModel()
        ..password = entity.password
        ..cpf = entity.cpf
        ..token = entity.token);

  PasswordReset toEntity() => PasswordReset()
    ..password = this.password
    ..cpf = this.cpf
    ..token = this.token;
}
