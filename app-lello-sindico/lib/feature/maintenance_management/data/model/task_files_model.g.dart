// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_files_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskFilesResponseModel _$TaskFilesResponseModelFromJson(
        Map<String, dynamic> json) =>
    TaskFilesResponseModel(
      files: (json['files'] as List<dynamic>)
          .map((e) => TaskFileModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TaskFilesResponseModelToJson(
        TaskFilesResponseModel instance) =>
    <String, dynamic>{
      'files': instance.files,
    };

TaskFileModel _$TaskFileModelFromJson(Map<String, dynamic> json) =>
    TaskFileModel(
      id: json['id'] as String,
      taskId: json['task_id'] as String,
      url: json['url'] as String,
      filename: json['filename'] as String,
      createdAt: json['created_at'] as String,
      authorId: json['author_id'] as String,
      authorName: json['author_name'] as String?,
      authorImageUrl: json['author_image_url'] as String?,
      authorEmail: json['author_email'] as String?,
      extension: json['extension'] as String,
    );

Map<String, dynamic> _$TaskFileModelToJson(TaskFileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'task_id': instance.taskId,
      'url': instance.url,
      'filename': instance.filename,
      'created_at': instance.createdAt,
      'author_id': instance.authorId,
      'author_name': instance.authorName,
      'author_image_url': instance.authorImageUrl,
      'author_email': instance.authorEmail,
      'extension': instance.extension,
    };
