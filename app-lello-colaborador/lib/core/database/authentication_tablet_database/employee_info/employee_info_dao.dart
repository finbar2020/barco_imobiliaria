import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:colaborador/core/database/authentication_tablet_database/employee_info/employee_info_table.dart';
import 'package:drift/drift.dart';

part 'employee_info_dao.g.dart';

@DriftAccessor(tables: [EmployeeInfoTable])
class EmployeeInfoDao extends DatabaseAccessor<AuthenticationTabletDatabase>
    with _$EmployeeInfoDaoMixin {
  final AuthenticationTabletDatabase database;
  EmployeeInfoDao(this.database) : super(database);

  Future<List<EmployeeInfoData>> get(String condoCode) =>
      (select(database.employeeInfoTable)
            ..where((e) => e.condoCode.equals(condoCode)))
          .get();
  Future<int> clear() => delete(database.employeeInfoTable).go();
  Future<void> insert(Insertable<EmployeeInfoData> data) =>
      into(database.employeeInfoTable).insert(data, mode: InsertMode.replace);
}
