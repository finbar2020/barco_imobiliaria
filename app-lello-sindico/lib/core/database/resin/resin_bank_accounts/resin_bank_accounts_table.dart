import 'package:drift/drift.dart';

@DataClassName("ResinBankAccountsData")
class ResinBankAccountsTable extends Table {
  TextColumn get condominiumId => text()();
  TextColumn get id => text()();
  TextColumn get bankId => text()();
  TextColumn get agency => text()();
  TextColumn get accountNumber => text()();
  TextColumn get document => text()();
  TextColumn get supplierName => text()();
  TextColumn get type => text()();

  @override
  Set<Column> get primaryKey => {id};
}
