import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_period.dart';

class VacationParams {
  List<VacationPeriod?> periods;
  int qtdInitDays;

  VacationParams({
    required this.periods,
    required this.qtdInitDays,
  });
}
