import 'package:json_annotation/json_annotation.dart';

part 'event_details_model.g.dart';

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class EventDetailsModel {
  final String id;
  final LastContentAnswersModel? lastContentAnswers;
  final ParentScheduleEventModel? parentScheduleEvent;

  EventDetailsModel({
    required this.id,
    this.lastContentAnswers,
    this.parentScheduleEvent,
  });

  factory EventDetailsModel.fromJson(Map<String, dynamic> json) =>
      _$EventDetailsModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventDetailsModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class LastContentAnswersModel {
  final String formularyId;
  final String? deletedAt;
  final String createdAt;
  final String? finishedAt;
  final String? partnerId;
  final String? authorId;
  final String updatedAt;
  final String? localId;
  final String status;
  final String taskId;
  final String? responsibleId;
  final String? responsibleType;
  final String? responsibleName;
  final FormularyModel? formulary; // Nullable - pode vir null da API

  LastContentAnswersModel({
    required this.formularyId,
    this.deletedAt,
    required this.createdAt,
    this.finishedAt,
    this.partnerId,
    this.authorId,
    required this.updatedAt,
    this.localId,
    required this.status,
    required this.taskId,
    this.responsibleId,
    this.responsibleType,
    this.responsibleName,
    this.formulary, // Nullable
  });

  factory LastContentAnswersModel.fromJson(Map<String, dynamic> json) =>
      _$LastContentAnswersModelFromJson(json);

  Map<String, dynamic> toJson() => _$LastContentAnswersModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class FormularyModel {
  final String id;
  final String name;
  final int position;
  final String procedureId;
  final bool enabled;
  final String? description;
  final String createdAt;
  final String updatedAt;
  final List<QuestionModel> questions;

  FormularyModel({
    required this.id,
    required this.name,
    required this.position,
    required this.procedureId,
    required this.enabled,
    this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.questions,
  });

  factory FormularyModel.fromJson(Map<String, dynamic> json) =>
      _$FormularyModelFromJson(json);

  Map<String, dynamic> toJson() => _$FormularyModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class QuestionModel {
  final String id;
  final String name;
  final int position;
  final String formularyId;
  final bool hidden;
  final bool required;
  final String createdAt;
  final String updatedAt;
  final String fieldType;
  final List<OptionModel>? options;
  final List<ExpressionModel>? expressions;

  QuestionModel({
    required this.id,
    required this.name,
    required this.position,
    required this.formularyId,
    required this.hidden,
    required this.required,
    required this.createdAt,
    required this.updatedAt,
    required this.fieldType,
    this.options,
    this.expressions,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class OptionModel {
  final String id;
  final String name;
  final int position;
  final String questionId;
  final String createdAt;
  final String updatedAt;

  OptionModel({
    required this.id,
    required this.name,
    required this.position,
    required this.questionId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OptionModel.fromJson(Map<String, dynamic> json) =>
      _$OptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$OptionModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ExpressionModel {
  final String id;
  final List<FactorModel> factors;

  ExpressionModel({
    required this.id,
    required this.factors,
  });

  factory ExpressionModel.fromJson(Map<String, dynamic> json) =>
      _$ExpressionModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExpressionModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class FactorModel {
  final String targetValue;
  final String originId;
  final String comparisonType;

  FactorModel({
    required this.targetValue,
    required this.originId,
    required this.comparisonType,
  });

  factory FactorModel.fromJson(Map<String, dynamic> json) =>
      _$FactorModelFromJson(json);

  Map<String, dynamic> toJson() => _$FactorModelToJson(this);
}

@JsonSerializable(explicitToJson: true, fieldRename: FieldRename.snake)
class ParentScheduleEventModel {
  final String id;

  ParentScheduleEventModel({
    required this.id,
  });

  factory ParentScheduleEventModel.fromJson(Map<String, dynamic> json) =>
      _$ParentScheduleEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentScheduleEventModelToJson(this);
}
