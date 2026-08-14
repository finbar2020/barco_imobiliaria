enum SubUserAppAccessEnum {
  withAccess,
  withoutAccess,
  blockedAccess,
  registered,
  available,
}

extension SubUserAppAccessEnumExtension on SubUserAppAccessEnum {
  bool get withAccess => this == SubUserAppAccessEnum.withAccess;

  bool get withoutAccess => this == SubUserAppAccessEnum.withoutAccess;

  bool get blockedAccess => this == SubUserAppAccessEnum.blockedAccess;

  bool get registered => this == SubUserAppAccessEnum.registered;

  bool get available => this == SubUserAppAccessEnum.available;
}
