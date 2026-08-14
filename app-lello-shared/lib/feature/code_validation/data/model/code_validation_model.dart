// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'code_validation_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CodeValidationModel {
  final String? id;
  final String? code;

  CodeValidationModel({
    this.id,
    this.code,
  });

  factory CodeValidationModel.fromJson(Map<String, dynamic> json) =>
      _$CodeValidationModelFromJson(json);
  Map<String, dynamic> toJson() => _$CodeValidationModelToJson(this);

  static CodeValidationModel? fromEntity(CodeValidation? entity) {
    return entity == null
        ? null
        : CodeValidationModel(
            id: entity.id,
            code: entity.code,
          );
  }

  CodeValidation toEntity() {
    return CodeValidation(
      id: this.id,
      code: this.code,
    );
  }
}
