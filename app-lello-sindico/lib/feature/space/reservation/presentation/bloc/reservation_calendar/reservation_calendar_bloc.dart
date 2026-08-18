import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_event.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';

abstract class ReservationCalendarBloc
    extends Bloc<ReservationCalendarEvent, ReservationCalendarState> {
  ReservationCalendarBloc(ReservationCalendarState initialState)
      : super(initialState);
  void dispose();
  void beginLoad(String spaceId);
  void beginLoadHours(DateTime date, String unitId, String spaceId);
  beginSendRegistration(
    String spaceId,
    Space space,
    String unitId,
    DateTime startReservationDate,
    DateTime endReservationDate,
  );

  void beginLoadCalendarHistory();
  void deleteReservation(String reservationId, String reservationType);

  DateTime getLastDay();
  DateTime getFirstDay();
}
