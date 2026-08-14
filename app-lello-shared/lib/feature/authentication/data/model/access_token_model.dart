import 'package:shared_features/feature/authentication/data/model/role_model.dart';
import 'package:shared_features/shared_features.dart';
import 'package:essentials/essentials.dart';

part 'access_token_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccessTokenModel {
  String? accessToken;
  String? refreshToken;
  String? firebaseToken;
  String? userId;
  int? expiresIn;
  List<RoleModel>? roles;
  String? selectedRole;
  List<String>? selectedRolePermissions;
  List<String>? customRolePermissions;

  AccessTokenModel();

  factory AccessTokenModel.fromJson(Map<String, dynamic> json) =>
      _$AccessTokenModelFromJson(json);
  Map<String, dynamic> toJson() => _$AccessTokenModelToJson(this);

  static AccessTokenModel? fromEntity(AccessToken? entity) => entity == null
      ? null
      : (AccessTokenModel()
        ..accessToken = entity.accessToken
        ..refreshToken = entity.refreshToken
        ..firebaseToken = entity.firebaseToken
        ..expiresIn = (entity.expiresIn?.millisecondsSinceEpoch ?? 0) ~/ 1000
        ..roles = entity.roles
        ..selectedRolePermissions = entity.selectedRolePermissions
        ..selectedRole = entity.selectedRole
        ..userId = entity.userId);

  AccessToken toEntity() => AccessToken()
    ..accessToken = this.accessToken
    ..refreshToken = this.refreshToken
    ..firebaseToken = this.firebaseToken
    ..expiresIn = this.expiresIn != null
        ? DateTime.fromMillisecondsSinceEpoch(this.expiresIn! * 1000)
        : null
    ..roles = this.roles?.map((e) => e.toEntity()).toList()
    ..userId = this.userId
    ..selectedRole = this.selectedRole
    ..selectedRolePermissions = mapAllRoles(this.selectedRolePermissions ?? []);

  List<String> mapAllRoles(List<String> roles) {
    List<String> allRoles = [];
    roles.forEach((r) {
      List<String> sub = r.split("."), prev = [];
      sub.forEach((element) {
        prev.add(element);
        allRoles.add(prev.join("."));
      });
    });
    List<String> allRolesShort = allRoles.toSet().toList();
    return allRolesShort;
  }
}
