import 'package:lello/core/database/account/account_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'account_dao.g.dart';

@DriftAccessor(tables: [AccountTable])
class AccountDao extends DatabaseAccessor<LelloDatabase>
    with _$AccountDaoMixin {
  final LelloDatabase database;
  AccountDao(this.database) : super(database);

  Future<List<AccountData>> list(String condominiumId) =>
      (select(database.accountTable)
            ..where((tbl) => tbl.condominiumId.equals(condominiumId)))
          .get();

  Future<void> insert(List<Insertable<AccountData>> data) => batch((b) =>
      b.insertAll(database.accountTable, data, mode: InsertMode.replace));
  Future<int> clear() => delete(database.accountTable).go();
}
