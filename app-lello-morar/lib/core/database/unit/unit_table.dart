import 'package:drift/drift.dart';

@DataClassName("UnitData")
class UnitTable extends Table {
  TextColumn get id => text()();
  TextColumn get notificationContext =>
      text().withDefault(const Constant(""))();
  TextColumn get blockId => text()();
  TextColumn get title => text().nullable()();
  BoolColumn get rented => boolean().nullable()();
  BoolColumn get compliant => boolean().nullable()();
  BoolColumn get agreement => boolean().nullable()();
  BoolColumn get termHomeToGo => boolean().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
