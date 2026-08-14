enum DeviceTypeAllowedEnum {
  phone,
  tablet,
  all,
}

extension DeviceTypeAllowedEnumExtension on DeviceTypeAllowedEnum {
  bool get isOnlyPhone => this == DeviceTypeAllowedEnum.phone;
  bool get isOnlyTablet => this == DeviceTypeAllowedEnum.tablet;
  bool get isBoth => this == DeviceTypeAllowedEnum.all;
}

class DeviceTypeAllowedEnumUtils {
  static DeviceTypeAllowedEnum fromString(String deviceType) {
    switch (deviceType) {
      case 'tablet':
        return DeviceTypeAllowedEnum.tablet;
      case 'phone':
        return DeviceTypeAllowedEnum.phone;
      case 'all':
        return DeviceTypeAllowedEnum.all;
      default:
        return DeviceTypeAllowedEnum.all;
    }
  }
}
