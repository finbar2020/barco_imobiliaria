class NotificationsPreferences {
  String? idPendencyRuleReference;
  String? idPendencyRule;
  int reference;
  int? quarentineDays;
  String? lastExecution;
  bool active;
  String module;
  String configType;
  String altText;
  List<NotificationsPreferencesType> listType;

  NotificationsPreferences({
    this.idPendencyRuleReference,
    this.idPendencyRule,
    required this.reference,
    this.quarentineDays,
    this.lastExecution,
    required this.active,
    required this.module,
    required this.configType,
    required this.altText,
    required this.listType,
  });
}

enum NotificationsPreferencesType { email, notification }
