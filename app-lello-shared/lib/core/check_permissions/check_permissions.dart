part of shared_features;

class CheckPermissions {
  static Future<bool> location() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        return true;
      } else {
        return false;
      }
    }
    return true;
  }

  static Future<bool> camera() async {
    if (kIsWeb) {
      return true;
    } else {
      var status = await Permission.camera.status;
      if (status.isGranted) {
        return true;
      }
      await Permission.camera.request();
      status = await Permission.camera.status;
      if (!status.isGranted) {
        return false;
      } else {
        return true;
      }
    }
  }

  static Future<bool> storage() async {
    var status = Permission.storage;

    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 33) status = Permission.mediaLibrary;
    }

    bool isGranted = await status.isGranted;
    if (isGranted) {
      return true;
    }
    await status.request();
    isGranted = await status.isGranted;
    if (isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
