import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/reservation_summary/reservation_summary_table.dart';
import 'package:drift/drift.dart';

part 'reservation_summary_dao.g.dart';

@DriftAccessor(tables: [ReservationSummaryTable])
class ReservationSummaryDao extends DatabaseAccessor<LelloDatabase>
    with _$ReservationSummaryDaoMixin {
  final LelloDatabase database;
  ReservationSummaryDao(this.database) : super(database);

  Future<List<ReservationSummaryData>> list(
          String condominiumId, DateTime periodStart, DateTime periodEnd) =>
      (select(database.reservationSummaryTable)
            ..where((tbl) =>
                tbl.condominiumId.equals(condominiumId) &
                tbl.day.isBetweenValues(periodStart, periodEnd))
            ..orderBy([(tbl) => OrderingTerm.asc(tbl.day)]))
          .get();

  Future<void> insert(List<Insertable<ReservationSummaryData>> data) =>
      batch((b) => b.insertAll(database.reservationSummaryTable, data,
          mode: InsertMode.replace));
  Future<int> clear() => delete(database.reservationSummaryTable).go();
}
