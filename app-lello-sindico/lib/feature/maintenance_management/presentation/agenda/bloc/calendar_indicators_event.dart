import '../../../domain/entity/filter_options_entity.dart';

abstract class CalendarIndicatorsEvent {}

class LoadCalendarIndicatorsEvent extends CalendarIndicatorsEvent {
  final int month;
  final int year;
  final FilterOptionsEntity? appliedFilters;

  LoadCalendarIndicatorsEvent({
    required this.month,
    required this.year,
    this.appliedFilters,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LoadCalendarIndicatorsEvent &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          year == other.year &&
          appliedFilters == other.appliedFilters;

  @override
  int get hashCode => month.hashCode ^ year.hashCode ^ appliedFilters.hashCode;

  @override
  String toString() =>
      'LoadCalendarIndicatorsEvent(month: $month, year: $year, appliedFilters: $appliedFilters)';
}

class RefreshCalendarIndicatorsEvent extends CalendarIndicatorsEvent {
  final int month;
  final int year;
  final FilterOptionsEntity? appliedFilters;

  RefreshCalendarIndicatorsEvent({
    required this.month,
    required this.year,
    this.appliedFilters,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RefreshCalendarIndicatorsEvent &&
          runtimeType == other.runtimeType &&
          month == other.month &&
          year == other.year &&
          appliedFilters == other.appliedFilters;

  @override
  int get hashCode => month.hashCode ^ year.hashCode ^ appliedFilters.hashCode;

  @override
  String toString() =>
      'RefreshCalendarIndicatorsEvent(month: $month, year: $year, appliedFilters: $appliedFilters)';
}

class ClearCalendarIndicatorsCacheEvent extends CalendarIndicatorsEvent {
  @override
  String toString() => 'ClearCalendarIndicatorsCacheEvent';
}
