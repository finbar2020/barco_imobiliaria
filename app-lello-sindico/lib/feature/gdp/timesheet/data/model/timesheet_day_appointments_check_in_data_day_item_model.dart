import 'package:json_annotation/json_annotation.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_day_appointments_check_in_data_day_item_entity.dart';

part 'timesheet_day_appointments_check_in_data_day_item_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class TimesheetDayAppointmentsCheckInDataDayItemModel {
  String photoHash;
  DateTime checkInDateTime;
  double distance;
  double latitude;
  double longitude;
  bool outOfRadius;

  TimesheetDayAppointmentsCheckInDataDayItemModel({
    required this.photoHash,
    required this.checkInDateTime,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.outOfRadius,
  });

  factory TimesheetDayAppointmentsCheckInDataDayItemModel.fromJson(
          Map<String, dynamic> json) =>
      _$TimesheetDayAppointmentsCheckInDataDayItemModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$TimesheetDayAppointmentsCheckInDataDayItemModelToJson(this);

  TimesheetDayAppointmentsCheckInDataDayItem toEntity() =>
      TimesheetDayAppointmentsCheckInDataDayItem(
        photoHash: photoHash,
        checkInDateTime: checkInDateTime,
        distance: distance,
        latitude: latitude,
        longitude: longitude,
        outOfRadius: outOfRadius,
      );
}
