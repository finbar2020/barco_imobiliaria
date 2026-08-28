import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period_interval.dart';

class VacationPeriod {
  List<VacationPeriodInterval?> intervals;
  int periodsNumber;

  VacationPeriod({
    required this.intervals,
    required this.periodsNumber,
  });

  List<String> get getIntervals {
    List<String> list = [];
    intervals.forEach((intervalDays) {
      String daysFormatted = '';
      String delimitador = "d - ";
      intervalDays?.intervals.forEach((interval) {
        daysFormatted = "$daysFormatted$interval$delimitador";
      });
      // Sem dias (intervalo nulo ou vazio) não há opção para exibir.
      if (daysFormatted.length < delimitador.length - 1) return;
      daysFormatted = daysFormatted.substring(0, daysFormatted.length - 3);
      list.add(daysFormatted);
    });
    return list;
  }
}
