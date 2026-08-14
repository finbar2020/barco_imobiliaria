import 'package:colaborador/core/database/digital_point_database/digital_point/digital_point_dao.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point/digital_point_table.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_log/digital_point_log_dao.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_log/digital_point_log_table.dart';
import 'package:essentials/essentials.dart';

part 'digital_point_database.g.dart';

@DriftDatabase(tables: [
  DigitalPointTable,
  DigitalPointLogTable,
], daos: [
  DigitalPointDao,
  DigitalPointLogDao
])
class DigitalPointDatabase extends _$DigitalPointDatabase {
  DigitalPointDatabase()
      : super(
          SqfliteQueryExecutor.inDatabaseFolder(
            path: 'db_digital_point.sqlite',
            logStatements: false,
          ),
        );

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        try {
          if (to == 6) {
            // add new colum tabletSession to digitalPoint table
            await m.addColumn(
                digitalPointTable, digitalPointTable.tabletSession);
          }
          if (to == 7) {
            // add new colum tabletSession to digitalPoint table
            await m.addColumn(digitalPointTable, digitalPointTable.reference);
            await m.addColumn(digitalPointTable, digitalPointTable.numCra);
            await m.addColumn(digitalPointTable, digitalPointTable.numCad);
          }
        } catch (ex) {
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
