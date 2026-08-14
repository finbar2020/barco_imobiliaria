import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/unit/domain/entity/unit_simple.dart';

part 'unit_simple_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UnitSimpleModel {
  final String id;
  final String? notificationContext;
  final String title;

  UnitSimpleModel({
    required this.id,
    this.notificationContext,
    required this.title,
  });

  factory UnitSimpleModel.fromJson(Map<String, dynamic> json) =>
      _$UnitSimpleModelFromJson(json);
  Map<String, dynamic> toJson() => _$UnitSimpleModelToJson(this);

  factory UnitSimpleModel.fromEntity(UnitSimple entity) {
    return UnitSimpleModel(
      id: entity.id,
      notificationContext: entity.notificationContext,
      title: entity.title,
    );
  }

  UnitSimple toEntity() {
    return UnitSimple(
      id: id,
      notificationContext: notificationContext,
      title: title,
    );
  }
}
