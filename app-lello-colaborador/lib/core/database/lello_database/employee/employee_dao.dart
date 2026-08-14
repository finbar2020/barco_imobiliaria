
import 'package:colaborador/core/database/lello_database/employee/employee_table.dart';
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:drift/drift.dart';

part 'employee_dao.g.dart';

@DriftAccessor(tables: [EmployeeTable])
class EmployeeDao extends DatabaseAccessor<LelloDatabase>
    with _$EmployeeDaoMixin {
  final LelloDatabase database;
  EmployeeDao(this.database) : super(database);

  Future<List<EmployeeData>> list(String condominiumId) =>
      (select(database.employeeTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<void> insert(List<Insertable<EmployeeData>> data) => batch((b) =>
      b.insertAll(database.employeeTable, data, mode: InsertMode.replace));

  Future<int> clear() => delete(database.condominiumTable).go();
}
