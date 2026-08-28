import 'dart:io';

import 'package:device_info_plus_platform_interface/device_info_plus_platform_interface.dart';
import 'package:essentials/methods/device/device_identifier_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeDeviceInfo extends DeviceInfoPlatform with MockPlatformInterfaceMixin {
  _FakeDeviceInfo(this.dados, {this.falha = false});
  final Map<String, dynamic> dados;
  final bool falha;
  int chamadas = 0;

  @override
  Future<BaseDeviceInfo> deviceInfo() async {
    chamadas++;
    if (falha) throw StateError('sem device_info');
    return BaseDeviceInfo(dados);
  }
}

Map<String, dynamic> _macos({String? guid = 'GUID-1'}) => {
      'computerName': 'Mac do Zé',
      'hostName': 'mac.local',
      'arch': 'arm64',
      'model': 'MacBookPro18,3',
      'modelName': 'MacBook Pro',
      'kernelVersion': 'Darwin 25',
      'osRelease': '25.6.0',
      'majorVersion': 15,
      'minorVersion': 6,
      'patchVersion': 0,
      'activeCPUs': 8,
      'memorySize': 16,
      'cpuFrequency': 0,
      'systemGUID': guid,
    };

void main() {
  // Os ramos Android/iOS/Windows de `_getHardwareId`/`_getDeviceModel`
  // dependem de `Platform.isX` (dart:io) e não são alcançáveis no host de
  // teste: aqui cobrimos o ramo macOS e os fallbacks.
  final ehMac = Platform.isMacOS;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('compõe id de hardware + uuid + modelo + plataforma e persiste',
      () async {
    final fake = _FakeDeviceInfo(_macos());
    DeviceInfoPlatform.instance = fake;
    final service = DeviceIdentifierService();
    final id = await service.getDeviceIdentifier();
    expect(id, startsWith('guid-1-'));
    expect(id, endsWith('-macbookpro18,3-macos'));
    expect(id, isNot(contains(' ')));
    expect(id, id.toLowerCase());
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('device_unique_id'), id);
    expect(prefs.getString('device_raw_id'), startsWith('GUID-1-'));
  }, skip: ehMac ? false : 'só roda no host macOS');

  test('segunda chamada devolve o id salvo sem consultar o dispositivo',
      () async {
    SharedPreferences.setMockInitialValues({'device_unique_id': 'salvo'});
    final fake = _FakeDeviceInfo(_macos());
    DeviceInfoPlatform.instance = fake;
    expect(await DeviceIdentifierService().getDeviceIdentifier(), 'salvo');
    expect(fake.chamadas, 0);
  });

  test('reset remove o id composto mas mantém o id bruto', () async {
    DeviceInfoPlatform.instance = _FakeDeviceInfo(_macos());
    final service = DeviceIdentifierService();
    final primeiro = await service.getDeviceIdentifier();
    await service.resetDeviceIdentifier();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('device_unique_id'), isNull);
    expect(await service.getDeviceIdentifier(), primeiro);
  }, skip: ehMac ? false : 'só roda no host macOS');

  test('id bruto já salvo é reaproveitado', () async {
    SharedPreferences.setMockInitialValues({'device_raw_id': 'bruto'});
    DeviceInfoPlatform.instance = _FakeDeviceInfo(_macos());
    final id = await DeviceIdentifierService().getDeviceIdentifier();
    expect(id, startsWith('bruto-'));
  });

  test('sem GUID usa só o uuid', () async {
    DeviceInfoPlatform.instance = _FakeDeviceInfo(_macos(guid: null));
    final id = await DeviceIdentifierService().getDeviceIdentifier();
    final prefs = await SharedPreferences.getInstance();
    final bruto = prefs.getString('device_raw_id')!;
    expect(bruto.length, 36); // uuid v4
    expect(id, '$bruto-macbookpro18,3-macos');
  }, skip: ehMac ? false : 'só roda no host macOS');

  test('falha do plugin cai em unknown para hardware e modelo', () async {
    DeviceInfoPlatform.instance = _FakeDeviceInfo({}, falha: true);
    final id = await DeviceIdentifierService().getDeviceIdentifier();
    final prefs = await SharedPreferences.getInstance();
    final bruto = prefs.getString('device_raw_id')!;
    expect(bruto.length, 36);
    expect(id, '$bruto-unknown-${Platform.operatingSystem}');
  });
}
