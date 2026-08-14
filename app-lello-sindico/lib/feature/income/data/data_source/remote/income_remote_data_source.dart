import 'package:lello/feature/income/data/model/income_model.dart';

abstract class IncomeRemoteDataSource {
	Future<IncomeModel> select(String condominiumId, DateTime period);
}