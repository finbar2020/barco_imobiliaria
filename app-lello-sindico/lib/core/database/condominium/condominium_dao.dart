import 'package:lello/core/database/condominium/condominium_table.dart';
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'condominium_dao.g.dart';

@DriftAccessor(tables: [CondominiumTable])
class CondominiumDao extends DatabaseAccessor<LelloDatabase> with _$CondominiumDaoMixin {
	final LelloDatabase database;
	CondominiumDao(this.database) : super(database);

	Future<List<CondominiumData>> list() => select(database.condominiumTable).get();
	Future<void> insert(List<Insertable<CondominiumData>> data) => batch((b) => b.insertAll(database.condominiumTable, data, mode: InsertMode.replace));

	Future<int> clear() => delete(database.condominiumTable).go();
}
