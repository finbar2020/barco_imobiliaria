class TimesheetEvent {
  String? id;
  String? registrationNumber;
  String? reference;
  int? minutes;
  String? createdBy;
  bool? flagProcessed;
  String? typeEvent;
  DateTime? effectiveDate;
  DateTime? processDate;
  DateTime? createdDate;
  DateTime? changedDate;

  TimesheetEvent(
      {this.id,
      this.registrationNumber,
      this.reference,
      this.minutes,
      this.createdBy,
      this.flagProcessed,
      this.typeEvent,
      this.effectiveDate,
      this.processDate,
      this.createdDate,
      this.changedDate});
}
