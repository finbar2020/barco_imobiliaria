import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/resin/resin_banks/resin_banks_table.dart';
import 'package:drift/drift.dart';

part 'resin_banks_dao.g.dart';

@DriftAccessor(tables: [ResinBanksTable])
class ResinBanksDao extends DatabaseAccessor<LelloDatabase>
    with _$ResinBanksDaoMixin {
  final LelloDatabase database;
  ResinBanksDao(this.database) : super(database);

  Future<List<ResinBanksData>?> getResinBanks(String condominiumId) =>
      (select(database.resinBanksTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<ResinBanksData?> getSingleResinBank(
          String condominiumId, String bankId) =>
      (select(database.resinBanksTable)..where((dt) => dt.id.equals(bankId)))
          .getSingleOrNull();

  Future<int> deleteResinBank(String id) =>
      (delete(database.resinBanksTable)..where((dt) => dt.id.equals(id))).go();

  Future<int> deleteCondominiumResinBanks(String condominiumId) =>
      (delete(database.resinBanksTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<ResinBanksData> data) =>
      into(database.resinBanksTable).insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.resinBanksTable).go();
}
