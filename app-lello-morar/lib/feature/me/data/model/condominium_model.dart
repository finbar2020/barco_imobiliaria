import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/me/data/model/block_model.dart';
import 'package:morar/feature/me/data/model/layout_model.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';

part 'condominium_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumModel {
  String? id;

  String? name;
  String? address;
  String? reference;
  List<BlockModel?>? blocks;
  String? regulationUrl;
  bool? active_manager;
  bool? useFacialBiometric;
  LayoutModel? layout;

  CondominiumModel();

  factory CondominiumModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumModelFromJson(json);
  Map<String, dynamic> toJson() => _$CondominiumModelToJson(this);

  static CondominiumModel? fromEntity(Condominium? entity) => entity == null
      ? null
      : (CondominiumModel()
        ..id = entity.id
        ..name = entity.name
        ..regulationUrl = entity.regulationUrl
        ..reference = entity.reference
        ..address = entity.address
        ..blocks = entity.blocks?.map((e) => BlockModel.fromEntity(e)).toList()
        ..active_manager = entity.active_manager
        ..useFacialBiometric = entity.useFacialBiometric
        ..layout = LayoutModel.fromEntity(entity.layout));

  Condominium toEntity() => Condominium()
    ..id = this.id
    ..name = this.name
    ..address = this.address
    ..reference = this.reference
    ..regulationUrl = this.regulationUrl
    ..blocks = this.blocks?.map((e) => e!.toEntity()).toList()
    ..active_manager = this.active_manager
    ..useFacialBiometric = this.useFacialBiometric ?? false
    ..layout = this.layout?.toEntity();
}
