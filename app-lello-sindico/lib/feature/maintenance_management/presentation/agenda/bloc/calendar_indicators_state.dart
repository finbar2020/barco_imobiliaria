import 'package:equatable/equatable.dart';
import '../../../domain/entity/calendar_days_response_entity.dart';

abstract class CalendarIndicatorsState extends Equatable {
  const CalendarIndicatorsState();

  @override
  List<Object?> get props => [];
}

class CalendarIndicatorsInitialState extends CalendarIndicatorsState {
  const CalendarIndicatorsInitialState();
}

class CalendarIndicatorsLoadingState extends CalendarIndicatorsState {
  const CalendarIndicatorsLoadingState();
}

class CalendarIndicatorsLoadedState extends CalendarIndicatorsState {
  final CalendarDaysResponseEntity calendarData;

  const CalendarIndicatorsLoadedState({
    required this.calendarData,
  });

  bool hasTasks(int day) => calendarData.hasTasks(day);

  int getTaskCount(int day) => calendarData.getTaskCount(day);

  @override
  List<Object?> get props => [calendarData];
}

class CalendarIndicatorsEmptyState extends CalendarIndicatorsState {
  final int month;
  final int year;

  const CalendarIndicatorsEmptyState({
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [month, year];
}

class CalendarIndicatorsErrorState extends CalendarIndicatorsState {
  final String message;
  final int month;
  final int year;

  const CalendarIndicatorsErrorState({
    required this.message,
    required this.month,
    required this.year,
  });

  @override
  List<Object?> get props => [message, month, year];
}
