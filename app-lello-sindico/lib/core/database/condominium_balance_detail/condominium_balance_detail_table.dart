import 'package:drift/drift.dart';

@DataClassName("CondominiumBalanceDetailData")
class CondominiumBalanceDetailTable extends Table {
  TextColumn get reference => text()();
  RealColumn get previousBalance => real().nullable()();
  RealColumn get balance => real().nullable()();
  RealColumn get accountBalance => real().nullable()();
  RealColumn get debit => real().nullable()();
  RealColumn get credits => real().nullable()();
  DateTimeColumn get lastUpdatedAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {};
}
