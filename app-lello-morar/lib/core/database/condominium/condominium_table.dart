import 'package:drift/drift.dart';

@DataClassName("CondominiumData")
class CondominiumTable extends Table {
  TextColumn get id => text()();
  TextColumn get reference => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get regulationUrl => text()();
  BoolColumn get active_manager => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
