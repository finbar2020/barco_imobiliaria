import 'package:drift/drift.dart';

@DataClassName("DigitalPointData")
class DigitalPointTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get meId => text()();
  TextColumn get condominiumId => text()();

  DateTimeColumn get date => dateTime()();
  TextColumn get latitude => text()();
  TextColumn get longitude => text()();
  TextColumn get typePoint => text()();
  TextColumn get photoTempHash => text().nullable()();
  TextColumn get photoPath => text()();
  TextColumn get status => text()();
  TextColumn get captureType => text()();
  TextColumn get uniqueHash => text()();
  BoolColumn get tabletSession =>
      boolean().withDefault(const Constant(false))();
  TextColumn get reference => text().nullable()();
  TextColumn get numCra => text().nullable()();
  TextColumn get numCad => text().nullable()();
}
