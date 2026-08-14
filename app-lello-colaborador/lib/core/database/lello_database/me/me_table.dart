import 'package:drift/drift.dart';

@DataClassName("MeData")
class MeTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get cpf => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get picture => text().nullable()();
  TextColumn get pictureHash => text().nullable()();
  DateTimeColumn get updated => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
