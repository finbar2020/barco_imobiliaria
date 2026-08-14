import '../data/model/locals_lookup_model.dart';
import '../domain/entity/locals_lookup_entity.dart';

class LocalsLookupModelAdapter {
  static LocalsLookupEntity toEntity(LocalsLookupModel model) {
    return LocalsLookupEntity(
      locals: model.locals
          .map((local) => _localLookupToEntity(local))
          .toList(),
    );
  }

  static LocalLookupEntity _localLookupToEntity(LocalLookupModel model) {
    return LocalLookupEntity(
      id: model.id,
      name: model.name,
      hierarchyLocals: model.hierarchyLocals,
    );
  }
}
