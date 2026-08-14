import 'package:drift/drift.dart';
import 'package:morar/core/database/documents/cached_documents_table.dart';
import 'package:morar/core/database/lello_database.dart';

part 'cached_documents_dao.g.dart';

@DriftAccessor(tables: [CachedDocumentsTable])
class CachedDocumentsDao extends DatabaseAccessor<LelloDatabase>
    with _$CachedDocumentsDaoMixin {
  static const Duration ttl = Duration(hours: 24);

  final LelloDatabase database;
  CachedDocumentsDao(this.database) : super(database);

  Future<CachedDocumentsData?> read(
      String condominiumId, String unitId, String documentType) {
    return (select(database.cachedDocumentsTable)
          ..where((t) =>
              t.condominiumId.equals(condominiumId) &
              t.unitId.equals(unitId) &
              t.documentType.equals(documentType)))
        .getSingleOrNull();
  }

  Future<void> upsert(String condominiumId, String unitId, String documentType,
      String documentsJson, DateTime now) {
    return into(database.cachedDocumentsTable).insert(
      CachedDocumentsTableCompanion.insert(
        condominiumId: condominiumId,
        unitId: unitId,
        documentType: documentType,
        documentsJson: documentsJson,
        lastFetchedAt: now.millisecondsSinceEpoch,
      ),
      mode: InsertMode.replace,
    );
  }

  Future<void> markFailed(String condominiumId, String unitId,
      String documentType, DateTime now) {
    return (update(database.cachedDocumentsTable)
          ..where((t) =>
              t.condominiumId.equals(condominiumId) &
              t.unitId.equals(unitId) &
              t.documentType.equals(documentType)))
        .write(CachedDocumentsTableCompanion(
      lastErrorAt: Value(now.millisecondsSinceEpoch),
    ));
  }

  Future<int> clear() => delete(database.cachedDocumentsTable).go();
}
