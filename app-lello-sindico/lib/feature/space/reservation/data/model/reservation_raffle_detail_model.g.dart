// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_raffle_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRaffleDetailModel _$ReservationRaffleDetailModelFromJson(
        Map<String, dynamic> json) =>
    ReservationRaffleDetailModel()
      ..signUpLimitDate = json['sign_up_limit_date'] == null
          ? null
          : DateTime.parse(json['sign_up_limit_date'] as String)
      ..raffleDate = json['raffle_date'] == null
          ? null
          : DateTime.parse(json['raffle_date'] as String)
      ..participantType = json['participant_type'] as String?
      ..participantUnits = (json['participant_units'] as List<dynamic>?)
          ?.map((e) => UnitModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..participantGroups = (json['participant_groups'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..participantResidents = (json['participant_residents'] as List<dynamic>?)
          ?.map((e) => ResidentModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..space = json['space'] == null
          ? null
          : SpaceModel.fromJson(json['space'] as Map<String, dynamic>)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..dateTo = json['date_to'] == null
          ? null
          : DateTime.parse(json['date_to'] as String)
      ..time = json['time'] == null
          ? null
          : ReservationTimeModel.fromJson(json['time'] as Map<String, dynamic>);

Map<String, dynamic> _$ReservationRaffleDetailModelToJson(
        ReservationRaffleDetailModel instance) =>
    <String, dynamic>{
      'sign_up_limit_date': instance.signUpLimitDate?.toIso8601String(),
      'raffle_date': instance.raffleDate?.toIso8601String(),
      'participant_type': instance.participantType,
      'participant_units': instance.participantUnits,
      'participant_groups': instance.participantGroups,
      'participant_residents': instance.participantResidents,
      'space': instance.space,
      'date': instance.date?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'time': instance.time,
    };
