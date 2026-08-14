import 'package:lello/feature/gdp/vacation/domain/entity/vacation_period_interval.dart';

class VacationPeriod {
  List<VacationPeriodInterval?> intervals;
  int periodsNumber;

  VacationPeriod({
    required this.intervals,
    required this.periodsNumber,
  });

  List<String> get getIntervals {
    List<String> list = [];
    if (periodsNumber >= intervals.length) {
      return list;
    }
    intervals.forEach((intervalDays) {
      String daysFormatted = '';
      String delimitador = "d - ";
      intervalDays?.intervals.forEach((interval) {
        daysFormatted = "$daysFormatted$interval$delimitador";
      });
      daysFormatted = daysFormatted.substring(0, daysFormatted.length - 3);
      list.add(daysFormatted);
    });
    return list;
  }
}
