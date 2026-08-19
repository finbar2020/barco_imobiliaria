import 'dart:async';

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_bloc.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/bloc/manual_timesheet_state.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/page/manual_timesheet_page.dart';
import 'package:colaborador/feature/manual_timesheet/presentation/widgets/manual_timesheet_document_form.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_bloc.dart';
import 'package:colaborador/feature/sick_note/presentation/bloc/sick_note_state.dart';
import 'package:colaborador/feature/sick_note/presentation/page/sick_note_page.dart';
import 'package:colaborador/feature/sick_note/presentation/widgets/sick_note_document_form.dart';
import 'package:essentials/essentials.dart' hide isNull;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fixtures.dart';
import '../../../../helpers/pump_app.dart';
import '../../../../helpers/test_application_container.dart';

class _FakeSickNoteBloc extends Fake implements SickNoteBloc {
  _FakeSickNoteBloc(this._state);

  SickNoteState _state;
  final _controller = StreamController<SickNoteState>.broadcast();

  @override
  SickNoteState get state => _state;

  @override
  Stream<SickNoteState> get stream => _controller.stream;

  void emitState(SickNoteState state) {
    _state = state;
    _controller.add(state);
  }

  Future<void> dispose() => _controller.close();
}

class _FakeManualTimeSheetBloc extends Fake implements ManualTimeSheetBloc {
  _FakeManualTimeSheetBloc(this._state);

  ManualTimeSheetState _state;
  final _controller = StreamController<ManualTimeSheetState>.broadcast();

  @override
  ManualTimeSheetState get state => _state;

  @override
  Stream<ManualTimeSheetState> get stream => _controller.stream;

  @override
  List<DateTime> listOfMonths = [DateTime(2026, 1, 1)];

  void emitState(ManualTimeSheetState state) {
    _state = state;
    _controller.add(state);
  }

  Future<void> dispose() => _controller.close();
}

/// As páginas leem o tamanho máximo de arquivo do remote config; sem ele o
/// app cai no retorno nulo de `_getFileMaxSizePermitted`.
class _FakeRemoteConfig extends Fake implements FirebaseRemoteConfig {
  @override
  String getString(String key) => '10485760';
}

class _SessionBlocWithRemoteConfig extends FakeSessionBloc {
  @override
  FirebaseRemoteConfig? get remoteConfig => _FakeRemoteConfig();
}

Future<void> _installContainer() async {
  final locator = ApplicationContainer.instance().locator;
  if (locator.isRegistered<Environment>()) {
    await locator.reset(dispose: true);
  }
  locator.registerSingleton<Environment>(TestEnvironment());
  locator.registerSingleton<SessionBloc>(_SessionBlocWithRemoteConfig());
}

Future<List<String>> _pumpPage(WidgetTester tester, Widget page) async {
  final routes = <String>[];
  await pumpApp(
    tester,
    Navigator(
      onGenerateRoute: (settings) {
        if (settings.name != null &&
            settings.name != Navigator.defaultRouteName) {
          routes.add(settings.name!);
        }
        return MaterialPageRoute(
          builder: (_) => settings.name == null ||
                  settings.name == Navigator.defaultRouteName
              ? page
              : const SizedBox(),
        );
      },
    ),
    localized: true,
    wrapInScaffold: false,
    shrinkWrap: false,
    settle: false,
    locOverrides: const {'manual_timesheet_document_date': 'Periodo'},
    surface: const Size(500, 1000),
  );
  for (var i = 0; i < 5; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return routes;
}

void main() {
  setUp(_installContainer);
  tearDown(resetTestApplicationContainer);

  group('SickNotePage', () {
    late _FakeSickNoteBloc bloc;

    setUp(() {
      bloc = _FakeSickNoteBloc(const SickNoteInitialState());
      ApplicationContainer.instance()
          .locator
          .registerSingleton<SickNoteBloc>(bloc);
    });

    tearDown(() => bloc.dispose());

    testWidgets('exibe o formulário de atestado', (tester) async {
      await _pumpPage(tester, const SickNotePage());

      expect(find.text('sick_note_title'), findsOneWidget);
      expect(find.byType(SickNoteDocumentForm), findsOneWidget);
    });

    testWidgets('enviando exibe o loading no lugar do formulário',
        (tester) async {
      bloc = _FakeSickNoteBloc(const SickNoteLoadingState());
      final locator = ApplicationContainer.instance().locator;
      await locator.unregister<SickNoteBloc>();
      locator.registerSingleton<SickNoteBloc>(bloc);

      await _pumpPage(tester, const SickNotePage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(SickNoteDocumentForm), findsNothing);
    });

    testWidgets('sucesso navega para a tela de confirmação', (tester) async {
      final routes = await _pumpPage(tester, const SickNotePage());

      bloc.emitState(const SickNoteRegisterLoadedState());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(routes, contains(ApplicationRoute.sickNoteRegisterSuccess));
    });

    testWidgets('falha navega para a tela de erro', (tester) async {
      final routes = await _pumpPage(tester, const SickNotePage());

      bloc.emitState(const SickNoteRegisterFailedState());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(routes, contains(ApplicationRoute.sickNoteRegisterError));
    });

    testWidgets('abre mesmo sem remote config carregado', (tester) async {
      final locator = ApplicationContainer.instance().locator;
      await locator.unregister<SessionBloc>();
      locator.registerSingleton<SessionBloc>(FakeSessionBloc());

      await _pumpPage(tester, const SickNotePage());

      expect(find.byType(SickNoteDocumentForm), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('ManualTimeSheetPage', () {
    late _FakeManualTimeSheetBloc bloc;

    setUp(() {
      bloc = _FakeManualTimeSheetBloc(const ManualTimeSheetInitialState());
      ApplicationContainer.instance()
          .locator
          .registerSingleton<ManualTimeSheetBloc>(bloc);
    });

    tearDown(() => bloc.dispose());

    testWidgets('exibe o formulário de ponto manual', (tester) async {
      await _pumpPage(tester, const ManualTimeSheetPage());

      expect(find.byType(ManualTimeSheetWidget), findsOneWidget);
    });

    testWidgets('enviando exibe o loading no lugar do formulário',
        (tester) async {
      bloc = _FakeManualTimeSheetBloc(const ManualTimeSheetLoadingState());
      final locator = ApplicationContainer.instance().locator;
      await locator.unregister<ManualTimeSheetBloc>();
      locator.registerSingleton<ManualTimeSheetBloc>(bloc);

      await _pumpPage(tester, const ManualTimeSheetPage());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ManualTimeSheetWidget), findsNothing);
    });

    testWidgets('sucesso navega para a tela de confirmação', (tester) async {
      final routes = await _pumpPage(tester, const ManualTimeSheetPage());

      bloc.emitState(const ManualTimeSheetRegisterLoadedState());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(
        routes,
        contains(ApplicationRoute.manualTimesheetRegisterSuccess),
      );
    });

    testWidgets('falha navega para a tela de erro', (tester) async {
      final routes = await _pumpPage(tester, const ManualTimeSheetPage());

      bloc.emitState(const ManualTimeSheetRegisterFailedState());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(routes, contains(ApplicationRoute.manualTimesheetRegisterError));
    });

    testWidgets('abre mesmo sem remote config carregado', (tester) async {
      final locator = ApplicationContainer.instance().locator;
      await locator.unregister<SessionBloc>();
      locator.registerSingleton<SessionBloc>(FakeSessionBloc());

      await _pumpPage(tester, const ManualTimeSheetPage());

      expect(find.byType(ManualTimeSheetWidget), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
