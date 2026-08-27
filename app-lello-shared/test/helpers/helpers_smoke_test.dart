import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/shared_features.dart' hide isNull, isNotNull;

import 'fake_http.dart';
import 'fake_local_auth.dart';
import 'fake_permission_handler.dart';
import 'fake_url_launcher.dart';
import 'firebase_mocks.dart';
import 'pump_app.dart';
import 'test_container.dart';

void main() {
  testWidgets('helpers compilam: container, http falso e pumpPage',
      (tester) async {
    await setUpFakeFirebase();
    setFakePermissionHandler(FakePermissionHandler());
    installFakeUrlLauncher();
    installFakeLocalAuth();
    final container = TestSharedContainer()..register<String>('x');
    expect(container.resolve<String>(), 'x');
    final http = FakeHttp()..on('GET', '/ping', body: {'ok': true});
    final client = buildChopperClient(http);
    final res = await client.get(Uri.parse('/ping'));
    expect(res.body, {'ok': true});
    final observer = RecordingNavigatorObserver();
    await pumpPage(
      tester,
      Builder(
        builder: (c) => TextButton(
          onPressed: () => Navigator.pushNamed(c, '/x'),
          child: Text(getString(c, 'chave')),
        ),
      ),
      observer: observer,
    );
    expect(find.text('chave'), findsOneWidget);
    await tester.tap(find.text('chave'));
    await tester.pumpAndSettle();
    expect(findRoute('/x'), findsOneWidget);
    expect(observer.pushedNames, contains('/x'));
  });
}
