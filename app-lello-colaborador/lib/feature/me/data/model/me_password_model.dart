import 'package:json_annotation/json_annotation.dart';

part 'me_password_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MePasswordModel {
  String? cpf;
  String? originPassword;
  String? password;

  MePasswordModel({
    this.cpf,
    this.originPassword,
    this.password,
  });

  factory MePasswordModel.fromJson(Map<String, dynamic> json) =>
      _$MePasswordModelFromJson(json);
  Map<String, dynamic> toJson() => _$MePasswordModelToJson(this);

  static MePasswordModel init(
          String cpf, String originPassword, String password) =>
      MePasswordModel()
        ..cpf = cpf
        ..originPassword = originPassword
        ..password = password;
}
