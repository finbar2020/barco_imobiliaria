part of shared_features;

class NotificationResumeEntity {
  int? totalRead;
  int? totalIgnored;
  int? totalExcluded;
  int? totalReceived;

  NotificationResumeEntity({
    this.totalRead,
    this.totalIgnored,
    this.totalExcluded,
    this.totalReceived,
  });
}
