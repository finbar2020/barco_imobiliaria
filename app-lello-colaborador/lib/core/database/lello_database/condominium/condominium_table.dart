import 'package:drift/drift.dart';

@DataClassName("CondominiumData")
class CondominiumTable extends Table {
  TextColumn get id => text()();
  TextColumn get meId => text()();
  TextColumn get reference => text()();
  TextColumn get name => text().nullable()();
  TextColumn get jobPosition => text().nullable()();
  TextColumn get workShift => text().nullable()();
  TextColumn get digitalTimesheetStatus => text().nullable()();
  BoolColumn get usesDigitalTimesheet => boolean().nullable()();
  TextColumn get workLeaveDescription => text().nullable()();
  BoolColumn get shouldIgnoreDigitalPoint => boolean().nullable()();
  TextColumn get latitude => text().nullable()();
  TextColumn get longitude => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
