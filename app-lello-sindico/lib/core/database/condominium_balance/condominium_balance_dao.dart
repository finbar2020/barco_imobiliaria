import 'package:lello/core/database/condominium_balance/condominium_balance_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'condominium_balance_dao.g.dart';

@DriftAccessor(tables: [CondominiumBalanceTable])
class CondominiumBalanceDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumBalanceDaoMixin {
  final LelloDatabase database;
  CondominiumBalanceDao(this.database) : super(database);

  Future<CondominiumBalanceData?> getCondominiumBalance(String reference) =>
      (select(database.condominiumBalanceTable)
            ..where((dt) => dt.reference.equals(reference)))
          .getSingle();

  Future<int> deleteCondominiumBalance(String reference) =>
      (delete(database.condominiumBalanceTable)
            ..where((dt) => dt.reference.equals(reference)))
          .go();

  Future<void> insert(Insertable<CondominiumBalanceData> data) =>
      into(database.condominiumBalanceTable)
          .insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.condominiumBalanceTable).go();
}
