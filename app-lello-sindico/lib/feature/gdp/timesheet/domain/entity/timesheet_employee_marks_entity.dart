import 'dart:core';

import 'package:essentials/essentials.dart';

class TimesheetEmployeeMarksEntity {
  final String craNumber;
  final String reference;
  final DateTime referenceDate;
  final String type;
  final String receivedMarking;
  final int occurrenceDuration;
  final bool outOfRadius;
  TimesheetEmployeeMarksEntity(
      {required this.craNumber,
      required this.reference,
      required this.referenceDate,
      required this.type,
      required this.receivedMarking,
      required this.occurrenceDuration,
      required this.outOfRadius});

  String get marks => receivedMarking.isEmpty
      ? "Sem marcação"
      : receivedMarking.replaceAll(";", " - ");

  String convertExtraHours() {
    var absoluteMinutes = occurrenceDuration.abs();
    int hours = absoluteMinutes ~/ 60;
    int remainingMinutes = absoluteMinutes % 60;
    if (hours != 0 && remainingMinutes != 0) {
      return "${hours}h${remainingMinutes}min".replaceAll("-", "");
    } else if (hours != 0) {
      return "${hours}h".replaceAll("-", "");
    } else {
      return "${remainingMinutes}min".replaceAll("-", "");
    }
  }

  String get convertDate {
    DateFormat formatted = DateFormat.yMd();
    return formatted.format(referenceDate);
  }

  String get convertAbrevDay {
    String date = DateFormat(DateFormat.ABBR_WEEKDAY).format(referenceDate);
    return toBeginningOfSentenceCase(date).replaceAll(".", '');
  }
}
