import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/me/domain/entity/layout.dart';

part 'layout_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LayoutModel {
  String cod;
  String name;
  String reference;
  String primary;
  String secondary;
  String logoPath;

  LayoutModel({
    this.cod = "",
    this.name = "",
    this.reference = "",
    this.primary = "",
    this.secondary = "",
    this.logoPath = "",
  });

  factory LayoutModel.fromJson(Map<String, dynamic> json) =>
      _$LayoutModelFromJson(json);
  Map<String, dynamic> toJson() => _$LayoutModelToJson(this);

  static LayoutModel? fromEntity(Layout? entity) => entity == null
      ? null
      : (LayoutModel()
        ..cod = entity.cod
        ..name = entity.name
        ..reference = entity.reference
        ..primary = entity.primary
        ..secondary = entity.secondary
        ..logoPath = entity.logoPath);

  Layout toEntity() => Layout()
    ..cod = this.cod
    ..name = this.name
    ..reference = this.reference
    ..primary = this.primary
    ..secondary = this.secondary
    ..logoPath = this.logoPath;
}
