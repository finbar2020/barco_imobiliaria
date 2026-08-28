import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/preferences/domain/entity/preferences_notification_entity.dart';
import 'package:colaborador/feature/preferences/domain/use_case/get_preferences_notification/get_preferences_notification.dart';
import 'package:colaborador/feature/preferences/domain/use_case/put_preferences_notification/put_preferences_notification.dart';
import 'package:colaborador/feature/preferences/presentation/bloc/preferences_notification_bloc.dart';
import 'package:colaborador/feature/preferences/presentation/controller/preferences_notification_controller.dart';
import 'package:colaborador/feature/preferences/presentation/pages/notifications_preferences.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_checkbox.dart';
import 'package:colaborador/feature/preferences/presentation/widget/preferences_notification_checkbox.dart';
import 'package:essentials/essentials.dart' hide isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeGet extends Fake implements GetNotificationUseCase {
  _FakeGet({this.fail = false});

  final bool fail;

  @override
  Future<Try<List<PreferencesNotificationEntity>>> call(
    GetNotificationParam params,
  ) async {
    if (fail) return Rejection(UnknownFailure('get'));
    return Success([
      PreferencesNotificationEntity(active: true, module: 'gdp'),
      PreferencesNotificationEntity(active: false, module: 'ponto'),
    ]);
  }
}

class _FakePut extends Fake implements PutNotificationUseCase {
  _FakePut({this.fail = false});

  final bool fail;
  List<PreferencesNotificationEntity>? saved;

  @override
  Future<Try<String>> call(PutNotificationParam params) async {
    saved = params.entity;
    if (fail) return Rejection(UnknownFailure('put'));
    return Success('ok');
  }
}

late PreferencesNotificationBloc _bloc;

Future<_FakePut> _installContainer({
  bool failGet = false,
  bool failPut = false,
}) async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  _bloc = PreferencesNotificationBloc();
  final put = _FakePut(fail: failPut);

  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<PreferencesNotificationController>(
    PreferencesNotificationController(
      bloc: _bloc,
      getNotificationUseCase: _FakeGet(fail: failGet),
      putNotificationUseCase: put,
      sessionBloc: FakeSessionBloc(),
    ),
  );
  return put;
}

Future<void> _pumpPage(WidgetTester tester) => pumpApp(
      tester,
      const PreferencesNotificationPage(),
      localized: true,
      wrapInScaffold: false,
      shrinkWrap: false,
      surface: const Size(400, 800),
    );

void main() {
  tearDown(() async {
    await _bloc.close();
    await resetTestApplicationContainer();
  });

  group('PreferencesNotificationPage', () {
    testWidgets('lista as preferências carregadas', (tester) async {
      await _installContainer();
      await _pumpPage(tester);

      expect(find.text('notification'), findsOneWidget);
      expect(find.text('preferences_notification_subtitle'), findsOneWidget);
      expect(find.byType(PreferencesNotificationCheckBox), findsNWidgets(2));
      expect(find.text('save'), findsOneWidget);
    });

    testWidgets('alterna a preferência ao tocar no item', (tester) async {
      await _installContainer();
      await _pumpPage(tester);

      final before = tester
          .widgetList<PreferencesNotificationCheckBox>(
            find.byType(PreferencesNotificationCheckBox),
          )
          .map((w) => w.checked)
          .toList();
      expect(before, [true, false]);

      await tester.tap(find.byType(PreferencesCheckBox).first);
      await tester.pumpAndSettle();

      final after = tester
          .widgetList<PreferencesNotificationCheckBox>(
            find.byType(PreferencesNotificationCheckBox),
          )
          .map((w) => w.checked)
          .toList();
      expect(after, [false, false]);
    });

    testWidgets('salva as preferências exibidas', (tester) async {
      final put = await _installContainer();
      await _pumpPage(tester);

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(put.saved, isNotNull);
      expect(put.saved!.length, 2);
    });

    testWidgets('exibe erro e permite tentar novamente', (tester) async {
      await _installContainer(failGet: true);
      await _pumpPage(tester);

      expect(find.text('error_handling_widget_title'), findsOneWidget);
      expect(find.text('error_handling_widget_button_reTry'), findsOneWidget);
      expect(find.text('save'), findsNothing);
    });

    testWidgets('falha ao salvar volta para a tela de erro', (tester) async {
      await _installContainer(failPut: true);
      await _pumpPage(tester);

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(find.text('error_handling_widget_title'), findsOneWidget);
    });
  });
}
