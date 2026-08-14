// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/condominium/domain/entity/block_simple.dart';

import 'package:lello/feature/unit/data/model/unit_simple_model.dart';

part 'block_simple_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BlockSimpleModel {
  final String id;
  final String name;
  final List<UnitSimpleModel> units;

  BlockSimpleModel({
    required this.id,
    required this.name,
    required this.units,
  });

  factory BlockSimpleModel.fromJson(Map<String, dynamic> json) =>
      _$BlockSimpleModelFromJson(json);
  Map<String, dynamic> toJson() => _$BlockSimpleModelToJson(this);

  factory BlockSimpleModel.fromEntity(BlockSimple entity) {
    return BlockSimpleModel(
      id: entity.id,
      name: entity.name,
      units: entity.units.map((e) => UnitSimpleModel.fromEntity(e)).toList(),
    );
  }

  BlockSimple toEntity() {
    return BlockSimple(
      id: id,
      name: name,
      units: units.map((e) => e.toEntity()).toList(),
    );
  }
}
