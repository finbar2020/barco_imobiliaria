import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';
import 'package:lello/core/database/lello_hub/lello_hub_table.dart';

part 'lello_hub_dao.g.dart';

@DriftAccessor(tables: [LelloHubTable])
class LelloHubDao extends DatabaseAccessor<LelloDatabase>
    with _$LelloHubDaoMixin {
  final LelloDatabase database;
  LelloHubDao(this.database) : super(database);

  Future<LelloHubData?> getByNumber(String number) =>
      (select(database.lelloHubTable)
        ..where((tbl) => tbl.number.equals(number)))
          .getSingleOrNull();

  Future<void> insert(Insertable<LelloHubData> data) =>
      into(database.lelloHubTable).insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.accountTable).go();
}
