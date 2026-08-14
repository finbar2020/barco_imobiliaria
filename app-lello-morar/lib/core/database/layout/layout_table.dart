import 'package:drift/drift.dart';

@DataClassName("LayoutData")
class LayoutTable extends Table {
  TextColumn get id => text()();
  TextColumn get condoId => text()();
  TextColumn get cod => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get reference => text().nullable()();
  TextColumn get primary => text().nullable()();
  TextColumn get secondary => text().nullable()();
  TextColumn get logoPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
