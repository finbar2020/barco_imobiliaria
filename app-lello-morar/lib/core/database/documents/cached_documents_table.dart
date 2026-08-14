import 'package:drift/drift.dart';

@DataClassName("CachedDocumentsData")
class CachedDocumentsTable extends Table {
  TextColumn get condominiumId => text()();
  TextColumn get unitId => text()();
  TextColumn get documentType => text()();
  TextColumn get documentsJson => text()();
  IntColumn get lastFetchedAt => integer()();
  IntColumn get lastErrorAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {condominiumId, unitId, documentType};
}
