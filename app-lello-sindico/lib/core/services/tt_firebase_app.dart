import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Configurações customizadas para Firebase
class FirebaseConfig {
  final String projectId;
  final String storageBucket;
  final String apiKey;
  final String appId;
  final String messagingSenderId;

  const FirebaseConfig({
    required this.projectId,
    required this.storageBucket,
    required this.apiKey,
    required this.appId,
    required this.messagingSenderId,
  });
}

/// Gerenciador de Firebase Apps customizados
class TTFirebaseApp {
  static const String _primaryAppName = '[DEFAULT]';

  /// Inicializa Firebase com configurações padrão
  static Future<void> initializeDefault({
    required FirebaseConfig config,
  }) async {
    try {
      debugPrint('🔵 [TTFirebaseApp] Inicializando Firebase padrão...');

      await Firebase.initializeApp(
        name: _primaryAppName,
        options: FirebaseOptions(
          apiKey: config.apiKey,
          appId: config.appId,
          messagingSenderId: config.messagingSenderId,
          projectId: config.projectId,
          storageBucket: config.storageBucket,
        ),
      );

      debugPrint('✅ [TTFirebaseApp] Firebase padrão inicializado com sucesso');
    } catch (e) {
      debugPrint('🔴 [TTFirebaseApp] Erro ao inicializar Firebase: $e');
      rethrow;
    }
  }

  /// Inicializa um Firebase App secundário com nome customizado
  static Future<FirebaseApp> initializeSecondary({
    required String appName,
    required FirebaseConfig config,
  }) async {
    try {
      debugPrint(
          '🔵 [TTFirebaseApp] Inicializando Firebase secundário: $appName...');

      final app = await Firebase.initializeApp(
        name: appName,
        options: FirebaseOptions(
          apiKey: config.apiKey,
          appId: config.appId,
          messagingSenderId: config.messagingSenderId,
          projectId: config.projectId,
          storageBucket: config.storageBucket,
        ),
      );

      debugPrint(
          '✅ [TTFirebaseApp] Firebase secundário "$appName" inicializado com sucesso');
      return app;
    } catch (e) {
      debugPrint(
          '🔴 [TTFirebaseApp] Erro ao inicializar Firebase secundário: $e');
      rethrow;
    }
  }

  /// Obtém a instância padrão do Firebase
  static FirebaseApp getDefaultApp() {
    try {
      return Firebase.app(_primaryAppName);
    } catch (e) {
      debugPrint('🔴 [TTFirebaseApp] Firebase padrão não inicializado: $e');
      rethrow;
    }
  }

  /// Obtém uma instância nomeada do Firebase
  static FirebaseApp getApp(String appName) {
    try {
      return Firebase.app(appName);
    } catch (e) {
      debugPrint(
          '🔴 [TTFirebaseApp] Firebase app "$appName" não encontrado: $e');
      rethrow;
    }
  }

  /// Lista todos os Firebase Apps inicializados
  static List<FirebaseApp> getAllApps() {
    return Firebase.apps;
  }

  /// Deleta um Firebase App pelo nome
  static Future<void> deleteApp(String appName) async {
    try {
      final app = Firebase.app(appName);
      await app.delete();
      debugPrint(
          '✅ [TTFirebaseApp] Firebase app "$appName" deletado com sucesso');
    } catch (e) {
      debugPrint('🔴 [TTFirebaseApp] Erro ao deletar Firebase app: $e');
      rethrow;
    }
  }

  /// Verifica se um Firebase App está inicializado
  static bool isAppInitialized(String appName) {
    try {
      Firebase.app(appName);
      return true;
    } catch (e) {
      return false;
    }
  }
}
