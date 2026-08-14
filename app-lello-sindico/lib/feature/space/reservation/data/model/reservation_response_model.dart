import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';

part 'reservation_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationResponseModel {
  int? id;
  String? cancelingDate;
  String? inclusionDate;
  String? sendedEmailPaidBilletDate;
  String? area;
  int? flagUtilityTerm;
  double? reservationValue;
  String? startReservationDate;
  String? endReservationDate;
  String? observations;
  int? unitId;
  String? unitName;
  String? reservationTypeDate;
  String? receipt;
  String? emailSendDate;
  String? updateDate;
  int? userAlteration;
  String? reference;
  String? reservationType;
  int? idStatus;
  String? flagChargingForm;
  String? reservationTypeDescription;
  String? charginFormDescription;
  String? idStatusDecription;
  String? canCancelUntil;
  ReservationResponseModel();

  factory ReservationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationResponseModelToJson(this);

  static ReservationResponseModel? fromEntity(ReservationResponse? entity) =>
      entity == null
          ? null
          : (ReservationResponseModel()
            ..area = entity.area
            ..cancelingDate = entity.cancelingDate
            ..charginFormDescription = entity.charginFormDescription
            ..emailSendDate = entity.emailSendDate
            ..endReservationDate = entity.endReservationDate
            ..flagChargingForm = entity.flagChargingForm
            ..flagUtilityTerm = entity.flagUtilityTerm
            ..id = entity.id
            ..idStatus = entity.idStatus
            ..idStatusDecription = entity.idStatusDecription
            ..unitId = entity.unitId
            ..unitName = entity.unitName
            ..inclusionDate = entity.inclusionDate
            ..observations = entity.observations
            ..receipt = entity.receipt
            ..reference = entity.reference
            ..reservationType = entity.reservationType
            ..reservationTypeDate = entity.reservationTypeDate
            ..reservationTypeDescription = entity.reservationTypeDescription
            ..reservationValue = entity.reservationValue
            ..sendedEmailPaidBilletDate = entity.sendedEmailPaidBilletDate
            ..startReservationDate = entity.startReservationDate
            ..updateDate = entity.updateDate
            ..userAlteration = entity.userAlteration
            ..canCancelUntil = entity.canCancelUntil);

  ReservationResponse toEntity() => ReservationResponse()
    ..area = this.area
    ..cancelingDate = this.cancelingDate
    ..charginFormDescription = this.charginFormDescription
    ..emailSendDate = this.emailSendDate
    ..endReservationDate = this.endReservationDate
    ..flagChargingForm = this.flagChargingForm
    ..flagUtilityTerm = this.flagUtilityTerm
    ..id = this.id
    ..idStatus = this.idStatus
    ..idStatusDecription = this.idStatusDecription
    ..unitName = this.unitName
    ..unitId = this.unitId
    ..inclusionDate = this.inclusionDate
    ..observations = this.observations
    ..receipt = this.receipt
    ..reference = this.reference
    ..reservationType = this.reservationType
    ..reservationTypeDate = this.reservationTypeDate
    ..reservationTypeDescription = this.reservationTypeDescription
    ..reservationValue = this.reservationValue
    ..sendedEmailPaidBilletDate = this.sendedEmailPaidBilletDate
    ..startReservationDate = this.startReservationDate
    ..updateDate = this.updateDate
    ..userAlteration = this.userAlteration
    ..canCancelUntil = this.canCancelUntil;
}
