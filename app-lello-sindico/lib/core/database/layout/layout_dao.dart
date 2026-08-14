import 'package:drift/drift.dart';
import 'package:lello/core/database/layout/layout_table.dart';
import 'package:lello/core/database/lello_database.dart';

part 'layout_dao.g.dart';

@DriftAccessor(tables: [LayoutTable])
class LayoutDao extends DatabaseAccessor<LelloDatabase> with _$LayoutDaoMixin {
  final LelloDatabase database;
  LayoutDao(this.database) : super(database);

  Future<List<LayoutData>> list() => select(database.layoutTable).get();
  Future<int> clear() => delete(database.layoutTable).go();
  Future<void> insert(Insertable<LayoutData> data) =>
      into(database.layoutTable).insert(data, mode: InsertMode.replace);
}
