import 'package:drift/drift.dart';

@DataClassName("ChatContactData")
class ChatContactTable extends Table {
	TextColumn get id => text()();
	TextColumn get condominiumId => text()();
	TextColumn get unitId => text().nullable()();
	TextColumn get unitTitle => text().nullable()();
	TextColumn get unitGroup => text().nullable()();
	TextColumn get phone => text().nullable()();

	@override
	Set<Column> get primaryKey => {condominiumId, id};

}