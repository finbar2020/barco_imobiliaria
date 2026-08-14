import 'package:hive/hive.dart';
import 'package:shared_features/shared_features.dart';
import 'cached_documents_hive_model.dart';

/// Cache em Hive da lista de documentos (stale-while-revalidate). Substitui o
/// DAO Drift do app antigo por um store autossuficiente, no padrão do
/// `BannersDao` do shared.
class CachedDocumentsStore {
  /// Janela de frescor da lista. Fora disso, revalida em background.
  static const Duration ttl = Duration(hours: 24);

  Future<Box<CachedDocumentsHive>> get _box async {
    if (Hive.isAdapterRegistered(CachedDocumentsHiveAdapter().typeId) ==
        false) {
      Hive.registerAdapter<CachedDocumentsHive>(CachedDocumentsHiveAdapter());
    }
    return await Hive.openBox<CachedDocumentsHive>(
        SharedPreferencesKeys.cachedDocuments);
  }

  String _key(String condominiumId, String unitId, String documentType) =>
      '$condominiumId|$unitId|$documentType';

  Future<CachedDocumentsHive?> read(
      String condominiumId, String unitId, String documentType) async {
    return (await _box).get(_key(condominiumId, unitId, documentType));
  }

  Future<void> upsert(String condominiumId, String unitId, String documentType,
      String documentsJson, DateTime now) async {
    final box = await _box;
    final entry = CachedDocumentsHive()
      ..key = _key(condominiumId, unitId, documentType)
      ..documentsJson = documentsJson
      ..lastFetchedAt = now.millisecondsSinceEpoch
      ..lastErrorAt = null;
    await box.put(entry.key, entry);
  }

  Future<void> markFailed(String condominiumId, String unitId,
      String documentType, DateTime now) async {
    final existing =
        (await _box).get(_key(condominiumId, unitId, documentType));
    if (existing != null) {
      existing.lastErrorAt = now.millisecondsSinceEpoch;
      await existing.save();
    }
  }

  Future<void> clear() async => (await _box).clear();
}
