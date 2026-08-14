enum AcessSettingsPermissionsDeniedItemEnum {
  cam,
  files,
  location,
}

class AcessSettingsPermissionsDeniedItem {
  final AcessSettingsPermissionsDeniedItemEnum item;
  final bool isColaboradorApp;

  AcessSettingsPermissionsDeniedItem({
    required this.item,
    this.isColaboradorApp = false,
  });

  String get titleKey {
    if (isColaboradorApp) {
      switch (item) {
        case AcessSettingsPermissionsDeniedItemEnum.cam:
          return "access_settings_permission_denied_title_cam_colaborador";
        case AcessSettingsPermissionsDeniedItemEnum.files:
          return "access_settings_permission_denied_title_files_colaborador";
        case AcessSettingsPermissionsDeniedItemEnum.location:
          return "access_settings_permission_denied_title_location_colaborador";
      }
    } else {
      switch (item) {
        case AcessSettingsPermissionsDeniedItemEnum.cam:
          return "access_settings_permission_denied_title_cam";
        case AcessSettingsPermissionsDeniedItemEnum.files:
          return "access_settings_permission_denied_title_files";
        case AcessSettingsPermissionsDeniedItemEnum.location:
          return "access_settings_permission_denied_title_location";
      }
    }
  }

  String get subTitleKey {
    if (isColaboradorApp) {
      switch (item) {
        case AcessSettingsPermissionsDeniedItemEnum.cam:
          return "access_settings_permission_denied_subtitle_cam_colaborador";
        case AcessSettingsPermissionsDeniedItemEnum.files:
          return "access_settings_permission_denied_subtitle_files_colaborador";
        case AcessSettingsPermissionsDeniedItemEnum.location:
          return "access_settings_permission_denied_subtitle_location_colaborador";
      }
    } else {
      switch (item) {
        case AcessSettingsPermissionsDeniedItemEnum.cam:
          return "access_settings_permission_denied_subtitle_cam";
        case AcessSettingsPermissionsDeniedItemEnum.files:
          return "access_settings_permission_denied_subtitle_files";
        case AcessSettingsPermissionsDeniedItemEnum.location:
          return "access_settings_permission_denied_subtitle_location";
      }
    }
  }

  String get icon {
    if (isColaboradorApp) {
      switch (item) {
        case AcessSettingsPermissionsDeniedItemEnum.cam:
          return "assets/ic_cam_colaborador.svg";
        case AcessSettingsPermissionsDeniedItemEnum.files:
          return "assets/ic_files_colaborador.svg";
        case AcessSettingsPermissionsDeniedItemEnum.location:
          return "assets/ic_location_colaborador.svg";
      }
    } else {
      switch (item) {
        case AcessSettingsPermissionsDeniedItemEnum.cam:
          return "assets/ic_cam.svg";
        case AcessSettingsPermissionsDeniedItemEnum.files:
          return "assets/ic_files.svg";
        case AcessSettingsPermissionsDeniedItemEnum.location:
          return "assets/ic_location.svg";
      }
    }
  }

  String get goToSettingsButtonKey {
    return isColaboradorApp
        ? "access_settings_permission_denied_go_config_colaborador"
        : "access_settings_permission_denied_go_config";
  }

  String get backButtonKey {
    return isColaboradorApp ? "back_colaborador" : "back";
  }
}
