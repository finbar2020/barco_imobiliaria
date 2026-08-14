import 'package:drift/drift.dart';

@DataClassName("SpaceData")
class SpaceTable extends Table {
	TextColumn get id => text()();
	TextColumn get name => text().nullable()();
	TextColumn get pictureUrl => text().nullable()();
	TextColumn get condominiumId => text()();

	@override
	Set<Column> get primaryKey => {condominiumId, id};

}