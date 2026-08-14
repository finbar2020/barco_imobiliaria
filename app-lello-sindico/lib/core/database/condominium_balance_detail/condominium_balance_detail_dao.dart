import 'package:lello/core/database/condominium_balance_detail/condominium_balance_detail_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'condominium_balance_detail_dao.g.dart';

@DriftAccessor(tables: [CondominiumBalanceDetailTable])
class CondominiumBalanceDetailDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumBalanceDetailDaoMixin {
  final LelloDatabase database;
  CondominiumBalanceDetailDao(this.database) : super(database);

  Future<CondominiumBalanceDetailData> getCondominiumBalanceDetail(
          String reference) =>
      (select(database.condominiumBalanceDetailTable)
            ..where((dt) => dt.reference.equals(reference)))
          .getSingle();

  Future<int> deleteCondominiumBalanceDetail(String reference) =>
      (delete(database.condominiumBalanceDetailTable)
            ..where((dt) => dt.reference.equals(reference)))
          .go();

  Future<void> insert(Insertable<CondominiumBalanceDetailData> data) =>
      into(database.condominiumBalanceDetailTable)
          .insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.condominiumBalanceDetailTable).go();
}
