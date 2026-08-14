import 'package:colaborador/core/database/authentication_tablet_database/authentication_tablet_database.dart';
import 'package:colaborador/core/database/authentication_tablet_database/condominium_info/condominium_info_table.dart';
import 'package:drift/drift.dart';

part 'condominium_info_dao.g.dart';

@DriftAccessor(tables: [CondominiumInfoTable])
class CondominiumInfoDao extends DatabaseAccessor<AuthenticationTabletDatabase>
    with _$CondominiumInfoDaoMixin {
  final AuthenticationTabletDatabase database;
  CondominiumInfoDao(this.database) : super(database);

  Future<CondominiumInfoData?> get(String condoCode) =>
      (select(database.condominiumInfoTable)
            ..where((e) => e.condoCode.equals(condoCode)))
          .getSingleOrNull();
  Future<int> clear() => delete(database.condominiumInfoTable).go();
  Future<void> insert(Insertable<CondominiumInfoData> data) =>
      into(database.condominiumInfoTable)
          .insert(data, mode: InsertMode.replace);
}
