
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'pendency_dao.g.dart';

@DriftAccessor(tables: [PendencyData])
class PendencyDao extends DatabaseAccessor<LelloDatabase> with _$PendencyDaoMixin {
	final LelloDatabase database;
	PendencyDao(this.database) : super(database);

	Future<List<PendencyData>> listPendencies(String condominiumId) => (
		select(database.pendencyTable)
			..where((dt) => dt.condominiumId.equals(condominiumId))
	).get();

	Future<int> deletePendencies(String condominiumId) => (
		delete(database.pendencyTable)
			..where((dt) => dt.condominiumId.equals(condominiumId))
	).go();


	Future<void> insertPendencies(List<Insertable<PendencyData>> data) => batch((b) => b.insertAll(database.pendencyTable, data, mode: InsertMode.replace));

	Future<int> clearPendencies() => delete(database.pendencyTable).go();
}