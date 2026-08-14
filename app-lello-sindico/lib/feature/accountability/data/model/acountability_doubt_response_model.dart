import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_answer.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_attachments_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_question_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';

part 'acountability_doubt_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityDoubtResponseModel {
  String? id;
  String message;
  DoubtSituation situation;
  List<AttachmentsModel> attachments;
  DateTime period;
  DateTime createdAt;
  DateTime updatedAt;
  AccountabilityQuestionTypeModel questionType;
  List<AccountabilityDoubtAnswerModel> answers;

  AccountabilityDoubtResponseModel({
    required this.id,
    required this.message,
    required this.situation,
    required this.attachments,
    required this.period,
    required this.createdAt,
    required this.updatedAt,
    required this.questionType,
    required this.answers,
  });

  factory AccountabilityDoubtResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$AccountabilityDoubtResponseModelFromJson(json);
  Map<String, dynamic> toJson() =>
      _$AccountabilityDoubtResponseModelToJson(this);

  static AccountabilityDoubtResponseModel fromEntity(
          AccountabilityDoubt entity) =>
      (AccountabilityDoubtResponseModel(
          id: entity.id,
          message: entity.message,
          situation: entity.questionSituation,
          period: entity.period,
          attachments: entity.attachments
              .map((e) => AttachmentsModel.fromEntity(e))
              .toList(),
          answers: entity.answers
              .map((e) => AccountabilityDoubtAnswerModel.fromEntity(e))
              .toList(),
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          questionType:
              AccountabilityQuestionTypeModel.fromEntity(entity.doubtType!)));

  AccountabilityDoubt toEntity() => AccountabilityDoubt(
        period: this.period,
      )
        ..id = this.id ?? ""
        ..message = this.message
        ..questionSituation = this.situation
        ..doubtType = this.questionType.toEntity()
        ..createdAt = this.createdAt
        ..updatedAt = this.updatedAt
        ..attachments = this.attachments.map((e) => e.toEntity()).toList()
        ..answers = this.answers.map((e) => e.toEntity()).toList();
}
