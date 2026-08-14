import 'package:essentials/essentials.dart';

abstract class VacationEvent extends Equatable {
  const VacationEvent();

  @override
  List<Object?> get props => [];
}

class VacationLoadEvent extends VacationEvent {
  final String condominiumId;
  final String employeeId;

  const VacationLoadEvent({
    required this.condominiumId,
    required this.employeeId,
  });

  @override
  List<Object?> get props => [condominiumId, employeeId];
}

class VacationPeriodEvent extends VacationEvent {
  const VacationPeriodEvent();
}

class GetLockedDaysEvent extends VacationEvent {
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;

  const GetLockedDaysEvent({
    required this.employeeId,
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [employeeId, startDate, endDate];
}
