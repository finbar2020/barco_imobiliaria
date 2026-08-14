import 'package:colaborador/core/database/authentication_tablet_database/condominium_info/condominium_info_dao.dart';
import 'package:colaborador/core/database/authentication_tablet_database/condominium_info/condominium_info_table.dart';
import 'package:colaborador/core/database/authentication_tablet_database/employee_info/employee_info_dao.dart';
import 'package:colaborador/core/database/authentication_tablet_database/employee_info/employee_info_table.dart';
import 'package:essentials/essentials.dart';

part 'authentication_tablet_database.g.dart';

@DriftDatabase(tables: [
  EmployeeInfoTable,
  CondominiumInfoTable,
], daos: [
  EmployeeInfoDao,
  CondominiumInfoDao,
])
class AuthenticationTabletDatabase extends _$AuthenticationTabletDatabase {
  AuthenticationTabletDatabase()
      : super(
          SqfliteQueryExecutor.inDatabaseFolder(
            path: 'db_authentication_tablets.sqlite',
            logStatements: false,
          ),
        );

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        try {
          if (from == 1) {
            // add AuthenticationTablet table

            await m.addColumn(employeeInfoTable, employeeInfoTable.numCra);
            await m.addColumn(employeeInfoTable, employeeInfoTable.numCad);
            await m.addColumn(employeeInfoTable, employeeInfoTable.status);
            await m.addColumn(condominiumInfoTable, condominiumInfoTable.ref);
          }
          if (from == 2) {
            await m.addColumn(condominiumInfoTable, condominiumInfoTable.ref);
          }
        } on Exception {
          for (var table in allTables) {
            await m.drop(table);
          }
          await m.createAll();
        }
      });

  Future<Try<Nothing>> resetDb() async {
    for (var table in allTables) {
      await table.deleteAll();
    }
    return Success(Nothing());
  }
}
