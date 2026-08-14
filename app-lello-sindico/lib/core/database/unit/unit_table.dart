import 'package:drift/drift.dart';

@DataClassName('UnitData')
class UnitTable extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get group => text().nullable()();
  IntColumn get residentCount => integer()();
  TextColumn get condominiumId => text()();
  IntColumn get vehicleCount => integer()();
  BoolColumn get adimplente => boolean()();
  BoolColumn get agreement => boolean()();
  TextColumn get billingStatus => text()();
  BoolColumn get usesApp => boolean()();
  TextColumn get fixedPhone => text()();
  TextColumn get mobilePhone => text()();
  DateTimeColumn get lastUpdated => dateTime()();

  @override
  Set<Column> get primaryKey => {condominiumId, id};
}
