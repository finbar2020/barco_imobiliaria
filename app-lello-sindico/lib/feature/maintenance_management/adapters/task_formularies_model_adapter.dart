import '../data/model/task_formularies_model.dart';
import '../domain/entity/task_formularies_entity.dart';

class TaskFormulariesModelAdapter {
  static TaskFormulariesResponseEntity toEntity(
      TaskFormulariesResponseModel model) {
    return TaskFormulariesResponseEntity(
      formularies: model.formularies
          .map((formulary) => TaskFormularyEntity(
                id: formulary.id,
                name: formulary.name,
                responsibleName: formulary.responsibleName,
                status: formulary.status,
                eventId: formulary.eventId,
                position: formulary.position,
                authorId: formulary.authorId,
                maxCreatedAt: formulary.maxCreatedAt,
                finishedAt: formulary.finishedAt,
                canStart: formulary.canStart,
              ))
          .toList(),
    );
  }
}
