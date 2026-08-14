
import 'package:drift/drift.dart';

@DataClassName('ResidentData')
class ResidentTable extends Table {
	TextColumn get id => text()();
	TextColumn get name => text()();
	TextColumn get cpf => text()();
	TextColumn get unitId => text()();
	TextColumn get unitTitle => text()();
	TextColumn get unitGroup => text().nullable()();
	IntColumn get unitResidentCount => integer()();
	TextColumn get condominiumId => text()();

	@override
	Set<Column> get primaryKey => {condominiumId, id};
}
