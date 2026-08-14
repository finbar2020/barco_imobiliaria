import 'package:shared_features/feature/gdp/payroll/data/model/payroll_model.dart';

abstract class PayrollRemoteDataSource {
  Future<PayrollModel> select(String condominiumId, DateTime period);
  Future<List<PayrollModel>> list(String condominiumId);
}
