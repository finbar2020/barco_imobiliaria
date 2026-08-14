import 'package:drift/drift.dart';

@DataClassName("AgreementsRulesDaysData")
class AgreementsRulesDaysTable extends Table {
  TextColumn get condominiumId => text()();
  IntColumn get days => integer()();

  @override
  Set<Column> get primaryKey => {};
}
