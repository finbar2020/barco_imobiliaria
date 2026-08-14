import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/me/data/model/unity_model.dart';
import 'package:morar/feature/me/domain/entity/block.dart';

part 'block_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BlockModel {
  String? id;
  String? name;
  List<UnityModel>? units;

  BlockModel();

  factory BlockModel.fromJson(Map<String, dynamic> json) =>
      _$BlockModelFromJson(json);
  Map<String, dynamic> toJson() => _$BlockModelToJson(this);

  static BlockModel? fromEntity(Block? entity) => entity == null
      ? null
      : (BlockModel()
        ..id = entity.id
        ..name = entity.name
        ..units = entity.units);

  Block toEntity() => Block()
    ..id = this.id
    ..name = this.name
    ..units = this.units?.map((e) => e.toEntity()).toList();
}
