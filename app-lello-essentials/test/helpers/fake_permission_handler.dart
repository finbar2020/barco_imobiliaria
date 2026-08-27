import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

class FakePermissionHandler extends PermissionHandlerPlatform {
  FakePermissionHandler({this.status = PermissionStatus.denied});

  PermissionStatus status;
  bool settingsOpened = false;
  int requestCount = 0;

  @override
  Future<PermissionStatus> checkPermissionStatus(Permission permission) async =>
      status;

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    requestCount++;
    status = PermissionStatus.granted;
    return {for (final p in permissions) p: status};
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpened = true;
    return true;
  }
}

void setFakePermissionHandler(FakePermissionHandler handler) {
  PermissionHandlerPlatform.instance = handler;
}
