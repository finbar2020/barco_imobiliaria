import 'package:lello/feature/income/data/model/income_model.dart';

abstract class IncomeLocalDataSource {
  Future<IncomeModel?> select(String condominiumId, DateTime period);
  Future<IncomeModel> save(
      String condominiumId, DateTime period, IncomeModel model);
}
