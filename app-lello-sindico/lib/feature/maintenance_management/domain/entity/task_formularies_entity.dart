class TaskFormulariesResponseEntity {
  final List<TaskFormularyEntity> formularies;

  TaskFormulariesResponseEntity({required this.formularies});
}

class TaskFormularyEntity {
  final String? id;
  final String name;
  final String? responsibleName;
  final String status;
  final String? eventId;
  final int position;
  final String? authorId;
  final String? maxCreatedAt;
  final String? finishedAt;
  final bool? canStart;

  TaskFormularyEntity({
    this.id,
    required this.name,
    this.responsibleName,
    required this.status,
    this.eventId,
    required this.position,
    this.authorId,
    this.maxCreatedAt,
    this.finishedAt,
    this.canStart,
  });
}
