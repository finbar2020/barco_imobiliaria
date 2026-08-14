class TimesheetReportDay {
  int? totalAmount;
  int? presentAmount;
  int? dayOffAmount;
  int? vacationAmount;
  int? unmarkedAmount;
  int? shiftNotStartedAmount;
  int? attestationAmount;
  int? clearanceAmount;
  int? extraHours;

  TimesheetReportDay(
      {this.totalAmount,
      this.presentAmount,
      this.dayOffAmount,
      this.vacationAmount,
      this.unmarkedAmount,
      this.shiftNotStartedAmount,
      this.attestationAmount,
      this.clearanceAmount,
      this.extraHours});
}
