import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationChangeCalendarState {
  final List<Unit>? unitsList;

  ReservationChangeCalendarState({this.unitsList});
}

class ReservationChangeCalendarEmptyState
    extends ReservationChangeCalendarState {}

class ReservationChangeCalendarLoadingState
    extends ReservationChangeCalendarState {}

class ReservationChangeCalendarLoadedState
    extends ReservationChangeCalendarState {}

class ReservationChangeCalendarFailedState
    extends ReservationChangeCalendarState {}

class ListUnitsLoadingState extends ReservationChangeCalendarState {}

class ListUnitsLoadedState extends ReservationChangeCalendarState {
  final List<Unit>? unitsList;
  ListUnitsLoadedState({this.unitsList}) : super(unitsList: unitsList);
}

class ListUnitsFailedState extends ReservationChangeCalendarState {}
