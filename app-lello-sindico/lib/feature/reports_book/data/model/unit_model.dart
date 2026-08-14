import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/reports_book/domain/entity/unit.dart';

part 'unit_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitModel {
  String? id;
  String? name;

  UnitModel({
    this.id,
    this.name,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) =>
      _$UnitModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnitModelToJson(this);

  static UnitModel? fromEntity(Unit? entity) => entity == null
      ? null
      : (UnitModel()
        ..id = entity.id
        ..name = entity.name);

  Unit toEntity() => Unit()
    ..id = this.id
    ..name = this.name;
}
