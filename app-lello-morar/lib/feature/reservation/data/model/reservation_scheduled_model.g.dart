// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_scheduled_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationScheduledModel _$ReservationScheduledModelFromJson(
        Map<String, dynamic> json) =>
    ReservationScheduledModel(
      areaId: json['area_id'] as String?,
      id: (json['id'] as num?)?.toInt(),
      cancelingDate: json['canceling_date'] as String?,
      inclusionDate: json['inclusion_date'] as String?,
      sendedEmailPaidBilletDate:
          json['sended_email_paid_billet_date'] as String?,
      area: json['area'] as String?,
      flagUtitlityTerm: (json['flag_utitlity_term'] as num?)?.toInt(),
      reservationValue: (json['reservation_value'] as num?)?.toDouble(),
      startReservationDate: json['start_reservation_date'] as String?,
      endReservationDate: json['end_reservation_date'] as String?,
      observations: json['observations'] as String?,
      unitId: (json['unit_id'] as num?)?.toInt(),
      unitName: json['unit_name'] as String?,
      reservationTypeDate: json['reservation_type_date'] as String?,
      receipt: json['receipt'] as String?,
      emailSendDate: json['email_send_date'] as String?,
      updateDate: json['update_date'] as String?,
      userAlteration: (json['user_alteration'] as num?)?.toInt(),
      reference: json['reference'] as String?,
      reservationType: json['reservation_type'] as String?,
      idStatus: (json['id_status'] as num?)?.toInt(),
      flagChargingForm: json['flag_charging_form'] as String?,
      reservationTypeDescription:
          json['reservation_type_description'] as String?,
      charginFormDescription: json['chargin_form_description'] as String?,
      idStatusDecription: json['id_status_decription'] as String?,
      canCancelUntil: json['can_cancel_until'] as String?,
    )
      ..flagChargingStatus = json['flag_charging_status'] as String?
      ..billetValue = (json['billet_value'] as num?)?.toDouble()
      ..billetPeriod = json['billet_period'] == null
          ? null
          : DateTime.parse(json['billet_period'] as String)
      ..billetSituation = json['billet_situation'] as String?
      ..billetInvoice = (json['billet_invoice'] as num?)?.toInt()
      ..billetCode = json['billet_code'] as String?;

Map<String, dynamic> _$ReservationScheduledModelToJson(
        ReservationScheduledModel instance) =>
    <String, dynamic>{
      'area_id': instance.areaId,
      'id': instance.id,
      'canceling_date': instance.cancelingDate,
      'inclusion_date': instance.inclusionDate,
      'sended_email_paid_billet_date': instance.sendedEmailPaidBilletDate,
      'area': instance.area,
      'flag_utitlity_term': instance.flagUtitlityTerm,
      'reservation_value': instance.reservationValue,
      'start_reservation_date': instance.startReservationDate,
      'end_reservation_date': instance.endReservationDate,
      'observations': instance.observations,
      'unit_id': instance.unitId,
      'unit_name': instance.unitName,
      'reservation_type_date': instance.reservationTypeDate,
      'receipt': instance.receipt,
      'email_send_date': instance.emailSendDate,
      'update_date': instance.updateDate,
      'user_alteration': instance.userAlteration,
      'reference': instance.reference,
      'reservation_type': instance.reservationType,
      'id_status': instance.idStatus,
      'flag_charging_form': instance.flagChargingForm,
      'reservation_type_description': instance.reservationTypeDescription,
      'chargin_form_description': instance.charginFormDescription,
      'id_status_decription': instance.idStatusDecription,
      'flag_charging_status': instance.flagChargingStatus,
      'billet_value': instance.billetValue,
      'billet_period': instance.billetPeriod?.toIso8601String(),
      'billet_situation': instance.billetSituation,
      'billet_invoice': instance.billetInvoice,
      'billet_code': instance.billetCode,
      'can_cancel_until': instance.canCancelUntil,
    };
