import 'package:lello/feature/vox/domain/entity/document.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

/// Cache em memória do histórico de documentos, com TTL. Registrado como
/// lazySingleton para sobreviver à navegação (os blocs são factory). A entrada é
/// por (tipo, condomínio); o pull-to-refresh força a recarga via [invalidate].
class VoxHistoryCache {
  static const Duration ttl = Duration(hours: 1);

  final Map<String, _Entry> _entries = {};

  /// Retorna a lista cacheada se ainda dentro do TTL; senão `null` (e descarta a
  /// entrada expirada).
  List<Document>? get(DocumentType type, String condominiumId) {
    final key = _key(type, condominiumId);
    final entry = _entries[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.storedAt) > ttl) {
      _entries.remove(key);
      return null;
    }
    return entry.documents;
  }

  void put(DocumentType type, String condominiumId, List<Document> documents) {
    _entries[_key(type, condominiumId)] = _Entry(documents, DateTime.now());
  }

  void invalidate(DocumentType type, String condominiumId) {
    _entries.remove(_key(type, condominiumId));
  }

  String _key(DocumentType type, String condominiumId) =>
      "${type.name}|$condominiumId";
}

class _Entry {
  final List<Document> documents;
  final DateTime storedAt;

  _Entry(this.documents, this.storedAt);
}
