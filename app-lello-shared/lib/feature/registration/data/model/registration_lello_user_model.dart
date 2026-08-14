import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'registration_lello_user_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegistrationLelloUserModel {
  String? name;
  String? cpf;
  List<String>? emails;
  List<String?>? phones;
  bool? registered;
  List<double>? contexts;

  RegistrationLelloUserModel();

  factory RegistrationLelloUserModel.fromJson(Map<String, dynamic> json) =>
      _$RegistrationLelloUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegistrationLelloUserModelToJson(this);

  static RegistrationLelloUserModel? fromEntity(
          RegistrationLelloUser? entity) =>
      entity == null
          ? null
          : (RegistrationLelloUserModel()
            ..name = entity.name
            ..cpf = entity.cpf
            ..emails = entity.emails
            ..phones = entity.phones
            ..registered = entity.registered
            ..contexts = entity.contexts);

  RegistrationLelloUser toEntity() => RegistrationLelloUser()
    ..name = this.name
    ..cpf = this.cpf
    ..emails = this.emails
    ..phones = this.phones
    ..registered = this.registered
    ..contexts = this.contexts;
}
