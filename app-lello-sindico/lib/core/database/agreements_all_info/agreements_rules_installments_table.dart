import 'package:drift/drift.dart';

@DataClassName("AgreementsRulesInstallmentsData")
class AgreementsRulesInstallmentsTable extends Table {
  TextColumn get condominiumId => text()();
  IntColumn get installmentQtd => integer()();

  @override
  Set<Column> get primaryKey => {condominiumId};
}
