import 'package:drift/drift.dart';

@DataClassName("CondominiumBalanceSummaryData")
class CondominiumBalanceSummaryTable extends Table {
  TextColumn get reference => text()();
  TextColumn get name => text().nullable()();
  RealColumn get debits => real().nullable()();
  RealColumn get credits => real().nullable()();

  @override
  Set<Column> get primaryKey => {reference};
}
