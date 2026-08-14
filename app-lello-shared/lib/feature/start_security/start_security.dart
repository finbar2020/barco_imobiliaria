import 'dart:io';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SecurityCheck {
  static Future<void> initializeApp(Widget Function() mainApp, Widget Function() blockedApp) async {
    WidgetsFlutterBinding.ensureInitialized();
  }

  // Verifica root e emulador
  static Future<bool> checkSecurity() async {
    bool isReleaseMode = const bool.fromEnvironment('dart.vm.product');
    bool isRooted = await _isDeviceRooted();  // Verifica root manualmente
    bool isEmulator = await _checkIfEmulator();
    if(isReleaseMode){
      return isRooted || isEmulator;
    }
    return false;// Verifica emulador// Retorna true se o dispositivo for inseguro
  }

  // Função para verificar se o dispositivo está rooteado
  static Future<bool> _isDeviceRooted() async {
    if (Platform.isAndroid) {
      // Verificações comuns para dispositivos Android
      return await _checkForRootFiles() || await _checkForRootApps();
    }
    // Em iOS, não se aplica (você pode adicionar verificação de jailbreak, se necessário)
    return false;
  }

  // Verifica arquivos comuns de root
  static Future<bool> _checkForRootFiles() async {
    List<String> rootPaths = [
      '/system/app/Superuser.apk',
      '/sbin/su',
      '/system/bin/su',
      '/system/xbin/su',
      '/data/local/xbin/su',
      '/data/local/bin/su',
      '/system/sd/xbin/su',
      '/system/bin/failsafe/su',
      '/data/local/su'
    ];

    for (String path in rootPaths) {
      if (await File(path).exists()) {
        return true;  // Dispositivo rooteado
      }
    }
    return false;
  }

  // Verifica se aplicativos comuns de root estão instalados
  static Future<bool> _checkForRootApps() async {
    List<String> rootApps = [
      'com.noshufou.android.su',  // SuperSU
      'eu.chainfire.supersu',
      'com.koushikdutta.superuser',
      'com.thirdparty.superuser',
      'com.yellowes.su'
    ];

    for (String package in rootApps) {
      if (await _isPackageInstalled(package)) {
        return true;  // Aplicativo de root encontrado
      }
    }
    return false;
  }

  // Função auxiliar para verificar se um pacote está instalado
  static Future<bool> _isPackageInstalled(String packageName) async {
    try {
      final result = await Process.run('pm', ['list', 'packages', packageName]);
      return result.stdout.toString().contains(packageName);
    } catch (e) {
      return false;
    }
  }

  // Verifica se é um emulador
  static Future<bool> _checkIfEmulator() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return !androidInfo.isPhysicalDevice;
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    }
    return false;
  }
}
