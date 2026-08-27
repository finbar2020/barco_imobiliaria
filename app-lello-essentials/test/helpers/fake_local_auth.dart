import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth_platform_interface/local_auth_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

/// local_auth falso e configurável.
class FakeLocalAuthPlatform extends LocalAuthPlatform
    with MockPlatformInterfaceMixin {
  bool supported = true;
  bool biometrics = true;
  bool authenticateResult = true;
  bool throwOnAuthenticate = false;
  int authenticateCalls = 0;

  @override
  Future<bool> authenticate({
    required String localizedReason,
    required Iterable<AuthMessages> authMessages,
    AuthenticationOptions options = const AuthenticationOptions(),
  }) async {
    authenticateCalls++;
    if (throwOnAuthenticate) throw StateError('sem biometria');
    return authenticateResult;
  }

  @override
  Future<bool> deviceSupportsBiometrics() async => biometrics;

  @override
  Future<List<BiometricType>> getEnrolledBiometrics() async =>
      biometrics ? [BiometricType.fingerprint] : [];

  @override
  Future<bool> isDeviceSupported() async => supported;

  @override
  Future<bool> stopAuthentication() async => true;
}

/// Instala o local_auth falso até o fim do teste.
FakeLocalAuthPlatform installFakeLocalAuth() {
  final previous = LocalAuthPlatform.instance;
  final fake = FakeLocalAuthPlatform();
  LocalAuthPlatform.instance = fake;
  addTearDown(() => LocalAuthPlatform.instance = previous);
  return fake;
}
