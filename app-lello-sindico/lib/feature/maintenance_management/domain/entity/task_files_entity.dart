class TaskFilesResponseEntity {
  final List<TaskFileEntity> files;

  TaskFilesResponseEntity({required this.files});
}

class TaskFileEntity {
  final String id;
  final String taskId;
  final String url;
  final String filename;
  final String createdAt;
  final String authorId;
  final String? authorName;
  final String? authorImageUrl;
  final String? authorEmail;
  final String extension;

  TaskFileEntity({
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
}
