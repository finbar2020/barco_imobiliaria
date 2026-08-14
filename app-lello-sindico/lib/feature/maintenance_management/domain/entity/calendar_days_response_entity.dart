import 'calendar_day_entity.dart';

/// Resposta da API com dados do calendário contendo indicadores de dias com tarefas
class CalendarDaysResponseEntity {
  /// Mês consultado (1-12)
  final int month;

  /// Ano consultado
  final int year;

  /// Lista de dias que possuem tarefas agendadas
  final List<CalendarDayEntity> days;

  const CalendarDaysResponseEntity({
    required this.month,
    required this.year,
    required this.days,
  });

  /// Verifica se um dia específico possui tarefas
  bool hasTasks(int day) {
    return days
        .any((calendarDay) => calendarDay.day == day && calendarDay.hasEvents);
  }

  /// Obtém a quantidade de tarefas em um dia específico
  int getTaskCount(int day) {
    final calendarDay = days.firstWhere(
      (calendarDay) => calendarDay.day == day,
      orElse: () =>
          const CalendarDayEntity(day: 0, hasEvents: false, taskCount: 0),
    );
    return calendarDay.taskCount;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDaysResponseEntity &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          year == other.year &&
          days == other.days;

  @override
  int get hashCode => month.hashCode ^ year.hashCode ^ days.hashCode;

  @override
  String toString() {
    return 'CalendarDaysResponseEntity(month: $month, year: $year, days: ${days.length})';
  }
}
