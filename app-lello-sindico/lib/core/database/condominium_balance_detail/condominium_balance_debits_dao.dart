import 'package:lello/core/database/condominium_balance_detail/condominium_balance_debits_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'condominium_balance_debits_dao.g.dart';

@DriftAccessor(tables: [CondominiumBalanceDebitsTable])
class CondominiumBalanceDebitsDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumBalanceDebitsDaoMixin {
  final LelloDatabase database;
  CondominiumBalanceDebitsDao(this.database) : super(database);

  Future<List<CondominiumBalanceDebitsData>> getCondominiumBalanceDebits(
          String reference) =>
      (select(database.condominiumBalanceDebitsTable)
            ..where((dt) => dt.reference.equals(reference)))
          .get();

  Future<int> deleteCondominiumBalanceDebits(String reference) =>
      (delete(database.condominiumBalanceDebitsTable)
            ..where((dt) => dt.reference.equals(reference)))
          .go();

  Future<void> insert(List<Insertable<CondominiumBalanceDebitsData>> data) =>
      batch((b) => b.insertAll(database.condominiumBalanceDebitsTable, data,
          mode: InsertMode.replace));

  Future<int> clear() => delete(database.condominiumBalanceDebitsTable).go();
}
