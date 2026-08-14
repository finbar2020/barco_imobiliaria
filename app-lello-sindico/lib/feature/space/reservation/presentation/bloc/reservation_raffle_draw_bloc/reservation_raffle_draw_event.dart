import 'package:essentials/essentials.dart';

abstract class ReservationRaffleDrawEvent extends Equatable {
  const ReservationRaffleDrawEvent();

  @override
  List<Object?> get props => [];
}

class ReservationRaffleDrawLoadEvent extends ReservationRaffleDrawEvent {
  final String condominiumId;
  final String reservationId;
  final String spaceId;

  const ReservationRaffleDrawLoadEvent(
      {required this.reservationId,
      required this.condominiumId,
      required this.spaceId});

  @override
  List<Object?> get props => [condominiumId, reservationId, spaceId];
}

class ReservationRaffleDrawExecuteEvent extends ReservationRaffleDrawEvent {
  const ReservationRaffleDrawExecuteEvent();
}
