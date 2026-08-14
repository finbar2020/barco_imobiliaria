import 'package:drift/drift.dart';

@DataClassName("CondominiumInfoData")
class CondominiumInfoTable extends Table {
  TextColumn get condoCode => text()();
  TextColumn get reference => text()();
  TextColumn get name => text()();
  TextColumn get picturehash => text()();
  TextColumn get status => text()();
  TextColumn get ref => text()();

  @override
  Set<Column> get primaryKey => {reference};
}
