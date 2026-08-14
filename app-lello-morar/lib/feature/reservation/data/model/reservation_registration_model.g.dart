// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRegistrationModel _$ReservationRegistrationModelFromJson(
        Map<String, dynamic> json) =>
    ReservationRegistrationModel(
      spaceId: json['space_id'] as String?,
      space: json['space'] == null
          ? null
          : SpaceModel.fromJson(json['space'] as Map<String, dynamic>),
      flagUtilityTerm: json['flag_utility_term'] as bool?,
      reservationStartDate: json['reservation_start_date'] as String?,
      reservationEndDate: json['reservation_end_date'] as String?,
      unitId: json['unit_id'] as String?,
      reservationType: json['reservation_type'] as String?,
      idStatus: (json['id_status'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReservationRegistrationModelToJson(
        ReservationRegistrationModel instance) =>
    <String, dynamic>{
      'space_id': instance.spaceId,
      'space': instance.space,
      'flag_utility_term': instance.flagUtilityTerm,
      'reservation_start_date': instance.reservationStartDate,
      'reservation_end_date': instance.reservationEndDate,
      'unit_id': instance.unitId,
      'reservation_type': instance.reservationType,
      'id_status': instance.idStatus,
    };
