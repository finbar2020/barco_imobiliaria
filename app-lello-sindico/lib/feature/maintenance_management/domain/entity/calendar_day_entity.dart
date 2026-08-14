/// Representa um dia do calendário com informações sobre tarefas agendadas
class CalendarDayEntity {
  /// Dia do mês (1-31)
  final int day;

  /// Indica se o dia possui eventos/tarefas
  final bool hasEvents;

  /// Quantidade de tarefas agendadas no dia
  final int taskCount;

  const CalendarDayEntity({
    required this.day,
    required this.hasEvents,
    required this.taskCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDayEntity &&
          runtimeType == other.runtimeType &&
          day == other.day &&
          hasEvents == other.hasEvents &&
          taskCount == other.taskCount;

  @override
  int get hashCode => day.hashCode ^ hasEvents.hashCode ^ taskCount.hashCode;

  @override
  String toString() {
    return 'CalendarDayEntity(day: $day, hasEvents: $hasEvents, taskCount: $taskCount)';
  }
}
