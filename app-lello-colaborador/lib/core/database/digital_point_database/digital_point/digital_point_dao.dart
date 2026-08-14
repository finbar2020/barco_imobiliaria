import 'package:colaborador/core/database/digital_point_database/digital_point/digital_point_table.dart';
import 'package:colaborador/core/database/digital_point_database/digital_point_database.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:essentials/essentials.dart';

part 'digital_point_dao.g.dart';

@DriftAccessor(tables: [DigitalPointTable])
class DigitalPointDao extends DatabaseAccessor<DigitalPointDatabase>
    with _$DigitalPointDaoMixin {
  final DigitalPointDatabase database;
  DigitalPointDao(this.database) : super(database);

  Future<List<DigitalPointData>> listByStatus(
    String condominiumId,
    String meId,
    String status,
  ) =>
      (select(database.digitalPointTable)
            ..where((e) => e.meId.equals(meId))
            ..where((e) => e.condominiumId.equals(condominiumId))
            ..where((e) => e.status.equals(status)))
          .get();

  Future<List<DigitalPointData>> listAll(
    String condominiumId,
    String meId,
  ) =>
      (select(database.digitalPointTable)
            ..where((e) => e.meId.equals(meId))
            ..where((e) => e.condominiumId.equals(condominiumId)))
          .get();

  Future<List<DigitalPointData>> listPendingFromDevice() =>
      (select(database.digitalPointTable)
            ..where((e) => e.status.equals(
                enumToString(DigitalPointStatusEnum.pending) ?? "pending")))
          .get();

  Future<DigitalPointData?> getSingle(
          String condominiumId, String meId, DateTime dateTime) =>
      (select(database.digitalPointTable)
            ..where((e) => e.meId.equals(meId))
            ..where((e) => e.condominiumId.equals(condominiumId))
            ..where((e) => e.date.equals(dateTime)))
          .getSingleOrNull();

  Future<void> insert(Insertable<DigitalPointData> data) => batch(
        (b) => b.insert(database.digitalPointTable, data,
            mode: InsertMode.insertOrReplace),
      );

  Future<void> updatePointStatus({
    required int id,
    required DigitalPointStatusEnum newStatusEnum,
  }) async {
    (update(database.digitalPointTable)
      ..where((e) => e.id.equals(id))
      ..write(
        DigitalPointTableCompanion(
          status: Value(
            enumToString(newStatusEnum)!,
          ),
        ),
      ));
  }

  Future<int> clear() => database.digitalPointTable.deleteAll();
}
