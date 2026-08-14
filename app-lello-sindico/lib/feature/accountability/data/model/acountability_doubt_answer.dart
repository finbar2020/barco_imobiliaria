import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_doubt_answer.dart';

part 'acountability_doubt_answer.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountabilityDoubtAnswerModel {
  String id;
  DateTime date;
  String type;
  String commentary;
  bool ppc;
  bool await;

  AccountabilityDoubtAnswerModel(
      {required this.id,
      required this.date,
      required this.type,
      required this.commentary,
      required this.ppc,
      required this.await});

  factory AccountabilityDoubtAnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AccountabilityDoubtAnswerModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccountabilityDoubtAnswerModelToJson(this);

  static AccountabilityDoubtAnswerModel fromEntity(
          AccountabilityDoubtAnswer entity) =>
      (AccountabilityDoubtAnswerModel(
        id: entity.id,
        date: entity.date,
        type: entity.type,
        commentary: entity.commentary,
        ppc: entity.ppc,
        await: entity.await,
      ));

  AccountabilityDoubtAnswer toEntity() => AccountabilityDoubtAnswer(
        id: this.id,
        date: this.date,
        type: this.type,
        commentary: this.commentary,
        ppc: this.ppc,
        await: this.await,
      );
}
