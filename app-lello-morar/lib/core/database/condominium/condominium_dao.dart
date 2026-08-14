import 'package:morar/core/database/lello_database.dart';
import 'package:morar/core/database/condominium/condominium_table.dart';
import 'package:drift/drift.dart';

part 'condominium_dao.g.dart';

@DriftAccessor(tables: [CondominiumTable])
class CondominiumDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumDaoMixin {
  final LelloDatabase database;
  CondominiumDao(this.database) : super(database);

  Future<List<CondominiumData>> list() =>
      select(database.condominiumTable).get();
  Future<int> clear() => delete(database.condominiumTable).go();
  Future<void> insert(Insertable<CondominiumData> data) =>
      into(database.condominiumTable).insert(data, mode: InsertMode.replace);
}
