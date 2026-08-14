// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_rule_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationRuleModel _$ReservationRuleModelFromJson(
        Map<String, dynamic> json) =>
    ReservationRuleModel(
      blockedForSettlers: json['blocked_for_settlers'] as bool?,
      blockedForDefaulters: json['blocked_for_defaulters'] as bool?,
      blockageArticle: json['blockage_article'] as String?,
      allDay: json['all_day'] as bool?,
      openHour: (json['open_hour'] as num?)?.toInt(),
      closeHour: (json['close_hour'] as num?)?.toInt(),
      defaultDuration: (json['default_duration'] as num?)?.toInt(),
      timeBetweenReservations:
          (json['time_between_reservations'] as num?)?.toInt(),
      limitation: json['limitation'] as String?,
      limit: (json['limit'] as num?)?.toInt(),
      sendEmailToManager: json['send_email_to_manager'] as bool?,
      sendEmailToResident: json['send_email_to_resident'] as bool?,
      chargeable: json['chargeable'] as bool?,
      price: (json['price'] as num?)?.toDouble(),
      percentageTax: (json['percentage_tax'] as num?)?.toDouble(),
      paymentMethod: json['payment_method'] as String?,
      cancellationLimit: (json['cancellation_limit'] as num?)?.toInt(),
      expirationDays: (json['expiration_days'] as num?)?.toInt(),
      reservationRangeMinimum:
          (json['reservation_range_minimum'] as num?)?.toInt(),
      reservationRangeMaximum:
          (json['reservation_range_maximum'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReservationRuleModelToJson(
        ReservationRuleModel instance) =>
    <String, dynamic>{
      'blocked_for_settlers': instance.blockedForSettlers,
      'blocked_for_defaulters': instance.blockedForDefaulters,
      'blockage_article': instance.blockageArticle,
      'all_day': instance.allDay,
      'open_hour': instance.openHour,
      'close_hour': instance.closeHour,
      'default_duration': instance.defaultDuration,
      'time_between_reservations': instance.timeBetweenReservations,
      'limitation': instance.limitation,
      'limit': instance.limit,
      'send_email_to_manager': instance.sendEmailToManager,
      'send_email_to_resident': instance.sendEmailToResident,
      'chargeable': instance.chargeable,
      'price': instance.price,
      'percentage_tax': instance.percentageTax,
      'payment_method': instance.paymentMethod,
      'cancellation_limit': instance.cancellationLimit,
      'expiration_days': instance.expirationDays,
      'reservation_range_minimum': instance.reservationRangeMinimum,
      'reservation_range_maximum': instance.reservationRangeMaximum,
    };
