import 'package:colaborador/feature/me/domain/entity/geographic_coordinates.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';

import '../enum/device_type_allowed_enum.dart';

class Condominium {
  final String id;
  final String name;
  final String reference;
  final String jobPosition;
  final String workShift;
  final String workLeaveDescription;
  final bool shouldIgnoreDigitalPoint;
  final List<WorkShiftDetails> workShiftDetails;
  final bool usesDigitalTimesheet;
  final DigitalTimesheetStatusEnum digitalTimesheetStatus;
  final GeographicCoordinates? geographicCoordinates;
  final DeviceTypeAllowedEnum deviceTypeEnum;

  bool get canRegisterDigitalPointStatus =>
      digitalTimesheetStatus == DigitalTimesheetStatusEnum.approved;

  bool get isDigitalPointBlockedByLeave =>
      canRegisterDigitalPointStatus && shouldIgnoreDigitalPoint;

  Condominium({
    required this.id,
    required this.name,
    required this.reference,
    required this.jobPosition,
    required this.workLeaveDescription,
    required this.shouldIgnoreDigitalPoint,
    required this.workShift,
    required this.workShiftDetails,
    this.digitalTimesheetStatus = DigitalTimesheetStatusEnum.notActivated,
    this.usesDigitalTimesheet = false,
    required this.geographicCoordinates,
    this.deviceTypeEnum = DeviceTypeAllowedEnum.all,
  });

  factory Condominium.clone(Condominium condominium) => Condominium(
        id: condominium.id,
        name: condominium.name,
        reference: condominium.reference,
        jobPosition: condominium.jobPosition,
        workShift: condominium.workShift,
        workLeaveDescription: condominium.workLeaveDescription,
        shouldIgnoreDigitalPoint: condominium.shouldIgnoreDigitalPoint,
        digitalTimesheetStatus: condominium.digitalTimesheetStatus,
        usesDigitalTimesheet: condominium.usesDigitalTimesheet,
        geographicCoordinates: condominium.geographicCoordinates,
        workShiftDetails: condominium.workShiftDetails
            .map((e) => WorkShiftDetails.clone(e))
            .toList(),
        deviceTypeEnum: condominium.deviceTypeEnum,
      );

  String get jobPositionFormatted {
    if (jobPosition.length < 2) {
      return jobPosition;
    }
    return "${jobPosition.substring(0, 1).toUpperCase()}${jobPosition.substring(1).toLowerCase()}";
  }

  List<WorkShiftDetails> nextWorkSchedule(int days) {
    var today = DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day, 0, 0, 0);

    var lastDay =
        today.add(Duration(days: days + 1)).add(const Duration(seconds: -1));

    return workShiftDetails
        .where((element) =>
            (element.date.isAfter(today) && element.date.isBefore(lastDay)) ||
            element.date.compareTo(today) == 0)
        .toList();
  }
}
