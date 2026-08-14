import 'package:lello/core/database/condominium_balance_detail/condominium_balance_summary_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'condominium_balance_summary_dao.g.dart';

@DriftAccessor(tables: [CondominiumBalanceSummaryTable])
class CondominiumBalanceSummaryDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumBalanceSummaryDaoMixin {
  final LelloDatabase database;
  CondominiumBalanceSummaryDao(this.database) : super(database);

  Future<List<CondominiumBalanceSummaryData>> getCondominiumBalanceSummary(
          String reference) =>
      (select(database.condominiumBalanceSummaryTable)
            ..where((dt) => dt.reference.equals(reference)))
          .get();

  Future<int> deleteCondominiumBalanceSummary(String reference) =>
      (delete(database.condominiumBalanceSummaryTable)
            ..where((dt) => dt.reference.equals(reference)))
          .go();

  Future<void> insert(List<Insertable<CondominiumBalanceSummaryData>> data) =>
      batch((b) => b.insertAll(database.condominiumBalanceSummaryTable, data,
          mode: InsertMode.replace));

  Future<int> clear() => delete(database.condominiumBalanceSummaryTable).go();
}
