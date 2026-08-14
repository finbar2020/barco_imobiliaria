import 'package:essentials/essentials.dart';

abstract class VacationGDPEvent extends Equatable {
  const VacationGDPEvent();

  @override
  List<Object?> get props => [];
}

class VacationGDPLoadEvent extends VacationGDPEvent {
  final String condominiumId;
  final String employeeId;

  const VacationGDPLoadEvent(
      {required this.condominiumId, required this.employeeId});

  @override
  List<Object?> get props => [condominiumId, employeeId];
}

class VacationGDPPeriodEvent extends VacationGDPEvent {
  const VacationGDPPeriodEvent();
}

class GetLockedDaysEvent extends VacationGDPEvent {
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;

  const GetLockedDaysEvent(
      {required this.employeeId,
      required this.startDate,
      required this.endDate});

  @override
  List<Object?> get props => [employeeId, startDate, endDate];
}
