import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/space/domain/entity/reservation_payment_method.dart';
import 'package:lello/feature/space/domain/entity/reservation_value_type.dart';

class ReservationRule {
  bool? blockedForSettlers;
  bool? blockedForDefaulters;
  String? blockageArticle;
  bool? allDay;
  int? openHour;
  int? closeHour;
  int? defaultDuration;
  int? timeBetweenReservations;
  ReservationLimitation? limitation;
  int? limit;
  bool? sendEmailToManager;
  bool? sendEmailToResident;
  bool? chargeable;
  double? price;
  ReservationPaymentMethod? paymentMethod;
  ReservationValueType? valueType;
  int? cancellationLimit;
  int? expirationDays;
  Account? account;
  int? reservationRangeMinimum;
  int? reservationRangeMaximum;
}

enum ReservationLimitation {
  none,
  day,
  month,
  year,
  week_day,
}
