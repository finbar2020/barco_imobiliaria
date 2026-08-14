
import 'package:lello/core/database/lello_database.dart';
import 'package:drift/drift.dart';

part 'resident_dao.g.dart';

@DriftAccessor(tables: [ResidentData])
class ResidentDao extends DatabaseAccessor<LelloDatabase> with _$ResidentDaoMixin {
	final LelloDatabase database;
	ResidentDao(this.database) : super(database);

	Future<List<ResidentData>> listResidents(String condominiumId) => (
		select(database.residentTable)
			..where((dt) => dt.condominiumId.equals(condominiumId))
	).get();

	Future<int> deleteResidents(String condominiumId) => (
		delete(database.residentTable)
			..where((dt) => dt.condominiumId.equals(condominiumId))
	).go();


	Future<void> insertResidents(List<Insertable<ResidentData>> data) => batch((b) => b.insertAll(database.residentTable, data, mode: InsertMode.replace));

	Future<int> clearResidents() => delete(database.residentTable).go();
}
