import 'package:essentials/essentials.dart';

abstract class TimesheetMenuEvent extends Equatable {
  const TimesheetMenuEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetMenuLoadEvent extends TimesheetMenuEvent {
  final String? condominiumId;

  const TimesheetMenuLoadEvent({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class TimesheetRequestEvent extends TimesheetMenuEvent {
  final String? condominiumId;

  const TimesheetRequestEvent({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}
