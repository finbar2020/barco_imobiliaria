import 'package:drift/drift.dart';

@DataClassName("AccountData")
class AccountTable extends Table {
  TextColumn get id => text()();
  TextColumn get number => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get condominiumId => text()();

  @override
  Set<Column> get primaryKey => {condominiumId, id};
}
