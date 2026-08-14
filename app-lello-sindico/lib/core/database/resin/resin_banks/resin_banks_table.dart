import 'package:drift/drift.dart';

@DataClassName("ResinBanksData")
class ResinBanksTable extends Table {
  TextColumn get condominiumId => text()();
  TextColumn get id => text()();
  TextColumn get bankCode => text()();
  TextColumn get bankName => text()();

  @override
  Set<Column> get primaryKey => {id};
}
