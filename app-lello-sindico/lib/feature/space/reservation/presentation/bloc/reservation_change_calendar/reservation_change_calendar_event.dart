import 'package:essentials/essentials.dart';

abstract class ReservationChangeCalendarEvent extends Equatable {
  const ReservationChangeCalendarEvent();

  @override
  List<Object?> get props => [];
}

class GetListUnitsEvent extends ReservationChangeCalendarEvent {
  const GetListUnitsEvent();
}
