import 'package:essentials/essentials.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'code_request_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CodeRequestModel {
  String? id;
  String? source;
  String? origin;
  String? value;
  String? token;
  String? cpf;
  String? appSignature;

  CodeRequestModel();

  factory CodeRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CodeRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$CodeRequestModelToJson(this);

  static CodeRequestModel? fromEntity(CodeRequest? entity) => entity == null
      ? null
      : (CodeRequestModel()
        ..id = entity.id
        ..source = enumToString(entity.source)
        ..origin = enumToString(entity.origin)
        ..token = entity.token
        ..value = entity.value
        ..cpf = entity.cpf
        ..appSignature = entity.appSignature);

  CodeRequest toEntity() => CodeRequest(
      origin: stringToEnum(CodeValidationOrigin.values, this.origin ?? "") ??
          CodeValidationOrigin.other,
      source: stringToEnum(CodeValidationSource.values, this.source ?? "") ??
          CodeValidationSource.email,
      token: this.token ?? "",
      value: this.value ?? "",
      cpf: this.cpf,
      id: this.id,
      appSignature: this.appSignature);
}
