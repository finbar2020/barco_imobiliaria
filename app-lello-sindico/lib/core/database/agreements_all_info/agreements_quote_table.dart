import 'package:drift/drift.dart';

@DataClassName("AgreementsQuoteData")
class AgreementsQuoteTable extends Table {
  TextColumn get id => text()();
  TextColumn get condominiumId => text()();
  TextColumn get agreementId => text().nullable()();
  IntColumn get reference => integer()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  RealColumn get originValue => real()();
  RealColumn get fineValue => real()();
  RealColumn get feeValue => real()();
  RealColumn get honoraryValue => real()();
  TextColumn get overdueMessage => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
