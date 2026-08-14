import 'package:drift/drift.dart';

@DataClassName("ReservationSummaryData")
class ReservationSummaryTable extends Table {
	DateTimeColumn get day => dateTime()();
	TextColumn get condominiumId => text()();
	TextColumn get type => text()();

	@override
	Set<Column> get primaryKey => {condominiumId, day, type};

}