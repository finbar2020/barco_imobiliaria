import 'package:drift/drift.dart';

@DataClassName("CondominiumData")
class CondominiumTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get address => text()();
  TextColumn get reference => text()();
  BoolColumn get useFacialBiometric => boolean()();
  TextColumn get managerAccessControlBiometricStatus => text()();
  TextColumn get notificationContext => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
