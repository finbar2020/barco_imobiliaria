import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/resin/resin_people/resin_people_table.dart';
import 'package:drift/drift.dart';

part 'resin_people_dao.g.dart';

@DriftAccessor(tables: [ResinPeopleTable])
class ResinPeopleDao extends DatabaseAccessor<LelloDatabase>
    with _$ResinPeopleDaoMixin {
  final LelloDatabase database;
  ResinPeopleDao(this.database) : super(database);

  Future<List<ResinPeopleData>?> getResinPeople(String condominiumId) =>
      (select(database.resinPeopleTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .get();

  Future<int> deleteResinPerson(String id) =>
      (delete(database.resinPeopleTable)..where((dt) => dt.id.equals(id))).go();

  Future<int> deleteCondominiumResinPeople(String condominiumId) =>
      (delete(database.resinPeopleTable)
            ..where((dt) => dt.condominiumId.equals(condominiumId)))
          .go();

  Future<void> insert(Insertable<ResinPeopleData> data) =>
      into(database.resinPeopleTable).insert(data, mode: InsertMode.replace);

  Future<int> clear() => delete(database.resinPeopleTable).go();
}
