import 'package:json_annotation/json_annotation.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';

part 'space_calendar_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SpaceCalendarModel {
  List<String>? lockedDays;
  List<String>? alreadyReservatedDays;
  List<String>? raffledDays;
  List<String>? freeToReserveDays;

  SpaceCalendarModel({
    this.lockedDays,
    this.alreadyReservatedDays,
    this.raffledDays,
    this.freeToReserveDays,
  });

  factory SpaceCalendarModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceCalendarModelFromJson(json);
  Map<String, dynamic> toJson() => _$SpaceCalendarModelToJson(this);

  static SpaceCalendarModel? fromEntity(SpaceCalendarResponse? entity) =>
      entity == null
          ? null
          : (SpaceCalendarModel()
            ..lockedDays = entity.lockedDays
            ..alreadyReservatedDays = entity.alreadyReservatedDays
            ..freeToReserveDays = entity.freeToReserveDays
            ..raffledDays = entity.raffledDays);

  SpaceCalendarResponse toEntity() => SpaceCalendarResponse()
    ..alreadyReservatedDays = this.alreadyReservatedDays
    ..freeToReserveDays = this.freeToReserveDays
    ..lockedDays = this.lockedDays
    ..raffledDays = this.raffledDays;
}
