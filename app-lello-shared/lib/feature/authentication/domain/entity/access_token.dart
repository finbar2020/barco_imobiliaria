part of shared_features;

class AccessToken {
  String? accessToken;
  String? firebaseToken;
  String? refreshToken;
  String? userId;
  DateTime? expiresIn;
  List<Role>? roles;
  String? selectedRole;
  List<String>? selectedRolePermissions;
  List<String>? customRolePermissions;

  AccessToken();

  bool checkPermission(String feature) {
    if (selectedRolePermissions != null &&
        selectedRolePermissions!.contains(feature)) return true;
    if (customRolePermissions != null &&
        customRolePermissions!.contains(feature)) return true;
    return false;
  }
}
