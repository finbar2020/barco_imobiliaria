import 'package:lello/feature/payroll/data/model/payroll_entry_model.dart';

abstract class PayrollEntryRemoteDataSource {
	Future<List<PayrollEntryModel>> list(String condominiumId, DateTime period);
}