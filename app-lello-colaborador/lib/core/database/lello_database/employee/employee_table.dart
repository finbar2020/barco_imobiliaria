import 'package:drift/drift.dart';

@DataClassName("EmployeeData")
class EmployeeTable extends Table {

	TextColumn get condominiumId => text()();
	TextColumn get id => text()();
	TextColumn get name => text().nullable()();
	DateTimeColumn get dob => dateTime().nullable()();
	TextColumn get role => text().nullable()();
	DateTimeColumn get hiringDate => dateTime().nullable()();
	TextColumn get phone => text().nullable()();
	TextColumn get phone2 => text().nullable()();
	TextColumn get address => text().nullable()();
	TextColumn get addressNumber => text().nullable()();
	TextColumn get addressComplement => text().nullable()();
	RealColumn get salary => real().nullable()();
	TextColumn get schooling => text().nullable()();
	TextColumn get status => text().nullable()();

	@override
	Set<Column> get primaryKey => {condominiumId, id};

}