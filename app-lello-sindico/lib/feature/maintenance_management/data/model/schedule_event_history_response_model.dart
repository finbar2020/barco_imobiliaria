import 'package:essentials/essentials.dart';

part 'schedule_event_history_response_model.g.dart';

@JsonSerializable()
class ScheduleEventHistoryResponseModel {
  final bool success;
  final String message;
  final ScheduleEventHistoryDataModel? data;

  const ScheduleEventHistoryResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ScheduleEventHistoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventHistoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScheduleEventHistoryResponseModelToJson(this);
}

@JsonSerializable()
class ScheduleEventHistoryDataModel {
  @JsonKey(name: 'time_description')
  final String? timeDescription;
  @JsonKey(name: 'time_start')
  final String? timeStart;
  @JsonKey(name: 'time_end')
  final String? timeEnd;
  final String? name;
  @JsonKey(name: 'local_or_asset')
  final String? localOrAsset;
  @JsonKey(name: 'dt_start')
  final String? dtStart;
  final String? until;
  final List<ScheduleEventHistoryItemModel>? items;
  @JsonKey(name: 'all_day')
  final bool? allDay;

  const ScheduleEventHistoryDataModel({
    this.timeDescription,
    this.timeStart,
    this.timeEnd,
    this.name,
    this.localOrAsset,
    this.dtStart,
    this.until,
    this.items,
    this.allDay,
  });

  factory ScheduleEventHistoryDataModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventHistoryDataModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScheduleEventHistoryDataModelToJson(this);
}

@JsonSerializable()
class ScheduleEventHistoryItemModel {
  @JsonKey(name: 'dt_start')
  final String? dtStart;
  final String? status;
  final String? until;
  @JsonKey(name: 'activity_type')
  final String? activityType;
  @JsonKey(name: 'description_activity_type')
  final String? descriptionActivityType;
  @JsonKey(name: 'subject_name')
  final String? subjectName;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'updated_at_formatted')
  final String? updatedAtFormatted;
  @JsonKey(name: 'responsible_id')
  final String? responsibleId;
  @JsonKey(name: 'responsible_name')
  final String? responsibleName;

  const ScheduleEventHistoryItemModel({
    this.dtStart,
    this.status,
    this.until,
    this.activityType,
    this.descriptionActivityType,
    this.subjectName,
    this.updatedAt,
    this.updatedAtFormatted,
    this.responsibleId,
    this.responsibleName,
  });

  factory ScheduleEventHistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleEventHistoryItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ScheduleEventHistoryItemModelToJson(this);
}