import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ReservationCalendarState {
  final SpaceCalendarResponse? data;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final List<SpaceAvailableHours>? availableHours;

  DateTime? selectedDay;
  SpaceAvailableHours? selectedHours;
  final String? condominiumId;
  List<ReservationResponse>? reservationResponse;

  ReservationCalendarState(this.data, this.availableHours, this.periodStart,
      this.periodEnd, this.selectedDay, this.selectedHours, this.condominiumId,
      {this.reservationResponse});
}

class DeleteSucessState extends ReservationCalendarState {
  DeleteSucessState(
      SpaceCalendarResponse data,
      List<SpaceAvailableHours> availableHours,
      DateTime periodStart,
      DateTime periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours selectedHours,
      String condominiumId)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarLoadingState extends ReservationCalendarState {
  ReservationCalendarLoadingState(
      SpaceCalendarResponse? data,
      List<SpaceAvailableHours>? availableHours,
      DateTime? periodStart,
      DateTime? periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours? selectedHours,
      String? condominiumId)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarLoadState extends ReservationCalendarState {
  ReservationCalendarLoadState(
      SpaceCalendarResponse? data,
      List<SpaceAvailableHours>? availableHours,
      DateTime? periodStart,
      DateTime? periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours? selectedHours,
      String? condominiumId)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarHoursLoadingState extends ReservationCalendarState {
  ReservationCalendarHoursLoadingState(
      SpaceCalendarResponse? data,
      List<SpaceAvailableHours> availableHours,
      DateTime? periodStart,
      DateTime? periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours? selectedHours,
      String condominiumId)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarLoadFailedState extends ReservationCalendarState {
  final Failure error;
  ReservationCalendarLoadFailedState(
      SpaceCalendarResponse? data,
      List<SpaceAvailableHours> availableHours,
      DateTime? periodStart,
      DateTime? periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours? selectedHours,
      String condominiumId,
      this.error)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationUnitExceededFailedState extends ReservationCalendarState {
  final Failure error;
  ReservationUnitExceededFailedState(
      SpaceCalendarResponse data,
      List<SpaceAvailableHours> availableHours,
      DateTime? periodStart,
      DateTime? periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours? selectedHours,
      String condominiumId,
      this.error)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarLoadedState extends ReservationCalendarState {
  ReservationCalendarLoadedState(
    SpaceCalendarResponse? data,
    List<SpaceAvailableHours> availableHours,
    DateTime? periodStart,
    DateTime? periodEnd,
    DateTime? selectedDay,
    SpaceAvailableHours? selectedHours,
    String condominiumId,
  ) : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarSuccefullCreatedState
    extends ReservationCalendarState {
  ReservationCalendarSuccefullCreatedState(
    SpaceCalendarResponse? data,
    List<SpaceAvailableHours>? availableHours,
    DateTime? periodStart,
    DateTime? periodEnd,
    DateTime? selectedDay,
    SpaceAvailableHours selectedHours,
    String condominiumId,
  ) : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId);
}

class ReservationCalendarHistoryLoadedState extends ReservationCalendarState {
  ReservationCalendarHistoryLoadedState(
      SpaceCalendarResponse data,
      List<SpaceAvailableHours> availableHours,
      DateTime periodStart,
      DateTime periodEnd,
      DateTime? selectedDay,
      SpaceAvailableHours selectedHours,
      String condominiumId,
      List<ReservationResponse> reservationResponse)
      : super(data, availableHours, periodStart, periodEnd, selectedDay,
            selectedHours, condominiumId,
            reservationResponse: reservationResponse);
}
