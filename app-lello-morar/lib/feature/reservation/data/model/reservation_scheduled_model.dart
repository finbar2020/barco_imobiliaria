import 'package:essentials/enum/enum_serializer.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/domain/entity/reservatio_chargin.dart';
import 'package:morar/feature/reservation/domain/entity/reservation_scheduled.dart';

part 'reservation_scheduled_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ReservationScheduledModel {
  String? areaId;
  int? id;
  String? cancelingDate;
  String? inclusionDate;
  String? sendedEmailPaidBilletDate;
  String? area;
  int? flagUtitlityTerm;
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
  String? flagChargingStatus;
  double? billetValue;
  DateTime? billetPeriod;
  String? billetSituation;
  int? billetInvoice;
  String? billetCode;
  String? canCancelUntil;

  ReservationScheduledModel({
    this.areaId,
    this.id,
    this.cancelingDate,
    this.inclusionDate,
    this.sendedEmailPaidBilletDate,
    this.area,
    this.flagUtitlityTerm,
    this.reservationValue,
    this.startReservationDate,
    this.endReservationDate,
    this.observations,
    this.unitId,
    this.unitName,
    this.reservationTypeDate,
    this.receipt,
    this.emailSendDate,
    this.updateDate,
    this.userAlteration,
    this.reference,
    this.reservationType,
    this.idStatus,
    this.flagChargingForm,
    this.reservationTypeDescription,
    this.charginFormDescription,
    this.idStatusDecription,
    this.canCancelUntil,
  });

  factory ReservationScheduledModel.fromJson(Map<String, dynamic> json) =>
      _$ReservationScheduledModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationScheduledModelToJson(this);

  static ReservationScheduledModel? fromEntity(ReservationScheduled? entity) =>
      entity == null
          ? null
          : (ReservationScheduledModel()
            ..areaId = entity.areaId
            ..id = entity.id
            ..cancelingDate = entity.cancelingDate
            ..inclusionDate = entity.inclusionDate
            ..sendedEmailPaidBilletDate = entity.sendedEmailPaidBilletDate
            ..area = entity.area
            ..flagUtitlityTerm = entity.flagUtitlityTerm
            ..reservationValue = entity.reservationValue
            ..startReservationDate = entity.startReservationDate
            ..endReservationDate = entity.endReservationDate
            ..observations = entity.observations
            ..unitId = entity.unitId
            ..unitName = entity.unitName
            ..reservationTypeDate = entity.reservationTypeDate
            ..receipt = entity.receipt
            ..emailSendDate = entity.emailSendDate
            ..updateDate = entity.updateDate
            ..userAlteration = entity.userAlteration
            ..reference = entity.reference
            ..reservationType = entity.reservationType
            ..idStatus = entity.idStatus
            ..flagChargingForm = enumToString(entity.flagChargingForm)
            ..reservationTypeDescription = entity.reservationTypeDescription
            ..charginFormDescription =
                enumToString(entity.charginFormDescription)
            ..idStatusDecription = entity.idStatusDecription
            ..flagChargingStatus = entity.flagChargingStatus
            ..billetValue = entity.billetValue
            ..billetPeriod = entity.billetPeriod
            ..billetSituation = entity.billetSituation
            ..billetInvoice = entity.billetInvoice
            ..billetCode = entity.billetCode
            ..canCancelUntil = entity.canCancelUntil);

  ReservationScheduled toEntity() => ReservationScheduled()
    ..areaId = this.areaId
    ..id = this.id
    ..cancelingDate = this.cancelingDate
    ..inclusionDate = this.inclusionDate
    ..sendedEmailPaidBilletDate = this.sendedEmailPaidBilletDate
    ..area = this.area
    ..flagUtitlityTerm = this.flagUtitlityTerm
    ..reservationValue = this.reservationValue
    ..startReservationDate = this.startReservationDate
    ..endReservationDate = this.endReservationDate
    ..observations = this.observations
    ..unitId = this.unitId
    ..unitName = this.unitName
    ..reservationTypeDate = this.reservationTypeDate
    ..receipt = this.receipt
    ..emailSendDate = this.emailSendDate
    ..updateDate = this.updateDate
    ..userAlteration = this.userAlteration
    ..reference = this.reference
    ..reservationType = this.reservationType
    ..idStatus = this.idStatus
    ..flagChargingForm = stringToEnum(
        ReservationCharging.values, this.flagChargingForm?.toLowerCase())
    ..reservationTypeDescription = this.reservationTypeDescription
    ..charginFormDescription = stringToEnum(
        ReservationCharging.values, this.charginFormDescription?.toLowerCase())
    ..idStatusDecription = this.idStatusDecription
    ..flagChargingStatus = this.flagChargingStatus
    ..billetValue = this.billetValue
    ..billetPeriod = this.billetPeriod
    ..billetSituation = this.billetSituation
    ..billetInvoice = this.billetInvoice
    ..billetCode = this.billetCode
    ..canCancelUntil = this.canCancelUntil;
}
