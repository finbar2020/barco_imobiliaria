// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'submit_form_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileContentModel _$FileContentModelFromJson(Map<String, dynamic> json) =>
    FileContentModel(
      contentType: json['content_type'] as String,
      localUri: json['local_uri'] as String,
      name: json['name'] as String,
      uploadTaskId: json['upload_task_id'] as String,
      firebaseRef: json['firebase_ref'] as String,
      deviceId: json['device_id'] as String,
      bucket: json['bucket'] as String,
      failCount: (json['fail_count'] as num).toInt(),
      size: (json['size'] as num).toInt(),
      url: json['url'] as String,
    );

Map<String, dynamic> _$FileContentModelToJson(FileContentModel instance) =>
    <String, dynamic>{
      'content_type': instance.contentType,
      'local_uri': instance.localUri,
      'name': instance.name,
      'upload_task_id': instance.uploadTaskId,
      'firebase_ref': instance.firebaseRef,
      'device_id': instance.deviceId,
      'bucket': instance.bucket,
      'fail_count': instance.failCount,
      'size': instance.size,
      'url': instance.url,
    };

AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => AnswerModel(
      type: json['type'] as String,
      questionId: json['question_id'] as String,
      content: json['content'],
    );

Map<String, dynamic> _$AnswerModelToJson(AnswerModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'question_id': instance.questionId,
      'content': instance.content,
    };

SubmitFormRequestModel _$SubmitFormRequestModelFromJson(
        Map<String, dynamic> json) =>
    SubmitFormRequestModel(
      eventId: json['event_id'] as String,
      answers: (json['answers'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, AnswerModel.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$SubmitFormRequestModelToJson(
        SubmitFormRequestModel instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'answers': instance.answers.map((k, e) => MapEntry(k, e.toJson())),
    };
