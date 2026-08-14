import 'package:json_annotation/json_annotation.dart';
import 'package:shared_features/shared_features.dart';

part 'role_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RoleModel {
  String? context;
  String? roleName;

  RoleModel();

  factory RoleModel.fromJson(Map<String, dynamic> json) =>
      _$RoleModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoleModelToJson(this);

  static RoleModel? fromEntity(Role? entity) => entity == null
      ? null
      : (RoleModel()
        ..context = entity.context
        ..roleName = entity.roleName);

  Role toEntity() => Role()
    ..context = this.context
    ..roleName = this.roleName;
}
