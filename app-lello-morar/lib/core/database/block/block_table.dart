import 'package:drift/drift.dart';

@DataClassName("BlockData")
class BlockTable extends Table {
  TextColumn get id => text()();
  TextColumn get condominiumId => text()();
  TextColumn get name => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
