// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_raffle_result_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRaffleResultModel _$ReservationRaffleResultModelFromJson(
        Map<String, dynamic> json) =>
    ReservationRaffleResultModel()
      ..winner = json['winner'] == null
          ? null
          : ResidentModel.fromJson(json['winner'] as Map<String, dynamic>);

Map<String, dynamic> _$ReservationRaffleResultModelToJson(
        ReservationRaffleResultModel instance) =>
    <String, dynamic>{
      'winner': instance.winner,
    };
