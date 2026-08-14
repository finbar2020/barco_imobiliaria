import 'package:drift/drift.dart';

@DataClassName("CondominiumEmployeeScheduleData")
class CondominiumEmployeeScheduleTable extends Table {
  TextColumn get reference => text()();
  DateTimeColumn get date => dateTime()();

  TextColumn get badageNumber => text()();
  TextColumn get entry1 => text()();
  TextColumn get out1 => text()();
  TextColumn get entry2 => text()();
  TextColumn get out2 => text()();
  BoolColumn get isDayOff => boolean()();

  @override
  Set<Column> get primaryKey => {reference, date};
}
