import 'package:essentials/essentials.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

abstract class ReservationChangeCalendarState extends Equatable {
  final List<Unit>? unitsList;

  const ReservationChangeCalendarState({this.unitsList});

  @override
  List<Object?> get props => [unitsList];
}

class ReservationChangeCalendarEmptyState
    extends ReservationChangeCalendarState {
  const ReservationChangeCalendarEmptyState({super.unitsList});
}

class ReservationChangeCalendarLoadingState
    extends ReservationChangeCalendarState {
  const ReservationChangeCalendarLoadingState({super.unitsList});
}

class ReservationChangeCalendarLoadedState
    extends ReservationChangeCalendarState {
  const ReservationChangeCalendarLoadedState({super.unitsList});
}

class ReservationChangeCalendarFailedState
    extends ReservationChangeCalendarState {
  const ReservationChangeCalendarFailedState({super.unitsList});
}

class ListUnitsLoadingState extends ReservationChangeCalendarState {
  const ListUnitsLoadingState({super.unitsList});
}

class ListUnitsLoadedState extends ReservationChangeCalendarState {
  const ListUnitsLoadedState({super.unitsList});
}

class ListUnitsFailedState extends ReservationChangeCalendarState {
  const ListUnitsFailedState({super.unitsList});
}
