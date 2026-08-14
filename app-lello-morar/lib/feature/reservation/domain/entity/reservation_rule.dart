import 'package:intl/intl.dart';

class ReservationRule {
  bool? blockedForSettlers;
  bool? blockedForDefaulters;
  String? blockageArticle;
  bool? allDay;
  int? openHour;
  int? closeHour;
  int? defaultDuration;
  int? timeBetweenReservations;
  String? limitation;
  int? limit;
  bool? sendEmailToManager;
  bool? sendEmailToResident;
  bool? chargeable;
  double? price;
  double? percentageTax;
  String? paymentMethod;
  int? cancellationLimit;
  int? expirationDays;
  int? reservationRangeMinimum;
  int? reservationRangeMaximum;

  bool get isBillet => paymentMethod?.toLowerCase() == "billet";
  bool get isQuota => paymentMethod?.toLowerCase() == "quota";
  bool get isGuarantor => paymentMethod?.toLowerCase() == "guarantor";

  String get paymentInfo {
    if(isBillet) return "space_registration_single_bank_slip";
    if(isQuota) return "space_registration_fee_billet";
    if(isGuarantor) return "space_registration_guarantor";
    return '';
  }

  String get workingTime {
    if (allDay == true)
      return "Dia todo";
    else {
      var format = new NumberFormat("00");
      return "Das ${format.format(openHour)}:00 ás ${format.format(closeHour)}:00";
    }
  }

  DateTime get getMaxReservationDate {
    return DateTime.now().add(Duration(
        days: reservationRangeMaximum == null || reservationRangeMaximum == 0
            ? (365)
            : reservationRangeMaximum!));
  }

  DateTime get getMinReservationDate {
    var nowHourzero = DateTime.now();
    nowHourzero = DateTime.utc(
        nowHourzero.year, nowHourzero.month, nowHourzero.day, 0, 0, 0, 0);
    return nowHourzero.add(Duration(
        days: reservationRangeMinimum == null || reservationRangeMinimum == 0
            ? (0)
            : (reservationRangeMinimum!)));
  }
}

enum ReservationLimitation {
  none,
  day,
  month,
  year,
  weekDay,
}
