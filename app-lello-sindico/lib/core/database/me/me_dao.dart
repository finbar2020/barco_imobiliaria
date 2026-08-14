import 'package:lello/core/database/lello_database.dart';
import 'package:lello/core/database/me/me_table.dart';
import 'package:drift/drift.dart';

part 'me_dao.g.dart';

@DriftAccessor(tables: [MeTable])
class MeDao extends DatabaseAccessor<LelloDatabase> with _$MeDaoMixin {
  final LelloDatabase database;
  MeDao(this.database) : super(database);

  Future<MeData?> get() => select(database.meTable).getSingle();
  Future<int> clear() => delete(database.meTable).go();
  Future<void> insert(Insertable<MeData> data) =>
      into(database.meTable).insert(data, mode: InsertMode.replace);
}
