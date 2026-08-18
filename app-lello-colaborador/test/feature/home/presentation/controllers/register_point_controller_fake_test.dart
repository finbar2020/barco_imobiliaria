import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/feature/digital_point/controllers/digital_point_controller.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/me/domain/enum/device_type_allowed_enum.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';

class _FakeConnectivity extends Fake implements AppConnectivity {
  bool offline = false;

  @override
  Future<bool> isOfflineMode() async => offline;
}

class _FakeDigitalPointController extends Fake implements DigitalPointController {
  bool? rangeResult = true;

  @override
  Future<bool?> hasUserRangeAllowed() async => rangeResult;
}

class _SessionBloc extends Fake implements SessionBloc {
  _SessionBloc(this.session);

  final Session session;

  @override
  Session? get getSession => session;
}

Session _session({
  bool isTabletSession = false,
  bool blockedByLeave = false,
  DeviceTypeAllowedEnum deviceType = DeviceTypeAllowedEnum.all,
}) {
  final condo = testCondominium(
    digitalTimesheetStatus: DigitalTimesheetStatusEnum.approved,
    shouldIgnoreDigitalPoint: blockedByLeave,
    deviceTypeEnum: deviceType,
  );
  final me = testMe(condominiums: [condo], isTabletSession: isTabletSession)
    ..isTabletSession = isTabletSession;
  return Session(me: me, condominium: condo);
}

RegisterPointController _controller({
  required Session session,
  required RegisterPointBloc bloc,
  bool offline = false,
  bool? rangeResult = true,
}) {
  return RegisterPointController(
    appConnectivity: _FakeConnectivity()..offline = offline,
    sessionBloc: _SessionBloc(session),
    registerPointBloc: bloc,
    digitalPointController: _FakeDigitalPointController()
      ..rangeResult = rangeResult,
  );
}

Future<RegisterPointState> _expectState(RegisterPointBloc bloc, Type type) {
  return bloc.stream.firstWhere((s) => s.runtimeType == type);
}

void main() {
  group('RegisterPointController', () {
    test('onTap inicia registro quando online', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, StartRegisterPointState);

      await _controller(session: _session(), bloc: bloc).onTap();

      expect(await future, isA<StartRegisterPointState>());
    });

    test('onTap emite offline fora do iOS', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, OfflineFailureState);

      await _controller(session: _session(), bloc: bloc, offline: true).onTap();

      expect(await future, isA<OfflineFailureState>());
    });

    test('onTap bloqueia por afastamento', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, WorkLeaveState);

      await _controller(
        session: _session(blockedByLeave: true),
        bloc: bloc,
      ).onTap();

      final state = await future as WorkLeaveState;
      expect(state.description, 'afastado');
    });

    test('onTap bloqueia celular quando só tablet', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, DeviceTypeFailureState);

      await _controller(
        session: _session(deviceType: DeviceTypeAllowedEnum.tablet),
        bloc: bloc,
      ).onTap();

      expect((await future as DeviceTypeFailureState).onlyTablet, isTrue);
    });

    test('onTap bloqueia tablet quando só celular', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, DeviceTypeFailureState);

      await _controller(
        session: _session(
          isTabletSession: true,
          deviceType: DeviceTypeAllowedEnum.phone,
        ),
        bloc: bloc,
      ).onTap();

      expect((await future as DeviceTypeFailureState).onlyPhone, isTrue);
    });

    test('checkDistanceAndGo ignora localização no tablet', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, RegisterPointFaceCaptureState);

      await _controller(
        session: _session(isTabletSession: true),
        bloc: bloc,
      ).checkDistanceAndGo();

      expect(await future, isA<RegisterPointFaceCaptureState>());
    });

    test('checkDistanceAndGo segue quando dentro do range', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, RegisterPointFaceCaptureState);

      await _controller(session: _session(), bloc: bloc).checkDistanceAndGo();

      expect(await future, isA<RegisterPointFaceCaptureState>());
    });

    test('checkDistanceAndGo sem permissão de localização', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, NoLocationPermissionState);

      await _controller(
        session: _session(),
        bloc: bloc,
        rangeResult: null,
      ).checkDistanceAndGo();

      expect(await future, isA<NoLocationPermissionState>());
    });

    test('checkDistanceAndGo fora do range', () async {
      final bloc = RegisterPointBloc();
      addTearDown(bloc.close);
      final future = _expectState(bloc, OutOfRangeState);

      await _controller(
        session: _session(),
        bloc: bloc,
        rangeResult: false,
      ).checkDistanceAndGo();

      expect(await future, isA<OutOfRangeState>());
    });
  });
}
