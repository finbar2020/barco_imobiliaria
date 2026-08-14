import 'package:drift/drift.dart';

@DataClassName("CondominiumBalanceData")
class CondominiumBalanceTable extends Table {
  TextColumn get id => text().nullable()();
  TextColumn get reference => text()();
  RealColumn get balance => real().nullable()();
  RealColumn get previousBalance => real().nullable()();
  RealColumn get forecast => real().nullable()();
  RealColumn get income => real().nullable()();
  RealColumn get expenses => real().nullable()();
  DateTimeColumn get date => dateTime().nullable()();
  DateTimeColumn get lastUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {reference};
}
