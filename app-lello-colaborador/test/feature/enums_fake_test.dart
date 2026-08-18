import 'package:colaborador/feature/digital_point/domain/entity/digital_point_capture_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/documents/domain/entity/document_type_enum.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_enum.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_sign_type_enum.dart';
import 'package:colaborador/feature/timesheet/domain/entity/timesheet_status_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lib_facedetection/lib_facedetection.dart';

void main() {
  test('TimesheetStatusEnum tem os três estados', () {
    expect(TimesheetStatusEnum.values, hasLength(3));
  });

  test('TimesheetSignTypeEnum', () {
    expect(TimesheetSignTypeEnum.values, contains(TimesheetSignTypeEnum.espelho));
  });

  test('DocumentTypeEnum inclui holerite e férias', () {
    expect(DocumentTypeEnum.values, contains(DocumentTypeEnum.payStub));
    expect(DocumentTypeEnum.values, contains(DocumentTypeEnum.vacationWarning));
  });

  test('DigitalPointStatusEnum', () {
    expect(DigitalPointStatusEnum.values, contains(DigitalPointStatusEnum.pending));
  });

  test('DigitalPointTypeEnum', () {
    expect(DigitalPointTypeEnum.values, contains(DigitalPointTypeEnum.offline));
  });

  test('DigitalPointCaptureTypeEnumUtils', () {
    expect(
      DigitalPointCaptureTypeEnumUtils.fromTypeCapture(
        typeCaptureEnum: TypeCaptureEnum.manual,
      ),
      DigitalPointCaptureTypeEnum.manual,
    );
    expect(
      DigitalPointCaptureTypeEnumUtils.fromTypeCapture(
        typeCaptureEnum: TypeCaptureEnum.automatic,
      ),
      DigitalPointCaptureTypeEnum.automatic,
    );
    expect(
      DigitalPointCaptureTypeEnumUtils.fromTypeCapture(
        typeCaptureEnum: TypeCaptureEnum.lifeValidation,
      ),
      DigitalPointCaptureTypeEnum.lifeValidation,
    );
  });

  test('DeviceTypeAllowedEnumUtils', () {
    expect(DeviceTypeAllowedEnumUtils.fromString('tablet').isOnlyTablet, isTrue);
    expect(DeviceTypeAllowedEnumUtils.fromString('phone').isOnlyPhone, isTrue);
    expect(DeviceTypeAllowedEnumUtils.fromString('all').isBoth, isTrue);
    expect(DeviceTypeAllowedEnumUtils.fromString('xyz').isBoth, isTrue);
  });

  test('PreferencesNotificationEnum valores', () {
    expect(
      PreferencesNotificationEnum.values,
      contains(PreferencesNotificationEnum.gdp),
    );
  });
}
