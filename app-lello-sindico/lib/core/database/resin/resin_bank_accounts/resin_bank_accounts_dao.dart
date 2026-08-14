import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/resin/resin_bank_accounts/resin_bank_accounts_table.dart';
import 'package:drift/drift.dart';

part 'resin_bank_accounts_dao.g.dart';

@DriftAccessor(tables: [ResinBankAccountsTable])
class ResinBankAccountsDao extends DatabaseAccessor<LelloDatabase>
    with _$ResinBankAccountsDaoMixin {
  final LelloDatabase database;
  ResinBankAccountsDao(this.database) : super(database);

  Future<List<ResinBankAccountsData>> getResinBankAccounts(
          String condominiumId) =>
      (select(database.resinBankAccountsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<ResinBankAccountsData?> getSingleResinBankAccount(String accountId) =>
      (select(database.resinBankAccountsTable)
            ..where((dt) => dt.id.equals(accountId)))
          .getSingleOrNull();

  Future<int> deleteResinBankAccount(String id) =>
      (delete(database.resinBankAccountsTable)..where((dt) => dt.id.equals(id)))
          .go();

  Future<int> deleteCondominiumResinBankAccounts(String condominiumId) =>
      (delete(database.resinBankAccountsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<ResinBankAccountsData> data) =>
      into(database.resinBankAccountsTable)
          .insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.resinBankAccountsTable).go();
}
