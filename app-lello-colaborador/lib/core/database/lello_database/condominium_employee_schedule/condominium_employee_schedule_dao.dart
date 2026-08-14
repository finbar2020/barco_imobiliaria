import 'package:colaborador/core/database/lello_database/condominium_employee_schedule/condominium_employee_schedule_table.dart';
import 'package:colaborador/core/database/lello_database/lello_database.dart';
import 'package:drift/drift.dart';

part 'condominium_employee_schedule_dao.g.dart';

@DriftAccessor(tables: [CondominiumEmployeeScheduleTable])
class CondominiumEmployeeScheduleDao extends DatabaseAccessor<LelloDatabase>
    with _$CondominiumEmployeeScheduleDaoMixin {
  final LelloDatabase database;
  CondominiumEmployeeScheduleDao(this.database) : super(database);

  Future<List<CondominiumEmployeeScheduleData>> list(String reference) =>
      (select(database.condominiumEmployeeScheduleTable)
            ..where((dt) => dt.reference.equals(reference)))
          .get();

  Future<void> insert(List<Insertable<CondominiumEmployeeScheduleData>> data) =>
      batch((b) => b.insertAll(database.condominiumEmployeeScheduleTable, data,
          mode: InsertMode.replace));

  Future<int> clear() => delete(database.condominiumTable).go();
}
