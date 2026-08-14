class TimesheetMonthResumeEntity {
  final int extraHours;
  final int delays;
  final int vacations;
  final int fouls;
  final int extraHoursHundred;
  final int otherExtraHours;

  TimesheetMonthResumeEntity({
    this.extraHours = 0,
    this.delays = 0,
    this.vacations = 0,
    this.fouls = 0,
    this.extraHoursHundred = 0,
    this.otherExtraHours = 0,
  });

  bool get showExtraHours => extraHoursHundred != 0 && otherExtraHours != 0;
}
