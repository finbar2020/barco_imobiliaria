// Apoio dos testes de `lib/core/*` (e reaproveitado por `feature/attach_files`
// e `feature/access_settings_permission_denied`): bundle de assets falso para
// os SVGs que só os APPS declaram, geolocator falso, permission_handler que
// nunca concede e sessão falsa do circuit breaker.
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator_platform_interface/geolocator_platform_interface.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../helpers/fake_permission_handler.dart';

/// SVG mínimo válido (quadrado 10x10) devolvido para qualquer `.svg` que o
/// pacote não tenha.
const String fakeSvg =
    '<svg xmlns="http://www.w3.org/2000/svg" width="10" height="10">'
    '<rect width="10" height="10" fill="#FFAB66"/></svg>';

/// Os ícones `assets/*.svg` usados pelos widgets do core (`ic_attention`,
/// `ic_cam`, `doc_insert`, `custom_image_network_placeholder`...) são
/// declarados pelos APPS: este bundle entrega um SVG mínimo para os que o
/// pacote não possui e delega o resto ao `rootBundle`.
class FakeSvgAssetBundle extends CachingAssetBundle {
  final loaded = <String>[];

  @override
  Future<ByteData> load(String key) async {
    try {
      return await rootBundle.load(key);
    } catch (_) {
      if (key.endsWith('.svg')) {
        loaded.add(key);
        final bytes = Uint8List.fromList(fakeSvg.codeUnits);
        return ByteData.sublistView(bytes);
      }
      rethrow;
    }
  }
}

/// Envolve [child] com o bundle falso de SVGs.
Widget withFakeAssets(Widget child, {FakeSvgAssetBundle? bundle}) =>
    DefaultAssetBundle(bundle: bundle ?? FakeSvgAssetBundle(), child: child);

/// geolocator falso: controla a permissão devolvida por `checkPermission` e
/// `requestPermission` e registra `openAppSettings`.
class FakeGeolocatorPlatform extends GeolocatorPlatform
    with MockPlatformInterfaceMixin {
  FakeGeolocatorPlatform({
    this.permission = LocationPermission.denied,
    this.permissionAfterRequest = LocationPermission.whileInUse,
  });

  LocationPermission permission;
  LocationPermission permissionAfterRequest;
  int requests = 0;
  int settingsOpened = 0;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async {
    requests++;
    permission = permissionAfterRequest;
    return permission;
  }

  @override
  Future<bool> openAppSettings() async {
    settingsOpened++;
    return true;
  }
}

FakeGeolocatorPlatform installFakeGeolocator({
  LocationPermission permission = LocationPermission.denied,
  LocationPermission permissionAfterRequest = LocationPermission.whileInUse,
}) {
  final fake = FakeGeolocatorPlatform(
    permission: permission,
    permissionAfterRequest: permissionAfterRequest,
  );
  GeolocatorPlatform.instance = fake;
  return fake;
}

/// permission_handler que registra o pedido mas continua negando.
class StubbornPermissionHandler extends FakePermissionHandler {
  StubbornPermissionHandler({super.status});

  @override
  Future<Map<Permission, PermissionStatus>> requestPermissions(
    List<Permission> permissions,
  ) async {
    requestCount++;
    return {for (final p in permissions) p: status};
  }
}

/// `sessionBloc` dinâmico do `CircuitBreakerController`: só `checkRback` e
/// `getHortaRemoteConfig` são usados.
class FakeCircuitSessionBloc {
  FakeCircuitSessionBloc({this.rbacAllowed = true, this.horta});

  bool rbacAllowed;
  Object? horta;
  final checkedRbacs = <String>[];

  bool checkRback(String rbac) {
    checkedRbacs.add(rbac);
    return rbacAllowed;
  }

  Object? getHortaRemoteConfig() => horta;
}
