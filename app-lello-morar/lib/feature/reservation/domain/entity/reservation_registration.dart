import 'package:morar/feature/reservation/domain/entity/space.dart';

class ReservationRegistration {
  String? spaceId;
  Space? space;
  bool? flagUtilityTerm;
  String? reservationStartDate;
  String? reservationEndDate;
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

  @override
  String toString() {
    return 'ReservationRegistration(spaceId: $spaceId, space: $space, flagUtilityTerm: $flagUtilityTerm, reservationStartDate: $reservationStartDate, reservationEndDate: $reservationEndDate, unitId: $unitId, reservationType: $reservationType, idStatus: $idStatus)';
  }
}
