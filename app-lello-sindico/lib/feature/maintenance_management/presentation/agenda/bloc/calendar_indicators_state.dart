import '../../../domain/entity/calendar_days_response_entity.dart';

abstract class CalendarIndicatorsState {}

class CalendarIndicatorsInitialState extends CalendarIndicatorsState {
  @override
  String toString() => 'CalendarIndicatorsInitialState';
}

class CalendarIndicatorsLoadingState extends CalendarIndicatorsState {
  @override
  String toString() => 'CalendarIndicatorsLoadingState';
}

class CalendarIndicatorsLoadedState extends CalendarIndicatorsState {
  final CalendarDaysResponseEntity calendarData;

  CalendarIndicatorsLoadedState({
    required this.calendarData,
  });

  bool hasTasks(int day) {
    return calendarData.hasTasks(day);
  }

  int getTaskCount(int day) {
    return calendarData.getTaskCount(day);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarIndicatorsLoadedState &&
          runtimeType == other.runtimeType &&
          calendarData == other.calendarData;

  @override
  int get hashCode => calendarData.hashCode;

  @override
  String toString() =>
      'CalendarIndicatorsLoadedState(month: ${calendarData.month}, year: ${calendarData.year}, days: ${calendarData.days.length})';
}

class CalendarIndicatorsEmptyState extends CalendarIndicatorsState {
  final int month;
  final int year;

  CalendarIndicatorsEmptyState({
    required this.month,
    required this.year,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarIndicatorsEmptyState &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          year == other.year;

  @override
  int get hashCode => month.hashCode ^ year.hashCode;

  @override
  String toString() =>
      'CalendarIndicatorsEmptyState(month: $month, year: $year)';
}

class CalendarIndicatorsErrorState extends CalendarIndicatorsState {
  final String message;
  final int month;
  final int year;

  CalendarIndicatorsErrorState({
    required this.message,
    required this.month,
    required this.year,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarIndicatorsErrorState &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          month == other.month &&
          year == other.year;

  @override
  int get hashCode => message.hashCode ^ month.hashCode ^ year.hashCode;

  @override
  String toString() =>
      'CalendarIndicatorsErrorState(message: $message, month: $month, year: $year)';
}
