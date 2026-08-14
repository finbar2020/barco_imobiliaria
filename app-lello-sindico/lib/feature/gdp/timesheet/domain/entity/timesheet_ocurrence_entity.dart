import 'package:essentials/essentials.dart';

class TimesheetOccurrenceEntity {
  String photo;
  String name;
  String jobPosition;
  String numCra;
  String receivedMark;
  String hourRange;
  String referenceDate;
  int occurenceDuration;
  String occurrenceName;
  bool canTreat;
  String occurrenceType;
  TimesheetOccurrenceEntity({
    required this.photo,
    required this.name,
    required this.jobPosition,
    required this.numCra,
    required this.receivedMark,
    required this.hourRange,
    required this.referenceDate,
    required this.occurenceDuration,
    required this.occurrenceName,
    required this.canTreat,
    required this.occurrenceType,
  });

  String get nameFormatted => name
      .trimRight()
      .split(' ')
      .map((word) => word.isNotEmpty ? word.capitalize : '')
      .join(' ');

  String convertExtraHours() {
    var absoluteMinutes = occurenceDuration.abs();
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

  String convertDate() {
    DateTime dateTime = DateTime.parse(referenceDate);
    DateFormat formatted = DateFormat.yMd();
    return formatted.format(dateTime);
  }

  DateTime convertStringToDate() {
    return DateTime.parse(referenceDate);
  }

  String get turn => hourRange.replaceAll(";", " - ");

  String get marks => receivedMark.replaceAll(";", " - ");

  List<String> get marksList => receivedMark
      .split(";")
      .where((item) => RegExp(r'^([01]\d|2[0-3]):([0-5]\d)$').hasMatch(item))
      .toList();

  bool get enableButton {
    int count = 0;
    for (var i = 0; i < receivedMark.length; i++) {
      if (receivedMark[i] == ";") count++;
    }
    return count < 5;
  }
}
