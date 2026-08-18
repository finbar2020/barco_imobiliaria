import 'dart:io';

import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_capture_type_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_status_enum.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point_type_enum.dart';
import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/entity/geographic_coordinates.dart';
import 'package:colaborador/feature/me/domain/entity/me.dart';
import 'package:colaborador/feature/me/domain/entity/work_shift_details.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter_test/flutter_test.dart';

Condominium testCondominium({
  String id = 'c1',
  String jobPosition = 'porteiro',
  bool shouldIgnoreDigitalPoint = false,
  List<WorkShiftDetails>? workShiftDetails,
  DeviceTypeAllowedEnum deviceTypeEnum = DeviceTypeAllowedEnum.all,
  DigitalTimesheetStatusEnum digitalTimesheetStatus =
      DigitalTimesheetStatusEnum.notActivated,
}) {
  return Condominium(
    id: id,
    name: 'Torre Lello',
    reference: 'R1',
    jobPosition: jobPosition,
    workLeaveDescription: 'afastado',
    shouldIgnoreDigitalPoint: shouldIgnoreDigitalPoint,
    workShift: 'diurno',
    workShiftDetails: workShiftDetails ?? const [],
    geographicCoordinates: GeographicCoordinates(
      longitude: '-46.6',
      latitude: '-23.5',
    ),
    deviceTypeEnum: deviceTypeEnum,
    digitalTimesheetStatus: digitalTimesheetStatus,
  );
}

Me testMe({
  String id = 'm1',
  List<Condominium>? condominiums,
  bool isTabletSession = false,
}) {
  return Me(
    id: id,
    name: 'ana silva',
    email: 'ana@lello.com',
    condominiums: condominiums ?? [testCondominium()],
    isTabletSession: isTabletSession,
  );
}

Session testSession() {
  final condo = testCondominium();
  return Session(me: testMe(condominiums: [condo]), condominium: condo);
}

class FakeSessionBloc extends Fake implements SessionBloc {
  FakeSessionBloc([Session? session]) : session = session ?? testSession();

  final Session session;
  SessionState currentState = const SessionInitialState();

  @override
  Session? get getSession => session;

  @override
  SessionState get state => currentState;

  @override
  Stream<SessionState> get stream => const Stream.empty();

  @override
  bool checkRback(String rbac) => true;
}

DigitalPointEntity testPoint({
  String photoPath = 'photo.jpg',
  String? reference = 'R1',
  String? numCad = '10',
  String? numCra = '20',
  int? id,
}) {
  return DigitalPointEntity(
    id: id,
    date: DateTime(2026, 1, 10, 8, 5),
    latitude: '-23.5',
    longitude: '-46.6',
    typePoint: DigitalPointTypeEnum.offline,
    photoPath: photoPath,
    status: DigitalPointStatusEnum.pending,
    captureType: DigitalPointCaptureTypeEnum.manual,
    uniqueHash: 'h1',
    tabletSession: false,
    reference: reference,
    numCad: numCad,
    numCra: numCra,
  );
}

File testTempFile() {
  final file = File('${Directory.systemTemp.path}/colaborador_test_file.bin');
  file.writeAsStringSync('x');
  return file;
}
