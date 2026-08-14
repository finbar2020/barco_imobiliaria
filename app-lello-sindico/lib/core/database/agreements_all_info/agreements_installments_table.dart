import 'package:drift/drift.dart';

@DataClassName("AgreementsInstallmentsData")
class AgreementsInstallmentsTable extends Table {
  TextColumn get installmentId => text()();
  TextColumn get condominiumId => text()();
  TextColumn get agreementId => text().nullable()();
  IntColumn get reference => integer()();
  RealColumn get value => real()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  TextColumn get status => text().nullable()();

  @override
  Set<Column> get primaryKey => {installmentId};
}
