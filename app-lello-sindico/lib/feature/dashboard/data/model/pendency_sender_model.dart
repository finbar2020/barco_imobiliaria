import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/dashboard/domain/entity/pendency_sender.dart';

part 'pendency_sender_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PendencySenderModel {
  String? id;
  String? name;
  String? picture;

  PendencySenderModel();

  factory PendencySenderModel.fromJson(Map<String, dynamic> json) =>
      _$PendencySenderModelFromJson(json);
  Map<String, dynamic> toJson() => _$PendencySenderModelToJson(this);

  static PendencySenderModel? fromEntity(PendencySender? entity) =>
      entity == null
          ? null
          : (PendencySenderModel()
            ..id = entity.id
            ..name = entity.name
            ..picture = entity.picture);

  PendencySender toEntity() => PendencySender()
    ..id = this.id
    ..name = this.name
    ..picture = this.picture;
}
