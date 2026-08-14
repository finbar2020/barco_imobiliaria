import 'package:essentials/essentials.dart';
import 'origin_answer_model.dart';

part 'child_task_model.g.dart';

@JsonSerializable()
class ChildTaskModel {
  final String? scheduleEventId;
  final OriginAnswerModel? originAnswer;

  ChildTaskModel({
    this.scheduleEventId,
    this.originAnswer,
  });

  factory ChildTaskModel.fromJson(Map<String, dynamic> json) =>
      _$ChildTaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChildTaskModelToJson(this);
}
