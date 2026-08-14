class AccessControlDate {
  int? hour;
  int? minute;
  int? aecond;
  int? nano;

  AccessControlDate({
    this.hour,
    this.minute,
    this.aecond,
    this.nano,
  });

  @override
  String toString() {
    return 'AccessControlDate(hour: $hour, minute: $minute, aecond: $aecond, nano: $nano)';
  }
}
