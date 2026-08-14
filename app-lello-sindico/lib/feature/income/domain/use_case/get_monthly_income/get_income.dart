import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/income.dart';

abstract class GetIncome extends UseCase<Income?, GetIncomeParam> {}

class GetIncomeParam {
  final String condominiumId;
  final DataOrigin origin;
  final DateTime period;

  GetIncomeParam(
      {required this.condominiumId,
      required this.origin,
      required this.period});
}
