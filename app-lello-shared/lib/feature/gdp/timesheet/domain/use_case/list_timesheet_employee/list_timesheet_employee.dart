import 'package:essentials/essentials.dart';
import 'package:shared_features/feature/gdp/domain/entity/employee.dart';

abstract class ListTimesheetEmployee
    extends UseCase<List<Employee>, ListTimesheetEmployeeParam> {}

class ListTimesheetEmployeeParam {
  final String condominiumId;

  ListTimesheetEmployeeParam({required this.condominiumId});
}
