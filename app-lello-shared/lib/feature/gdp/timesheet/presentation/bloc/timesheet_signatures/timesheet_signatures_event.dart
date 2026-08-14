import 'package:essentials/essentials.dart';

abstract class TimesheetSignaturesEvent extends Equatable {
  const TimesheetSignaturesEvent();

  @override
  List<Object?> get props => [];
}

class TimesheetSignaturesLoadEvent extends TimesheetSignaturesEvent {
  final String? condominiumId;

  const TimesheetSignaturesLoadEvent({this.condominiumId});

  @override
  List<Object?> get props => [condominiumId];
}

class TimesheetSignEvent extends TimesheetSignaturesEvent {
  const TimesheetSignEvent();
}
