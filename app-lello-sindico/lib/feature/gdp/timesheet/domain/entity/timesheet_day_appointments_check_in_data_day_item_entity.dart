import 'package:essentials/essentials.dart';

class TimesheetDayAppointmentsCheckInDataDayItem {
  String photoHash;
  DateTime checkInDateTime;
  double distance;
  double latitude;
  double longitude;
  bool outOfRadius;

  TimesheetDayAppointmentsCheckInDataDayItem({
    required this.photoHash,
    required this.checkInDateTime,
    required this.distance,
    required this.latitude,
    required this.longitude,
    required this.outOfRadius,
  });

  String get distanceInKilometers =>
      (distance / 1000).toPrecision(3).toString();
}
