import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'registation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegistrationModel {
  final String? name;
  final String? cpf;
  final String? email;
  final String? phone;
  final String? password;
  final String? token;
  final bool? termsAndConditionsCheck;

  RegistrationModel({
    this.name,
    this.cpf,
    this.email,
    this.phone,
    this.password,
    this.token,
    this.termsAndConditionsCheck,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegistrationModelToJson(this);

  static RegistrationModel? fromEntity(Registration? entity) => entity == null
      ? null
      : RegistrationModel(
          name: entity.name,
          cpf: entity.cpf,
          email: entity.email,
          phone: entity.phone,
          password: entity.password,
          token: entity.token,
          termsAndConditionsCheck: entity.termsAndConditionsCheck,
        );

  Registration toEntity() => Registration(
        name: this.name,
        cpf: this.cpf,
        email: this.email,
        phone: this.phone,
        password: this.password,
        token: this.token,
        termsAndConditionsCheck: this.termsAndConditionsCheck,
      );
}
