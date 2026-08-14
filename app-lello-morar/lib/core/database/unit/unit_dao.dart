import 'package:morar/core/database/lello_database.dart';
import 'package:morar/core/database/unit/unit_table.dart';
import 'package:drift/drift.dart';

part 'unit_dao.g.dart';

@DriftAccessor(tables: [UnitTable])
class UnitDao extends DatabaseAccessor<LelloDatabase> with _$UnitDaoMixin {
  final LelloDatabase database;
  UnitDao(this.database) : super(database);

  Future<List<UnitData>> list() => select(database.unitTable).get();
  Future<int> clear() => delete(database.unitTable).go();
  Future<void> insert(Insertable<UnitData> data) =>
      into(database.unitTable).insert(data, mode: InsertMode.replace);
}
