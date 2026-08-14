class ScheduleEventHistoryEntity {
  final String timeDescription;
  final String timeStart;
  final String name;
  final String localOrAsset;
  final String dtStart;
  final String until;
  final List<ScheduleEventHistoryItemEntity> items;
  final bool allDay;

  ScheduleEventHistoryEntity({
    required this.timeDescription,
    required this.timeStart,
    required this.name,
    required this.localOrAsset,
    required this.dtStart,
    required this.until,
    required this.items,
    required this.allDay,
  });
}

class ScheduleEventHistoryItemEntity {
  final String dtStart;
  final String status;
  final String until;
  final String? activityType;
  final String? descriptionActivityType;
  final String? subjectName;
  final String? updatedAt;
  final String? updatedAtFormatted;
  final String? responsibleId;
  final String? responsibleName;

  ScheduleEventHistoryItemEntity({
    required this.dtStart,
    required this.status,
    required this.until,
    this.activityType,
    this.descriptionActivityType,
    this.subjectName,
    this.updatedAt,
    this.updatedAtFormatted,
    this.responsibleId,
    this.responsibleName,
  });
}