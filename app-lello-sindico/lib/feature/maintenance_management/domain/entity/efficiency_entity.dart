class EfficiencyItemEntity {
  final String id;
  final String name;
  final int done;
  final int notStarted;
  final int draft;

  EfficiencyItemEntity({
    required this.id,
    required this.name,
    required this.done,
    required this.notStarted,
    required this.draft,
  });
}

class TaskSummaryEntity {
  final int total;
  final int done;
  final int notStarted;
  final int draft;
  final int pending;

  TaskSummaryEntity({
    required this.total,
    required this.done,
    required this.notStarted,
    required this.draft,
    this.pending = 0, // Valor padrão para não quebrar fluxos existentes
  });
}

class EfficiencyResponseEntity {
  final List<EfficiencyItemEntity> efficiencyResponse;
  final TaskSummaryEntity taskSummary;

  EfficiencyResponseEntity({
    required this.efficiencyResponse,
    required this.taskSummary,
  });
}
