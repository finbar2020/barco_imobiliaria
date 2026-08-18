import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_day_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/calendar_days_response_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_event.dart';
import 'package:lello/feature/maintenance_management/presentation/agenda/bloc/calendar_indicators_state.dart';

void main() {
  test('eventos e estados expõem igualdade e toString', () {
    final load = LoadCalendarIndicatorsEvent(month: 1, year: 2026);
    expect(load, LoadCalendarIndicatorsEvent(month: 1, year: 2026));
    expect(load.toString(), contains('month: 1'));
    expect(
      RefreshCalendarIndicatorsEvent(month: 2, year: 2026).toString(),
      contains('year: 2026'),
    );
    expect(ClearCalendarIndicatorsCacheEvent().toString(), contains('Clear'));

    const days = CalendarDaysResponseEntity(
      month: 1,
      year: 2026,
      days: [CalendarDayEntity(day: 10, hasEvents: true, taskCount: 2)],
    );
    final loaded = CalendarIndicatorsLoadedState(calendarData: days);
    expect(loaded, CalendarIndicatorsLoadedState(calendarData: days));
    expect(loaded.hashCode, isNonZero);
    expect(loaded.toString(), contains('days: 1'));
    expect(loaded.hasTasks(10), isTrue);
    expect(loaded.getTaskCount(10), 2);

    final empty = CalendarIndicatorsEmptyState(month: 1, year: 2026);
    expect(empty, CalendarIndicatorsEmptyState(month: 1, year: 2026));
    expect(empty.toString(), contains('month: 1'));

    final error = CalendarIndicatorsErrorState(
      message: 'x',
      month: 1,
      year: 2026,
    );
    expect(
      error,
      CalendarIndicatorsErrorState(message: 'x', month: 1, year: 2026),
    );
    expect(error.toString(), contains('x'));
    expect(CalendarIndicatorsInitialState().toString(), contains('Initial'));
    expect(CalendarIndicatorsLoadingState().toString(), contains('Loading'));
  });
}
