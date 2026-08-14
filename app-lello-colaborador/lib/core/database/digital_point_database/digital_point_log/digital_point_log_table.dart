import 'package:drift/drift.dart';

@DataClassName("DigitalPointLogData")
class DigitalPointLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get digitalPointId => integer()();
  DateTimeColumn get date => dateTime()();
  TextColumn get statusPrevious => text()();
  TextColumn get statusNew => text()();
  TextColumn get description => text()();
}
