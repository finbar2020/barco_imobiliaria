import 'package:essentials/essentials.dart';
import 'package:lello/feature/income/domain/entity/income.dart';

abstract class IncomeRepository {
  Future<Try<Income?>> select(
      DataOrigin origin, String condominiumId, DateTime period);
}
