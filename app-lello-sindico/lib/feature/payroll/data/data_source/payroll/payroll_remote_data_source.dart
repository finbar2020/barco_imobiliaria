import 'package:lello/feature/payroll/data/model/payroll_model.dart';

abstract class PayrollRemoteDataSource {
	Future<PayrollModel> select(String condominiumId, DateTime period);
	Future<List<PayrollModel>> list(String condominiumId);
}