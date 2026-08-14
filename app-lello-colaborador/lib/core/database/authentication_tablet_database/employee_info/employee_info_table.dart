import 'package:drift/drift.dart';

@DataClassName("EmployeeInfoData")
class EmployeeInfoTable extends Table {
  TextColumn get condoCode => text()();
  TextColumn get numCad => text()();
  TextColumn get numCra => text()();
  TextColumn get cpf => text()();
  TextColumn get name => text()();
  TextColumn get jobPosition => text()();
  TextColumn get idLogin => text()();
  TextColumn get pictureHash => text()();
  BoolColumn get registered => boolean()();
  TextColumn get status => text()();

  @override
  Set<Column> get primaryKey => {cpf};
}
