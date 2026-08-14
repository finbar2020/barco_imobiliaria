import 'package:json_annotation/json_annotation.dart';

import '../../domain/entity/condominium_simple.dart';
import 'block_simple_model.dart';

part 'condominium_simple_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumSimpleModel {
  String id;
  String name;
  String reference;
  List<BlockSimpleModel> blocks;

  CondominiumSimpleModel({
    required this.id,
    required this.name,
    required this.reference,
    required this.blocks,
  });

  factory CondominiumSimpleModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumSimpleModelFromJson(json);
  Map<String, dynamic> toJson() => _$CondominiumSimpleModelToJson(this);

  factory CondominiumSimpleModel.fromEntity(CondominiumSimple entity) {
    return CondominiumSimpleModel(
      id: entity.id,
      name: entity.name,
      reference: entity.reference,
      blocks: entity.blocks.map((e) => BlockSimpleModel.fromEntity(e)).toList(),
    );
  }

  CondominiumSimple toEntity() {
    return CondominiumSimple(
      id: id,
      name: name,
      reference: reference,
      blocks: blocks.map((e) => e.toEntity()).toList(),
    );
  }
}
