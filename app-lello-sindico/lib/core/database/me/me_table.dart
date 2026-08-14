import 'package:drift/drift.dart';

@DataClassName("MeData")
class MeTable extends Table {
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get cpf => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get picture => text().nullable()();
  TextColumn get pictureHash => text().nullable()();

  @override
  Set<Column> get primaryKey => {email};
}
