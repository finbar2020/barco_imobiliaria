import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/feature/digital_point/controllers/digital_point_controller.dart';
import 'package:colaborador/feature/me/domain/entity/condominium.dart';
import 'package:colaborador/feature/me/domain/entity/geographic_coordinates.dart';
import 'package:colaborador/feature/session/domain/entity/session.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';

import '../../../helpers/fixtures.dart';

class _FakeGeolocator extends GeolocatorPlatform {
  _FakeGeolocator({
    this.permission = LocationPermission.whileInUse,
    this.position,
  });

  LocationPermission permission;
  Position? position;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async => permission;

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async =>
      position ?? _position(0, 0);

  @override
  Future<Position?> getLastKnownPosition({
    bool forceLocationManager = false,
  }) async =>
      position;
}

/// O `lastPosition` da sessão só é considerado se tiver menos de 1 minuto.
Position _position(double lat, double lng) => Position(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
      accuracy: 1,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );

class _FakeConnectivity extends Fake implements AppConnectivity {
  @override
  Future<bool> checkConnectivity() async => true;
}

class _SessionBloc extends Fake implements SessionBloc {
  _SessionBloc(this._session);

  final Session? _session;

  @override
  Session? get getSession => _session;
}

Session _session({
  GeographicCoordinates? coordinates,
  bool isTabletSession = false,
  Position? lastPosition,
}) {
  final condo = Condominium(
    id: 'c1',
    name: 'Torre Lello',
    reference: 'R1',
    jobPosition: 'porteiro',
    workLeaveDescription: '',
    shouldIgnoreDigitalPoint: false,
    workShift: 'diurno',
    workShiftDetails: const [],
    geographicCoordinates: coordinates,
    deviceTypeEnum: testCondominium().deviceTypeEnum,
    digitalTimesheetStatus: testCondominium().digitalTimesheetStatus,
  );
  final session = Session(
    me: testMe(condominiums: [condo], isTabletSession: isTabletSession)
      ..isTabletSession = isTabletSession,
    condominium: condo,
  );
  if (lastPosition != null) session.setLastPosition(lastPosition);
  return session;
}

DigitalPointController _controller(Session session) => DigitalPointController(
      sessionBloc: _SessionBloc(session),
      appConnectivity: _FakeConnectivity(),
    );

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() {
    GeolocatorPlatform.instance = _FakeGeolocator();
  });

  group('DigitalPointController.hasUserRangeAllowed', () {
    test('sem permissão de localização retorna null', () async {
      GeolocatorPlatform.instance =
          _FakeGeolocator(permission: LocationPermission.denied);

      final result = await _controller(_session()).hasUserRangeAllowed();

      expect(result, isNull);
    });

    test('condomínio sem coordenadas libera a marcação', () async {
      GeolocatorPlatform.instance = _FakeGeolocator();

      final result = await _controller(_session()).hasUserRangeAllowed();

      expect(result, isTrue);
    });

    test('sessão de tablet não valida distância', () async {
      GeolocatorPlatform.instance = _FakeGeolocator();

      final result = await _controller(
        _session(
          isTabletSession: true,
          coordinates: GeographicCoordinates(
            latitude: '-23.5',
            longitude: '-46.6',
          ),
        ),
      ).hasUserRangeAllowed();

      expect(result, isTrue);
    });

    test('colaborador dentro do raio pode bater ponto', () async {
      GeolocatorPlatform.instance = _FakeGeolocator();

      final result = await _controller(
        _session(
          coordinates: GeographicCoordinates(
            latitude: '-23.5',
            longitude: '-46.6',
          ),
          lastPosition: _position(-23.5, -46.6),
        ),
      ).hasUserRangeAllowed();

      expect(result, isTrue);
    });

    test('colaborador longe do condomínio é bloqueado', () async {
      GeolocatorPlatform.instance = _FakeGeolocator();

      final result = await _controller(
        _session(
          coordinates: GeographicCoordinates(
            latitude: '-23.5',
            longitude: '-46.6',
          ),
          lastPosition: _position(-22.9, -43.2),
        ),
      ).hasUserRangeAllowed();

      expect(result, isFalse);
    });
  });
}
