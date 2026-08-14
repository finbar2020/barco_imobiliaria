import 'package:drift/drift.dart';

@DataClassName("ResinRefundsData")
class ResinRefundsTable extends Table {
  TextColumn get condominiumId => text()();
  TextColumn get id => text()();
  TextColumn get destinationAccountId => text()();
  DateTimeColumn get requestDate => dateTime().nullable()();
  TextColumn get requester => text()();
  TextColumn get status => text()();
  TextColumn get type => text()();
  RealColumn get value => real()();
  TextColumn get protocol => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get canEdit => boolean()();
  BoolColumn get canCancel => boolean()();
  TextColumn get inconcistency => text()();

  @override
  Set<Column> get primaryKey => {id};
}
