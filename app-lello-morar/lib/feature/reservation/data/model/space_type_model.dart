import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/domain/entity/space_type.dart';

part 'space_type_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpaceTypeModel {
  String? id;
  String? description;

  SpaceTypeModel({
    this.id,
    this.description,
  });

  factory SpaceTypeModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceTypeModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceTypeModelToJson(this);

  static SpaceTypeModel? fromEntity(SpaceType? entity) => entity == null
      ? null
      : (SpaceTypeModel()
        ..id = entity.id
        ..description = entity.description);

  SpaceType toEntity() => SpaceType()
    ..id = this.id
    ..description = this.description;
}
