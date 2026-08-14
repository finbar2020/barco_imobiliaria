import 'package:colaborador/core/database/lello_database/condominium/condominium_table.dart';
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:essentials/essentials.dart';

part 'condominium_dao.g.dart';

@DriftAccessor(tables: [CondominiumTable])
class CondominiumDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumDaoMixin {
  final LelloDatabase database;
  CondominiumDao(this.database) : super(database);

  Future<List<CondominiumData>> list(String? meId) =>
      (select(database.condominiumTable)..where((e) => e.meId.equals(meId!)))
          .get();

  Future<CondominiumData?> getSingle(String? condominiumId) =>
      (select(database.condominiumTable)
            ..where((e) => e.id.equals(condominiumId!)))
          .getSingleOrNull();

  Future<void> insert(Insertable<CondominiumData> data) => batch(
        (b) =>
            b.insert(database.condominiumTable, data, mode: InsertMode.replace),
      );

  Future<int> clear() => database.condominiumTable.deleteAll();
}
