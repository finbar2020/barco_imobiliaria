import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/resin/resin_refunds/resin_refunds_table.dart';
import 'package:drift/drift.dart';

part 'resin_refunds_dao.g.dart';

@DriftAccessor(tables: [ResinRefundsTable])
class ResinRefundsDao extends DatabaseAccessor<LelloDatabase>
    with _$ResinRefundsDaoMixin {
  final LelloDatabase database;
  ResinRefundsDao(this.database) : super(database);

  Future<List<ResinRefundsData>?> getResinRefunds(String condominiumId) =>
      (select(database.resinRefundsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<int> deleteResinRefund(String id) =>
      (delete(database.resinRefundsTable)..where((dt) => dt.id.equals(id)))
          .go();

  Future<int> deleteCondominiumResinRefunds(String condominiumId) =>
      (delete(database.resinRefundsTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<ResinRefundsData> data) =>
      into(database.resinRefundsTable).insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.resinRefundsTable).go();
}
