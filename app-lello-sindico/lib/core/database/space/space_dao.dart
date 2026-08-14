import 'package:lello/core/database/space/space_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'space_dao.g.dart';

@DriftAccessor(tables: [SpaceTable])
class SpaceDao  extends DatabaseAccessor<LelloDatabase> with _$SpaceDaoMixin{
    final LelloDatabase database;
	SpaceDao(this.database) : super(database);

    Future<List<SpaceData>> list(String condominiumId) => (select(database.spaceTable)
	    ..where((tbl) => tbl.condominiumId.equals(condominiumId))).get();

    Future<void> insert(List<Insertable<SpaceData>> data) => batch((b) => b.insertAll(database.spaceTable, data, mode: InsertMode.replace));
    Future<int> clear() => delete(database.spaceTable).go();

}