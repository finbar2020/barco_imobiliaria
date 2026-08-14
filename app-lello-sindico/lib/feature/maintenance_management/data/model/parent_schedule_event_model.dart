import 'package:essentials/essentials.dart';

part 'parent_schedule_event_model.g.dart';

@JsonSerializable()
class ParentScheduleEventModel {
  final String? id;
  final String? name;

  ParentScheduleEventModel({
    this.id,
    this.name,
  });

  factory ParentScheduleEventModel.fromJson(Map<String, dynamic> json) =>
      _$ParentScheduleEventModelFromJson(json);

  Map<String, dynamic> toJson() => _$ParentScheduleEventModelToJson(this);
}
