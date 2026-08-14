import 'package:lello/feature/gdp/data/model/employee_model.dart';

abstract class EmployeeLocalDataSource {
	Future<List<EmployeeModel>> list(String condominiumId);
	Future<List<EmployeeModel>> save(String condominiumId, List<EmployeeModel> data);
}