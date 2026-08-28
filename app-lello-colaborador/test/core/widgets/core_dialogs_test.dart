import 'package:colaborador/core/widgets/afastamento_dialog.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

/// Sem o registrante de plugins, o `url_launcher` cai na implementação
/// genérica por method channel.
const _urlLauncherChannels = <MethodChannel>[
  MethodChannel('plugins.flutter.io/url_launcher'),
  MethodChannel('plugins.flutter.io/url_launcher_macos'),
];

Future<void> _pumpDialog(WidgetTester tester, Widget dialog) async {
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => dialog,
              ),
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    surface: const Size(500, 900),
  );

  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
}

void main() {
  group('AfastamentoDialog', () {
    testWidgets('mostra o motivo do afastamento', (tester) async {
      await _pumpDialog(
        tester,
        const AfastamentoDialog(workLeaveDescription: 'licença médica'),
      );

      expect(find.textContaining('licença médica'), findsOneWidget);
      expect(find.text('ok'), findsOneWidget);
    });

    testWidgets('ok fecha o diálogo', (tester) async {
      await _pumpDialog(
        tester,
        const AfastamentoDialog(workLeaveDescription: 'licença médica'),
      );

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(find.byType(AfastamentoDialog), findsNothing);
    });

    testWidgets('falar com o RH abre o WhatsApp', (tester) async {
      final launched = <MethodCall>[];
      for (final channel in _urlLauncherChannels) {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(channel, (call) async {
          launched.add(call);
          return true;
        });
        addTearDown(() {
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(channel, null);
        });
      }

      await _pumpDialog(
        tester,
        const AfastamentoDialog(workLeaveDescription: 'licença médica'),
      );

      await tester.tap(find.text('digital_point_sync_dialog_failed_away_talk'));
      await tester.pumpAndSettle();

      expect(launched, isNotEmpty);
      expect(tester.takeException(), isNull);
    });
  });

  group('DeviceTypeDialog', () {
    testWidgets('ok fecha o aviso de aparelho incompatível', (tester) async {
      await _pumpDialog(
        tester,
        const DeviceTypeDialog(onlyTablet: false, onlyPhone: true),
      );

      expect(find.byType(DeviceTypeDialog), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();

      expect(find.byType(DeviceTypeDialog), findsNothing);
    });
  });
}
