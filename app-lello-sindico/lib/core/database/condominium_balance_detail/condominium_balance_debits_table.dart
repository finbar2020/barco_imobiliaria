import 'package:drift/drift.dart';

@DataClassName("CondominiumBalanceDebitsData")
class CondominiumBalanceDebitsTable extends Table {
  TextColumn get reference => text()();
  TextColumn get id => text().nullable()();
  TextColumn get name => text().nullable()();
  TextColumn get type => text().nullable()();
  RealColumn get previousBalance => real().nullable()();
  RealColumn get balance => real().nullable()();
  RealColumn get accountBalance => real().nullable()();
  RealColumn get debit => real().nullable()();
  RealColumn get credits => real().nullable()();
  DateTimeColumn get period => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {};
}
