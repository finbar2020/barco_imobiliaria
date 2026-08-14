import 'package:drift/drift.dart';

@DataClassName("AgreementsData")
class AgreementsTable extends Table {
  TextColumn get id => text()();
  TextColumn get condominiumId => text()();
  IntColumn get reference => integer()();
  TextColumn get unit => text().nullable()();
  TextColumn get unitOwner => text().nullable()();
  RealColumn get baseValue => real()();
  RealColumn get fineAndCosts => real()();
  IntColumn get installmentQuantity => integer()();
  TextColumn get paymentMethod => text().nullable()();
  TextColumn get status => text().nullable()();
  TextColumn get statusMessage => text().nullable()();
  DateTimeColumn get expiration => dateTime().nullable()();
  DateTimeColumn get proposaldedDate => dateTime().nullable()();
  DateTimeColumn get approvalDate => dateTime().nullable()();
  IntColumn get dueDate => integer()();
  DateTimeColumn get lastInstallmentDate => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
