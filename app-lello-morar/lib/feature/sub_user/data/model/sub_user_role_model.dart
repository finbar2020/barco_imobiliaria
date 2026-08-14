import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user_role.dart';

part 'sub_user_role_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SubUserRoleModel {
  String? role;
  String? description;
  bool? enabled;

  SubUserRoleModel();

  factory SubUserRoleModel.fromJson(Map<String, dynamic> json) =>
      _$SubUserRoleModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubUserRoleModelToJson(this);

  static SubUserRoleModel? fromEntity(SubUserRole? entity) => entity == null
      ? null
      : (SubUserRoleModel()
        ..role = entity.role
        ..enabled = entity.enabled
        ..description = entity.description);

  SubUserRole toEntity() => SubUserRole(
        role: role,
        description: description,
        enabled: enabled,
      );
}
