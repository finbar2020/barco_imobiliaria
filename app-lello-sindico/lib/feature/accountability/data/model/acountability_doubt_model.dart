import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/data/model/acountability_doubt_attachments_model.dart';
import 'package:lello/feature/accountability/data/model/acountability_question_model.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_situation.dart';

part 'acountability_doubt_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityDoubtModel {
  String? id;
  String message;
  DoubtSituation questionSituation;
  List<AttachmentsModel> attachments;
  DateTime period;
  DateTime createdAt;
  DateTime updatedAt;
  AccountabilityQuestionTypeModel doubtType;

  AccountabilityDoubtModel({
    required this.id,
    required this.message,
    required this.questionSituation,
    required this.attachments,
    required this.period,
    required this.createdAt,
    required this.updatedAt,
    required this.doubtType,
  });

  factory AccountabilityDoubtModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityDoubtModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountabilityDoubtModelToJson(this);

  static AccountabilityDoubtModel fromEntity(AccountabilityDoubt entity) =>
      (AccountabilityDoubtModel(
          id: entity.id,
          message: entity.message,
          questionSituation: entity.questionSituation,
          period: entity.period,
          attachments: entity.attachments
              .map((e) => AttachmentsModel.fromEntity(e))
              .toList(),
          createdAt: entity.createdAt,
          updatedAt: entity.updatedAt,
          doubtType:
              AccountabilityQuestionTypeModel.fromEntity(entity.doubtType!)));

  AccountabilityDoubt toEntity() => AccountabilityDoubt(
        period: this.period,
      )
        ..id = this.id ?? ""
        ..message = this.message
        ..questionSituation = this.questionSituation
        ..doubtType = this.doubtType.toEntity()
        ..createdAt = this.createdAt
        ..updatedAt = this.updatedAt
        ..attachments = this.attachments.map((e) => e.toEntity()).toList();
}
