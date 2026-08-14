import 'package:essentials/essentials.dart';

abstract class ReservationFilterEvent extends Equatable {
  const ReservationFilterEvent();

  @override
  List<Object?> get props => [];
}

class ReservationFilterLoadEvent extends ReservationFilterEvent {
  final String condominiumId;

  const ReservationFilterLoadEvent({required this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}
