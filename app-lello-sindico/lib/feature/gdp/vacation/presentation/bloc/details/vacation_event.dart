abstract class VacationEvent {}

class VacationLoadEvent extends VacationEvent {
  final String condominiumId;
  final String employeeId;
  VacationLoadEvent({required this.condominiumId, required this.employeeId});
}

class VacationPeriodEvent extends VacationEvent {}

class GetLockedDaysEvent extends VacationEvent {
  final String employeeId;
  final DateTime startDate;
  final DateTime endDate;

  GetLockedDaysEvent(
      {required this.employeeId,
      required this.startDate,
      required this.endDate});
}
