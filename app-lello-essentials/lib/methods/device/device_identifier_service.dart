import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:device_info_plus/device_info_plus.dart';

class DeviceIdentifierService {
  static const _storageKey = 'device_unique_id';
  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  /// Retorna um identificador único e descritivo do dispositivo.
  /// Formato: {deviceId}-{deviceModel}-{platform}
  Future<String> getDeviceIdentifier() async {
    final prefs = await SharedPreferences.getInstance();

    // Verifica se já existe um ID salvo
    String? storedId = prefs.getString(_storageKey);
    if (storedId != null && storedId.isNotEmpty) {
      return storedId;
    }

    // Gera os componentes
    final deviceId = await _generateDeviceId();
    final model = await _getDeviceModel();
    final platform = Platform.operatingSystem; // android, ios, windows, etc.

    final composed = '$deviceId-$model-$platform'
        .replaceAll(RegExp(r'\s+'), '_') // evita espaços
        .toLowerCase();

    // Salva localmente
    await prefs.setString(_storageKey, composed);
    return composed;
  }

  /// Remove o identificador salvo — útil para logout / troca de conta
  Future<void> resetDeviceIdentifier() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }

  /// Combina um ID de hardware (quando disponível) com UUID local
  Future<String> _generateDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('device_raw_id');

    if (id != null && id.isNotEmpty) return id;

    final hardwareId = await _getHardwareId();
    final uuid = const Uuid().v4();
    id = hardwareId != null && hardwareId != 'unknown'
        ? '$hardwareId-$uuid'
        : uuid;

    await prefs.setString('device_raw_id', id);
    return id;
  }

  /// Obtém o identificador de hardware do sistema
  Future<String?> _getHardwareId() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return info.id;
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return info.identifierForVendor ?? 'unknown';
      } else if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        return info.systemGUID ?? 'unknown';
      } else if (Platform.isWindows) {
        final info = await _deviceInfo.windowsInfo;
        return info.deviceId;
      } else {
        return 'unknown';
      }
    } catch (_) {
      return 'unknown';
    }
  }

  /// Obtém o modelo do dispositivo
  Future<String> _getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final info = await _deviceInfo.androidInfo;
        return info.model;
      } else if (Platform.isIOS) {
        final info = await _deviceInfo.iosInfo;
        return info.utsname.machine;
      } else if (Platform.isMacOS) {
        final info = await _deviceInfo.macOsInfo;
        return info.model;
      } else if (Platform.isWindows) {
        final info = await _deviceInfo.windowsInfo;
        return info.computerName;
      } else {
        return 'unknown';
      }
    } catch (_) {
      return 'unknown';
    }
  }
}
