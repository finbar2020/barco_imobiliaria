import 'package:equatable/equatable.dart';
import '../../../domain/entity/filter_options_entity.dart';

abstract class CalendarIndicatorsEvent extends Equatable {
  const CalendarIndicatorsEvent();

  @override
  List<Object?> get props => [];
}

class LoadCalendarIndicatorsEvent extends CalendarIndicatorsEvent {
  final int month;
  final int year;
  final FilterOptionsEntity? appliedFilters;

  const LoadCalendarIndicatorsEvent({
    required this.month,
    required this.year,
    this.appliedFilters,
  });

  @override
  List<Object?> get props => [month, year, appliedFilters];
}

class RefreshCalendarIndicatorsEvent extends CalendarIndicatorsEvent {
  final int month;
  final int year;
  final FilterOptionsEntity? appliedFilters;

  const RefreshCalendarIndicatorsEvent({
    required this.month,
    required this.year,
    this.appliedFilters,
  });

  @override
  List<Object?> get props => [month, year, appliedFilters];
}

class ClearCalendarIndicatorsCacheEvent extends CalendarIndicatorsEvent {
  const ClearCalendarIndicatorsCacheEvent();
}
