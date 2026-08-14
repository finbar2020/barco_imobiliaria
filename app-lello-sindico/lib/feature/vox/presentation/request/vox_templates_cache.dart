import 'package:lello/feature/vox/domain/entity/document_template.dart';
import 'package:lello/feature/vox/domain/entity/document_type.dart';

/// Cache agressivo (TTL 24h) dos modelos/templates ("quem assina") de
/// advertência/multa. Raramente mudam. Registrado como lazySingleton para
/// sobreviver à navegação (os blocs são factory). Entrada por (tipo, condomínio).
class VoxTemplatesCache {
  static const Duration ttl = Duration(hours: 24);

  final Map<String, _Entry> _entries = {};

  List<DocumentTemplate>? get(DocumentType type, String condominiumId) {
    final key = _key(type, condominiumId);
    final entry = _entries[key];
    if (entry == null) return null;
    if (DateTime.now().difference(entry.storedAt) > ttl) {
      _entries.remove(key);
      return null;
    }
    return entry.templates;
  }

  void put(DocumentType type, String condominiumId,
      List<DocumentTemplate> templates) {
    _entries[_key(type, condominiumId)] = _Entry(templates, DateTime.now());
  }

  String _key(DocumentType type, String condominiumId) =>
      "${type.name}|$condominiumId";
}

class _Entry {
  final List<DocumentTemplate> templates;
  final DateTime storedAt;

  _Entry(this.templates, this.storedAt);
}
