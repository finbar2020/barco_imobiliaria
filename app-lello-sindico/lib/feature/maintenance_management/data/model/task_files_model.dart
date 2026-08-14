import 'package:essentials/essentials.dart';

part 'task_files_model.g.dart';

@JsonSerializable()
class TaskFilesResponseModel {
  final List<TaskFileModel> files;

  TaskFilesResponseModel({required this.files});

  factory TaskFilesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$TaskFilesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskFilesResponseModelToJson(this);
}

@JsonSerializable()
class TaskFileModel {
  final String id;
  @JsonKey(name: 'task_id')
  final String taskId;
  final String url;
  final String filename;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'author_id')
  final String authorId;
  @JsonKey(name: 'author_name')
  final String? authorName;
  @JsonKey(name: 'author_image_url')
  final String? authorImageUrl;
  @JsonKey(name: 'author_email')
  final String? authorEmail;
  final String extension;

  TaskFileModel({
    required this.id,
    required this.taskId,
    required this.url,
    required this.filename,
    required this.createdAt,
    required this.authorId,
    this.authorName,
    this.authorImageUrl,
    this.authorEmail,
    required this.extension,
  });

  factory TaskFileModel.fromJson(Map<String, dynamic> json) =>
      _$TaskFileModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskFileModelToJson(this);
}
