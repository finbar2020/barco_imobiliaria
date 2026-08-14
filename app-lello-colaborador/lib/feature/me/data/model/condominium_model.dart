import 'package:colaborador/feature/me/data/model/geographic_coordinates_model.dart';
import 'package:colaborador/feature/me/data/model/work_shift_details_model.dart';
import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:essentials/essentials.dart';

import '../../domain/enum/device_type_allowed_enum.dart';

part 'condominium_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CondominiumModel {
  final String id;
  final String name;
  final String reference;
  final String jobPosition;
  final String workShift;
  final String workLeaveDescription;
  final bool shouldIgnoreDigitalPoint;
  final List<WorkShiftDetailsModel> workShiftDetails;
  final String? digitalTimesheetStatus;
  final bool usesDigitalTimesheet;
  final GeographicCoordinatesModel? geographicCoordinates;
  final String digitalTimesheetDeviceAllowed;

  CondominiumModel({
    this.id = "",
    this.name = "",
    this.reference = "",
    this.jobPosition = "",
    this.workShift = "",
    this.workLeaveDescription = "",
    this.shouldIgnoreDigitalPoint = false,
    this.workShiftDetails = const [],
    this.digitalTimesheetStatus,
    this.usesDigitalTimesheet = false,
    this.geographicCoordinates,
    this.digitalTimesheetDeviceAllowed = 'all',
  });

  factory CondominiumModel.fromJson(Map<String, dynamic> json) =>
      _$CondominiumModelFromJson(json);
  Map<String, dynamic> toJson() => _$CondominiumModelToJson(this);

  static CondominiumModel? fromEntity(Condominium? condominium) =>
      condominium == null
          ? null
          : CondominiumModel(
              id: condominium.id,
              name: condominium.name,
              reference: condominium.reference,
              jobPosition: condominium.jobPosition,
              workShift: condominium.workShift,
              shouldIgnoreDigitalPoint: condominium.shouldIgnoreDigitalPoint,
              workLeaveDescription: condominium.workLeaveDescription,
              digitalTimesheetStatus:
                  enumToString(condominium.digitalTimesheetStatus),
              usesDigitalTimesheet: condominium.usesDigitalTimesheet,
              geographicCoordinates: GeographicCoordinatesModel.fromEntity(
                  condominium.geographicCoordinates),
              workShiftDetails: condominium.workShiftDetails
                  .map((e) => WorkShiftDetailsModel.fromEntity(e))
                  .cast<WorkShiftDetailsModel>()
                  .toList(),
              digitalTimesheetDeviceAllowed:
                  enumToString(condominium.deviceTypeEnum) ?? 'all',
            );

  Condominium toEntity() => Condominium(
        id: id,
        name: name,
        reference: reference,
        jobPosition: jobPosition,
        workShift: workShift,
        shouldIgnoreDigitalPoint: shouldIgnoreDigitalPoint,
        workLeaveDescription: workLeaveDescription,
        digitalTimesheetStatus: stringToEnum(
                DigitalTimesheetStatusEnum.values, digitalTimesheetStatus) ??
            DigitalTimesheetStatusEnum.declined,
        usesDigitalTimesheet: usesDigitalTimesheet,
        geographicCoordinates: geographicCoordinates?.toEntity(),
        workShiftDetails: workShiftDetails
            .map((e) => e.toEntity())
            .cast<WorkShiftDetails>()
            .toList(),
        deviceTypeEnum: stringToEnum(
                DeviceTypeAllowedEnum.values, digitalTimesheetDeviceAllowed) ??
            DeviceTypeAllowedEnum.all,
      );
}
