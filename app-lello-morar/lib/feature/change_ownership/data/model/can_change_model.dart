import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/change_ownership/domain/entity/can_change_entity.dart';

part 'can_change_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CanChangeModel {
  bool? canChange;
  String? message;

  CanChangeModel({
    this.canChange,
    this.message,
  });

  factory CanChangeModel.fromJson(Map<String, dynamic> json) =>
      _$CanChangeModelFromJson(json);
  Map<String, dynamic> toJson() => _$CanChangeModelToJson(this);

  static CanChangeModel fromEntity(CanChangeEntity entity) => (CanChangeModel()
    ..canChange = entity.canChange
    ..message = entity.message);

  CanChangeEntity toEntity() => CanChangeEntity()
    ..canChange = this.canChange ?? false
    ..message = this.message;
}
