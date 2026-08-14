import 'package:lello/feature/vox/domain/entity/document_reason.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

/// Cache agressivo (TTL 24h) dos motivos de advertência/multa. Os motivos quase
/// nunca mudam, então vale guardá-los por longos períodos. Registrado como
/// lazySingleton para sobreviver à navegação (os blocs são factory). A entrada é
/// por (tipo, condomínio).
class VoxReasonsCache {
  static const Duration ttl = Duration(hours: 24);

  final Map<String, _Entry> _entries = {};

  List<DocumentReason>? get(DocumentType type, String condominiumId) {
    final key = _key(type, condominiumId);
    final entry = _entries[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.storedAt) > ttl) {
      _entries.remove(key);
      return null;
    }
    return entry.reasons;
  }

  void put(
      DocumentType type, String condominiumId, List<DocumentReason> reasons) {
    _entries[_key(type, condominiumId)] = _Entry(reasons, DateTime.now());
  }

  String _key(DocumentType type, String condominiumId) =>
      "${type.name}|$condominiumId";
}

class _Entry {
  final List<DocumentReason> reasons;
  final DateTime storedAt;

  _Entry(this.reasons, this.storedAt);
}
