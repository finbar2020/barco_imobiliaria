class AssetLookupEntity {
  final String id;
  final String name;
  final String? nameWithHierarchyLocals;

  AssetLookupEntity({
    required this.id,
    required this.name,
    this.nameWithHierarchyLocals,
  });
}

class AssetsLookupEntity {
  final List<AssetLookupEntity> assets;

  AssetsLookupEntity({
    required this.assets,
  });
}
