abstract class ReservationFilterEvent {}

class ReservationFilterLoadEvent extends ReservationFilterEvent {
  final String condominiumId;
  ReservationFilterLoadEvent({required this.condominiumId});
}
