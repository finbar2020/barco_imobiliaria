abstract class ReservationRaffleDrawEvent {}

class ReservationRaffleDrawLoadEvent extends ReservationRaffleDrawEvent {
  final String condominiumId;
  final String reservationId;
  final String spaceId;

  ReservationRaffleDrawLoadEvent(
      {required this.reservationId,
      required this.condominiumId,
      required this.spaceId});
}

class ReservationRaffleDrawExecuteEvent extends ReservationRaffleDrawEvent {
  ReservationRaffleDrawExecuteEvent();
}
