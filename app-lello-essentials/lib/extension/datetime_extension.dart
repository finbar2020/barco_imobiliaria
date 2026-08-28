import 'package:intl/intl.dart';

class DateTimeUtils {
  static DateTime? fromFormattedString(String? date) {
    if (date == null) return null;
    List<String> dateList = date.split('/');
    if (dateList.length != 3) return null;
    dateList = dateList.map((e) {
      if (e.length == 1) {
        return "0$e";
      }
      return e;
    }).toList();
    return DateTime.tryParse(
      "${dateList[2]}-${dateList[1]}-${dateList[0]}",
    );
  }

  static DateTime? tryParseDate(String input, String pattern) {
    try {
      if (input.isEmpty) return null;
      DateFormat format = DateFormat(pattern);
      return format.parse(input);
    } catch (e) {
      return null;
    }
  }
}

extension DateTimeExtensions on DateTime {
  String toFormattedString() {
    return "$day/$month/$year";
  }

  String toDateTimeFormattedString() {
    DateFormat format = DateFormat('dd/MM/yyyy HH:mm:ss');
    return format.format(this);
  }

  String toFormattedFileString() {
    return "$day-$month-$year";
  }

  String toDayMonthString() {
    final format = DateFormat('dd/MM');
    return format.format(this);
  }

  DateTime firstDayOfMonth() {
    return DateTime(this.year, this.month, 1);
  }

  DateTime lastDayOfMonth() {
    return DateTime(this.year, this.month + 1, 1).subtract(Duration(days: 1));
  }
}
