import '../data/model/assets_lookup_model.dart';
import '../domain/entity/assets_lookup_entity.dart';

class AssetsLookupModelAdapter {
  static AssetsLookupEntity toEntity(AssetsLookupModel model) {
    return AssetsLookupEntity(
      assets:
          model.assets.map((asset) => _assetLookupToEntity(asset)).toList(),
    );
  }

  static AssetLookupEntity _assetLookupToEntity(AssetLookupModel model) {
    return AssetLookupEntity(
      id: model.id,
      name: model.name,
      nameWithHierarchyLocals: model.nameWithHierarchyLocals,
    );
  }
}
