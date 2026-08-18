import 'package:colaborador/core/widgets/permission_notification_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';

import '../../helpers/fake_permission_handler.dart';
import '../../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakePermissionHandler permissionHandler;

  setUp(() {
    permissionHandler = FakePermissionHandler();
    setFakePermissionHandler(permissionHandler);
  });

  testWidgets('golden — permission notification aceitar', (tester) async {
    await pumpApp(
      tester,
      const PermissionNotificationPage(),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );
    await tester.pump();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/permission_notification_accept.png'),
    );
  });

  testWidgets('golden — permission notification configurações', (tester) async {
    permissionHandler.status = PermissionStatus.denied;
    await pumpApp(
      tester,
      const PermissionNotificationPage(),
      localized: true,
      shrinkWrap: false,
      surface: const Size(400, 720),
    );
    await tester.pump();
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/permission_notification_settings.png'),
    );
  });
}
