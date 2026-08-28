import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import '../../helpers/fake_permission_handler.dart';
import '../core_test_support.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CheckPermissions.location', () {
    test('já concedida (whileInUse) não pede de novo', () async {
      final geo = installFakeGeolocator(permission: LocationPermission.whileInUse);
      expect(await CheckPermissions.location(), isTrue);
      expect(geo.requests, 0);
    });

    test('já concedida (always) não pede de novo', () async {
      final geo = installFakeGeolocator(permission: LocationPermission.always);
      expect(await CheckPermissions.location(), isTrue);
      expect(geo.requests, 0);
    });

    test('negada pede e aceita quando o usuário concede', () async {
      final geo = installFakeGeolocator(
        permission: LocationPermission.denied,
        permissionAfterRequest: LocationPermission.always,
      );
      expect(await CheckPermissions.location(), isTrue);
      expect(geo.requests, 1);
    });

    test('negada continua negada após o pedido', () async {
      final geo = installFakeGeolocator(
        permission: LocationPermission.deniedForever,
        permissionAfterRequest: LocationPermission.deniedForever,
      );
      expect(await CheckPermissions.location(), isFalse);
      expect(geo.requests, 1);
    });
  });

  group('CheckPermissions.camera', () {
    test('concedida devolve true sem pedir', () async {
      final handler = FakePermissionHandler(status: PermissionStatus.granted);
      setFakePermissionHandler(handler);
      expect(await CheckPermissions.camera(), isTrue);
      expect(handler.requestCount, 0);
    });

    test('negada pede e devolve true quando concedida', () async {
      final handler = FakePermissionHandler(status: PermissionStatus.denied);
      setFakePermissionHandler(handler);
      expect(await CheckPermissions.camera(), isTrue);
      expect(handler.requestCount, 1);
    });

    test('negada e recusada no pedido devolve false', () async {
      final handler = StubbornPermissionHandler(status: PermissionStatus.denied);
      setFakePermissionHandler(handler);
      expect(await CheckPermissions.camera(), isFalse);
      expect(handler.requestCount, 1);
    });
  });

  group('CheckPermissions.storage', () {
    test('concedida devolve true sem pedir', () async {
      final handler = FakePermissionHandler(status: PermissionStatus.granted);
      setFakePermissionHandler(handler);
      expect(await CheckPermissions.storage(), isTrue);
      expect(handler.requestCount, 0);
    });

    test('negada pede e devolve true quando concedida', () async {
      final handler = FakePermissionHandler(status: PermissionStatus.denied);
      setFakePermissionHandler(handler);
      expect(await CheckPermissions.storage(), isTrue);
      expect(handler.requestCount, 1);
    });

    test('negada e recusada no pedido devolve false', () async {
      final handler =
          StubbornPermissionHandler(status: PermissionStatus.permanentlyDenied);
      setFakePermissionHandler(handler);
      expect(await CheckPermissions.storage(), isFalse);
      expect(handler.requestCount, 1);
    });
  });
}
