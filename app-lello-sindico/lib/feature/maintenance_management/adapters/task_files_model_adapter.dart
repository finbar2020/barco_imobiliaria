import '../data/model/task_files_model.dart';
import '../domain/entity/task_files_entity.dart';

class TaskFilesModelAdapter {
  static TaskFilesResponseEntity toEntity(TaskFilesResponseModel model) {
    return TaskFilesResponseEntity(
      files: model.files
          .map((file) => TaskFileEntity(
                id: file.id,
                taskId: file.taskId,
                url: file.url,
                filename: file.filename,
                createdAt: file.createdAt,
                authorId: file.authorId,
                authorName: file.authorName,
                authorImageUrl: file.authorImageUrl,
                authorEmail: file.authorEmail,
                extension: file.extension,
              ))
          .toList(),
    );
  }
}
