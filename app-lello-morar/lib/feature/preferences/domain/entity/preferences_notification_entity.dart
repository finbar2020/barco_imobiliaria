class PreferencesNotificationEntity {
  bool? active;
  String? module;

  PreferencesNotificationEntity({this.active, this.module});

  String get title {
    switch (this.module) {
      case "acordos":
        return "notification_module_agreements";
      case "ocorrencia":
        return "notification_module_reports_report";
      case "prestacao_contas":
        return "notification_module_accountability_title";
      case "controle_acesso":
        return "notification_module_access_title";
      case "reserva_area":
        return "notification_module_condominium_hub_manage_space";
      case "mkt":
        return "notification_module_mkt";
      case "correspondencia":
        return "notification_module_mailing_title";
      case "boletos":
        return "notification_module_income_control_billets";
      case "comunicados":
        return "notification_module_announcements";
      case "sistema":
        return "notification_module_others";
      default:
        return "";
    }
  }
}
