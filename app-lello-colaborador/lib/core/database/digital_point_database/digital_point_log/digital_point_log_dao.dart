import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_log/digital_point_log_table.dart';
import 'package:drift/drift.dart';
import 'package:essentials/essentials.dart';

part 'digital_point_log_dao.g.dart';

@DriftAccessor(tables: [DigitalPointLogTable])
class DigitalPointLogDao extends DatabaseAccessor<DigitalPointDatabase>
    with _$DigitalPointLogDaoMixin {
  final DigitalPointDatabase database;
  DigitalPointLogDao(this.database) : super(database);

  Future<List<DigitalPointLogData>> list(int digitalPointId) =>
      (select(database.digitalPointLogTable)
            ..where((e) => e.digitalPointId.equals(digitalPointId)))
          .get();

  Future<void> insert(Insertable<DigitalPointLogData> data) => batch(
        (b) => b.insert(
          database.digitalPointLogTable,
          data,
          mode: InsertMode.replace,
        ),
      );

  Future<int> clear() => database.digitalPointLogTable.deleteAll();
}
