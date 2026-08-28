import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'fake_local_auth.dart';
import 'fake_permission_handler.dart';
import 'fake_url_launcher.dart';
import 'firebase_mocks.dart';
import 'pump_app.dart';

void main() {
  testWidgets('helpers compilam e o pumpApp monta com localização de teste',
      (tester) async {
    await setUpFakeFirebase();
    setFakePermissionHandler(FakePermissionHandler());
    installFakeUrlLauncher();
    installFakeLocalAuth();
    await pumpApp(tester, const Text('ok'));
    expect(find.text('ok'), findsOneWidget);
  });
}
