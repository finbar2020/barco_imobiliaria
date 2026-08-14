part of shared_features;

class SharedPreferencesKeys {
  static final accessToken = "ACCESS_TOKEN"; //hive
  static final refreshToken = "REFRESH_TOKEN"; //hive
  static final lastRole = "LAST_ROLE"; //hive
  static final lastSwitchRoles = "LAST_SWITCH_ROLES";
  static final updateDateCheck = "UPDATE_DATE_CHECK";
  static final reviewDateCheck = "REVIEW_DATE_CHECK";
  //Manager App
  static final managerSession = "SESSION";
  static final managerBootData = "BOOT_DATA";
  static final managerLastGetMe = "LAST_GET_ME";
  //Owner App
  static final ownerSession = "SESSION";
  static final ownerBootData = "BOOT_DATA";
  static final ownerMessageDataCached = "MESSAGE_DATA_CACHED";

  //Employee App
  static final condoCode = "CONDO_CODE"; //hive
  static final employeeSession = "SESSION";
  static final employeeLastGetMe = "EMPLOYEE_LAST_GET_ME";
  static final employeeDigitalTimesheetStatus = "DIGITAL_TIMESHEET_STATUS";
  static final employeeDialogManagerLastShow = "DIALOG_MANAGER_LAST_SHOW";

  //Packages Name
  static String genericSindico = "app.lello.sindico.viver";
  static String genericMorar = "app.lello.morar.viver";
  static String iosGenericSindico = "app.lello.sindicoviver";
  static String iosGenericMorar = "app.lello.morarviver";
  static final isTabletSession = "TABLET_SESSION"; //hive
  static final sessionStartDate = "TABLET_SESSION_START_DATE"; //hive

  //Notifications Background
  static final backgroundNotification = "BACKGROUND_NOTIFICATION";

  //Ghost Notification
  static final ghostNotificationLogout = "GHOST_NOTIFICATION_LOGOUT";

  //Ghost Notification
  static final digitalPointList = "DIGITAL_POINT_LIST";

  // Register Point
  static get registeredPointDate => "REGISTERED_POINT_DATE";

  //Access Control On Boarding
  static final accessControlOnboarding = "ACCESS_CONTROL_ONBOARDING_#ref";

  //Permission Notification
  static final notificationPermission = "NOTIFICATION_PERMISSION_v2";

  //Comfort to your condo onboarding
  static final comfortToYourCondoOnboarding =
      "COMFORT_TO_YOUR_CONDO_ONBOARDING";

  //Comfort to your condo dialog
  static final showDialogNewToYourCondo = "NEW_YOUR_CONDO";

  //Hive box for banners
  static final banners = "bannersBox";
  static final bannersArgs = "bannersArgsBox";

  //Hive box for documents list cache (stale-while-revalidate)
  static final cachedDocuments = "cachedDocumentsBox";

  static final customURL = "CUSTOM_URL";
}
