class ReservationFilter {
  DateTime? from;
  DateTime? to;
  DateTime? expirationFrom;
  DateTime? expirationTo;
  String? spaceId;
  String? unitId;
  String? status;

  ReservationFilter copy() {
    return ReservationFilter()
      ..from = this.from
      ..to = this.to
      ..expirationFrom = this.expirationFrom
      ..expirationTo = this.expirationTo
      ..spaceId = this.spaceId
      ..unitId = this.unitId
      ..status = this.status;
  }
}
