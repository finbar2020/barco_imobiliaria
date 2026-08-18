import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_state.dart';

abstract class ReservationChangeCalendarBloc extends Bloc<
    ReservationChangeCalendarEvent, ReservationChangeCalendarState> {
  ReservationChangeCalendarBloc(ReservationChangeCalendarState initialState)
      : super(initialState);
}
