part of shared_features;

enum GhostNotificationType {
  imAlive,
  userAppData,
  detailedLog,
  dataCleaning,
  timesheetReport,
  updateUser,
  updateFCMToken,
}

class GhostNotificationTypeUtils {
  static GhostNotificationType stringToGhostNotificationEnum(String type) {
    switch (type) {
      case "ESTOU_VIVO":
        return GhostNotificationType.imAlive;
      case "DADOS_APP":
        return GhostNotificationType.userAppData;
      case "LOG_DETALHADO":
        return GhostNotificationType.detailedLog;
      case "LIMPEZA_DADOS":
        return GhostNotificationType.dataCleaning;
      case "RELATORIO_PONTO":
        return GhostNotificationType.timesheetReport;
      case "ATUALIZAR_USUARIO":
        return GhostNotificationType.updateUser;
      case "UPDATE_FCM_TOKEN":
        return GhostNotificationType.updateFCMToken;
      default:
        return GhostNotificationType.imAlive;
    }
  }
}
