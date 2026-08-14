import 'package:drift/drift.dart';

@DataClassName("ResinPeopleData")
class ResinPeopleTable extends Table {
  TextColumn get condominiumId => text()();
  TextColumn get id => text()();
  TextColumn get document => text()();
  TextColumn get name => text()();
  TextColumn get role => text()();

  @override
  Set<Column> get primaryKey => {document};
}
