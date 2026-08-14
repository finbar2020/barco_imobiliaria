import 'package:essentials/essentials.dart';

part 'assets_lookup_model.g.dart';

@JsonSerializable()
class AssetLookupModel {
  final String id;
  final String name;
  final String? nameWithHierarchyLocals;

  AssetLookupModel({
    required this.id,
    required this.name,
    this.nameWithHierarchyLocals,
  });

  factory AssetLookupModel.fromJson(Map<String, dynamic> json) =>
      _$AssetLookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetLookupModelToJson(this);
}

@JsonSerializable()
class AssetsLookupModel {
  final List<AssetLookupModel> assets;

  AssetsLookupModel({
    required this.assets,
  });

  factory AssetsLookupModel.fromJson(Map<String, dynamic> json) =>
      _$AssetsLookupModelFromJson(json);

  Map<String, dynamic> toJson() => _$AssetsLookupModelToJson(this);
}
