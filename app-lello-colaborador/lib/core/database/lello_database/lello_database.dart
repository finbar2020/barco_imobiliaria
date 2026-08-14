import 'package:colaborador/core/database/lello_database/condominium/condominium_dao.dart';
import 'package:colaborador/core/database/lello_database/condominium/condominium_table.dart';
import 'package:colaborador/core/database/lello_database/condominium_employee_schedule/condominium_employee_schedule_dao.dart';
import 'package:colaborador/core/database/lello_database/condominium_employee_schedule/condominium_employee_schedule_table.dart';
import 'package:colaborador/core/database/lello_database/employee/employee_dao.dart';
import 'package:colaborador/core/database/lello_database/employee/employee_table.dart';
import 'package:colaborador/core/database/lello_database/me/me_dao.dart';
import 'package:colaborador/core/database/lello_database/me/me_table.dart';
import 'package:essentials/essentials.dart';

part 'lello_database.g.dart';

@DriftDatabase(tables: [
  CondominiumTable,
  MeTable,
  EmployeeTable,
  CondominiumEmployeeScheduleTable,
], daos: [
  CondominiumDao,
  MeDao,
  EmployeeDao,
  CondominiumEmployeeScheduleDao
])
class LelloDatabase extends _$LelloDatabase {
  LelloDatabase()
      : super(
          SqfliteQueryExecutor.inDatabaseFolder(
            path: 'db.sqlite',
            logStatements: false,
          ),
        );

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => destructiveFallback;

  //  MigrationStrategy(onCreate: (Migrator m) {
  //       return m.createAll();
  //     }, onUpgrade: (Migrator m, int from, int to) async {
  //       if (from == 1) {
  //         // add digitalPoint table
  //         await m.createTable(digitalPointTable);
  //       }
  //     });

  Future<Try<Nothing>> resetDb() async {
    for (var table in allTables) {
      await table.deleteAll();
    }
    return Success(Nothing());
  }
}
