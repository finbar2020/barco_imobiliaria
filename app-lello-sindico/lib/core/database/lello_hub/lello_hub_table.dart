import 'package:drift/drift.dart';

@DataClassName("LelloHubData")
class LelloHubTable extends Table {
  TextColumn get number => text().nullable()();

  @override
  Set<Column> get primaryKey => {number};
}
