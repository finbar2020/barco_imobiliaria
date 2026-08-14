// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_raffle_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRaffleDataModel _$ReservationRaffleDataModelFromJson(
        Map<String, dynamic> json) =>
    ReservationRaffleDataModel(
      participants: (json['participants'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    )
      ..signUpLimitDate = json['sign_up_limit_date'] == null
          ? null
          : DateTime.parse(json['sign_up_limit_date'] as String)
      ..raffleDate = json['raffle_date'] == null
          ? null
          : DateTime.parse(json['raffle_date'] as String)
      ..date =
          json['date'] == null ? null : DateTime.parse(json['date'] as String)
      ..dateTo = json['date_to'] == null
          ? null
          : DateTime.parse(json['date_to'] as String)
      ..participantType = json['participant_type'] as String?;

Map<String, dynamic> _$ReservationRaffleDataModelToJson(
        ReservationRaffleDataModel instance) =>
    <String, dynamic>{
      'sign_up_limit_date': instance.signUpLimitDate?.toIso8601String(),
      'raffle_date': instance.raffleDate?.toIso8601String(),
      'date': instance.date?.toIso8601String(),
      'date_to': instance.dateTo?.toIso8601String(),
      'participant_type': instance.participantType,
      'participants': instance.participants,
    };
