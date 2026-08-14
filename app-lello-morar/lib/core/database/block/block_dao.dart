import 'package:morar/core/database/lello_database.dart';
import 'package:morar/core/database/block/block_table.dart';
import 'package:drift/drift.dart';

part 'block_dao.g.dart';

@DriftAccessor(tables: [BlockTable])
class BlockDao extends DatabaseAccessor<LelloDatabase> with _$BlockDaoMixin {
  final LelloDatabase database;
  BlockDao(this.database) : super(database);

  Future<List<BlockData>> list() => select(database.blockTable).get();
  Future<int> clear() => delete(database.blockTable).go();
  Future<void> insert(Insertable<BlockData> data) =>
      into(database.blockTable).insert(data, mode: InsertMode.replace);
}
