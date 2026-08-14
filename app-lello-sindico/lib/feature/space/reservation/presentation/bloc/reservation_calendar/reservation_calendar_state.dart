import 'package:essentials/essentials.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';

abstract class ReservationCalendarState extends Equatable {
  final SpaceCalendarResponse? data;
  final DateTime? periodStart;
  final DateTime? periodEnd;
  final List<SpaceAvailableHours>? availableHours;
  final DateTime? selectedDay;
  final SpaceAvailableHours? selectedHours;
  final String? condominiumId;
  final List<ReservationResponse>? reservationResponse;

  const ReservationCalendarState(
      this.data,
      this.availableHours,
      this.periodStart,
      this.periodEnd,
      this.selectedDay,
      this.selectedHours,
      this.condominiumId,
      {this.reservationResponse});

  @override
  List<Object?> get props => [
        data,
        availableHours,
        periodStart,
        periodEnd,
        selectedDay,
        selectedHours,
        condominiumId,
        reservationResponse,
      ];
}

class DeleteSucessState extends ReservationCalendarState {
  const DeleteSucessState(
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
  const ReservationCalendarLoadingState(
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
  const ReservationCalendarLoadState(
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
  const ReservationCalendarHoursLoadingState(
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

  const ReservationCalendarLoadFailedState(
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

  @override
  List<Object?> get props => [
        data,
        availableHours,
        periodStart,
        periodEnd,
        selectedDay,
        selectedHours,
        condominiumId,
        reservationResponse,
        error,
      ];
}

class ReservationUnitExceededFailedState extends ReservationCalendarState {
  final Failure error;

  const ReservationUnitExceededFailedState(
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

  @override
  List<Object?> get props => [
        data,
        availableHours,
        periodStart,
        periodEnd,
        selectedDay,
        selectedHours,
        condominiumId,
        reservationResponse,
        error,
      ];
}

class ReservationCalendarLoadedState extends ReservationCalendarState {
  const ReservationCalendarLoadedState(
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
  const ReservationCalendarSuccefullCreatedState(
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
  const ReservationCalendarHistoryLoadedState(
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
