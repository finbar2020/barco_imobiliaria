import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_question_type_solicitation.dart';

part 'acountability_question_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityQuestionTypeModel {
  String id;
  String name;
  int idCompany;
  int idSupervisor;
  int idRequestPpc;

  AccountabilityQuestionTypeModel(
      {required this.id,
      required this.name,
      this.idCompany = 0,
      this.idSupervisor = 0,
      this.idRequestPpc = 0});

  factory AccountabilityQuestionTypeModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityQuestionTypeModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityQuestionTypeModelToJson(this);

  static AccountabilityQuestionTypeModel fromEntity(
          AccountabilityQuestionType entity) =>
      (AccountabilityQuestionTypeModel(
          id: entity.id,
          name: entity.name,
          idCompany: entity.idCompany,
          idSupervisor: entity.idSupervisor,
          idRequestPpc: entity.idRequestPpc));

  AccountabilityQuestionType toEntity() => AccountabilityQuestionType(
      id: this.id,
      name: this.name,
      idCompany: this.idCompany,
      idSupervisor: this.idSupervisor,
      idRequestPpc: this.idRequestPpc);
}
