import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

abstract class DigitalPointEvent extends Equatable {
  const DigitalPointEvent();

  @override
  List<Object?> get props => [];
}

class StatCameraCaptureEvent extends DigitalPointEvent {
  final DigitalTimesheetStatusEnum statusEnum;
  final String? condoRef;
  final EmployeeInfo? employee;

  const StatCameraCaptureEvent({
    required this.statusEnum,
    this.condoRef,
    this.employee,
  });

  @override
  List<Object?> get props => [statusEnum, condoRef, employee];
}

class SendFaceEvent extends DigitalPointEvent {
  final CameraViewPickerResult image;
  final DigitalTimesheetStatusEnum statusEnum;
  final Map<String, DateTime?>? mapRegisteredPointDate;
  final bool mustSave;

  const SendFaceEvent({
    this.mapRegisteredPointDate,
    required this.mustSave,
    required this.image,
    required this.statusEnum,
  });

  @override
  List<Object?> get props =>
      [image, statusEnum, mapRegisteredPointDate, mustSave];
}

class SavePointEvent extends DigitalPointEvent {
  final CameraViewPickerResult image;
  final String? condoRef;
  final EmployeeInfo? employee;

  const SavePointEvent({
    required this.image,
    this.condoRef,
    this.employee,
  });

  @override
  List<Object?> get props => [image, condoRef, employee];
}

class CancelPointEvent extends DigitalPointEvent {
  const CancelPointEvent();
}
