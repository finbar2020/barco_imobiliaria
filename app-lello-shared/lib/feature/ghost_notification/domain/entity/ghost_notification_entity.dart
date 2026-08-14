part of shared_features;

class GhostNotificationEntity {
  String? id;
  String? token;
  String? appType;
  String? recivedDate;
  String? appVersion;
  String? deviceName;
  String? logedUserCpf;
  String? logedUserId;
  dynamic customData;

  GhostNotificationEntity({
    this.id,
    this.token,
    this.appType,
    this.recivedDate,
    this.appVersion,
    this.deviceName,
    this.logedUserCpf,
    this.logedUserId,
    this.customData,
  });
}
