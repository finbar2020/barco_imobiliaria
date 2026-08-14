import 'package:json_annotation/json_annotation.dart';

part 'submit_form_request_model.g.dart';

@JsonSerializable(explicitToJson: true)
class FileContentModel {
  @JsonKey(name: 'content_type')
  final String contentType;
  @JsonKey(name: 'local_uri')
  final String localUri;
  final String name;
  @JsonKey(name: 'upload_task_id')
  final String uploadTaskId;
  @JsonKey(name: 'firebase_ref')
  final String firebaseRef;
  @JsonKey(name: 'device_id')
  final String deviceId;
  final String bucket;
  @JsonKey(name: 'fail_count')
  final int failCount;
  final int size;
  final String url;

  FileContentModel({
    required this.contentType,
    required this.localUri,
    required this.name,
    required this.uploadTaskId,
    required this.firebaseRef,
    required this.deviceId,
    required this.bucket,
    required this.failCount,
    required this.size,
    required this.url,
  });

  factory FileContentModel.fromJson(Map<String, dynamic> json) =>
      _$FileContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$FileContentModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnswerModel {
  final String type;
  @JsonKey(name: 'question_id')
  final String questionId;
  final dynamic content; // Pode ser null, String, List<String>, FileContentModel, etc

  AnswerModel({
    required this.type,
    required this.questionId,
    this.content,
  });

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SubmitFormRequestModel {
  @JsonKey(name: 'event_id')
  final String eventId;
  final Map<String, AnswerModel> answers;

  SubmitFormRequestModel({
    required this.eventId,
    required this.answers,
  });

  factory SubmitFormRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SubmitFormRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubmitFormRequestModelToJson(this);
}
