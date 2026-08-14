import 'package:shared_features/feature/gdp/payroll/data/model/payroll_entry_model.dart';

abstract class PayrollEntryRemoteDataSource {
  Future<List<PayrollEntryModel>> list(String condominiumId, DateTime period);
}
