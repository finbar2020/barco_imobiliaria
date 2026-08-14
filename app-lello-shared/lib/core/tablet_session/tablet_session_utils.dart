part of shared_features;

class TabletSessionUtils {
  static Future<bool> getIsTabletSession(AppOriginEnum? appOrigin) async {
    if (appOrigin != AppOriginEnum.employee) return false;
    var container = await Hive.openBox(SharedPreferencesKeys.isTabletSession);
    try {
      return container.containsKey(SharedPreferencesKeys.condoCode);
    } catch (ex) {
      return false;
    }
  }

  static Future<void> removeIsTabletSession() async {
    var container = await Hive.openBox(SharedPreferencesKeys.isTabletSession);
    await container.clear();
  }

  static Future<bool> checkValidTabletSession(
      Duration sessionMaxDuration) async {
    var sessionDate = await getTabletSessionStartDate();
    if (sessionDate == null) return false;

    if (sessionDate.add(sessionMaxDuration).isBefore(DateTime.now()))
      return false;
    return true;
  }

  static Future<DateTime?> getTabletSessionStartDate() async {
    var container = await Hive.openBox(SharedPreferencesKeys.sessionStartDate);
    try {
      var dateString =
          container.get(SharedPreferencesKeys.sessionStartDate)?.toString();
      if (dateString == null && dateString?.isEmpty == true) return null;
      return DateTime.parse(dateString!);
    } catch (ex) {}
    return null;
  }

  static Future<void> setTabletSessionStartDate(DateTime? expireDate) async {
    var container = await Hive.openBox(SharedPreferencesKeys.sessionStartDate);
    try {
      if (expireDate == null) {
        await container.clear();
      } else {
        await container.put(SharedPreferencesKeys.sessionStartDate,
            expireDate.toIso8601String());
      }
    } catch (ex) {}
  }

  static Future<void> setCondoCode(String condoCode) async {
    var container = await Hive.openBox(SharedPreferencesKeys.isTabletSession);
    try {
      await container.clear();
      await container.put(SharedPreferencesKeys.condoCode, condoCode);
    } catch (ex) {}
  }

  static Future<String?> getCondoCode() async {
    var container = await Hive.openBox(SharedPreferencesKeys.isTabletSession);
    try {
      return (await container.get(SharedPreferencesKeys.condoCode))?.toString();
    } catch (ex) {}
    return null;
  }
}
