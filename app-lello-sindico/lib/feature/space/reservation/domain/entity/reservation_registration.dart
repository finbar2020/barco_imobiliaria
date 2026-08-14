import 'package:lello/feature/space/domain/entity/space.dart';

class ReservationRegistration {
  String? spaceId;
  Space? space;
  bool? flagUtilityTerm;
  DateTime? reservationStartDate;
  DateTime? reservationEndDate;
  String? unitId;
  String? reservationType;
  int? idStatus;

  ReservationRegistration(
      {this.flagUtilityTerm,
      this.idStatus,
      this.reservationEndDate,
      this.reservationStartDate,
      this.reservationType,
      this.space,
      this.spaceId,
      this.unitId});
}
