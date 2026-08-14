import 'package:json_annotation/json_annotation.dart';

import '../../../../shared_features.dart';

part 'notification_resume_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationResumeModel {
  int? totalRead;
  int? totalIgnored;
  int? totalExcluded;
  int? totalReceived;

  NotificationResumeModel({
    this.totalRead,
    this.totalIgnored,
    this.totalExcluded,
    this.totalReceived,
  });

  factory NotificationResumeModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationResumeModelFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationResumeModelToJson(this);

  static NotificationResumeModel? fromEntity(
          NotificationResumeEntity? entity) =>
      entity == null
          ? null
          : (NotificationResumeModel()
            ..totalRead = entity.totalRead
            ..totalIgnored = entity.totalIgnored
            ..totalExcluded = entity.totalExcluded
            ..totalReceived = entity.totalReceived);

  NotificationResumeEntity toEntity() => NotificationResumeEntity()
    ..totalRead = this.totalRead ?? 0
    ..totalIgnored = this.totalIgnored ?? 0
    ..totalExcluded = this.totalExcluded ?? 0
    ..totalReceived = this.totalReceived ?? 0;
}
