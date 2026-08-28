import 'dart:async';
import 'dart:convert';

import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/bloc/in_cara_state.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/bloc/in_care_bloc.dart';
import 'package:morar/feature/my_preferences/presentation/pages/in_care/presentation/in_care_page.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'my_preferences_fixtures.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late InCareBloc bloc;

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.inCare: (_) => const InCarePage(),
  };

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    harness.http.on('GET', unitPersonalDataPath, body: accessJson());
    harness.http.on('PUT', unitPersonalDataPath,
        body: accessJson(careName: 'Carlos Silva'));
  });

  Finder nameField() => find.byType(TextFormField).at(0);
  Finder emailField() => find.byType(TextFormField).at(1);
  Finder saveButton() => find.widgetWithText(ElevatedButton, 'save');
  bool saveEnabled(WidgetTester tester) =>
      tester.widget<ElevatedButton>(saveButton()).enabled;

  Iterable<String> requested() =>
      harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  /// Corrigido: o `onPopInvokedWithResult` da InCarePage não chama mais
  /// `Navigator.pop(context)` quando `didPop` já é true (a rota já está
  /// saindo) e reseta `_isDialogShowing` após o diálogo; antes a reentrância
  /// estourava a asserção `!_debugLocked` do Navigator como erro assíncrono
  /// (e em release fechava a tela anterior). [body] roda numa zona guardada
  /// para garantir que nenhum erro escapa.
  Future<List<Object>> popErrors(Future<void> Function() body) async {
    final errors = <Object>[];
    await runZonedGuarded(body, (error, _) => errors.add(error));
    return errors;
  }

  /// O bloc é factory no container: fixamos uma instância para a página
  /// resolver a mesma que o teste inspeciona. Precisa ser criado dentro do
  /// testWidgets (zona FakeAsync): criado no setUp, os handlers do bloc
  /// rodam na zona real e o BlocBuilder nunca é reconstruído.
  Future<void> fixBloc() async {
    bloc = harness.resolve<InCareBloc>();
    await harness.override<InCareBloc>(bloc);
  }

  Future<void> pumpInCare(WidgetTester tester) async {
    await fixBloc();
    await pumpPage(tester, const InCarePage());
  }

  Future<void> open(WidgetTester tester) async {
    await fixBloc();
    await pumpPage(tester, LauncherPage(ApplicationRoute.inCare),
        routes: routes, observer: observer, surface: const Size(400, 1400));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  testWidgets('carrega os dados da unidade e desabilita salvar sem mudanças',
      (tester) async {
    await pumpInCare(tester);

    expect(bloc.state, const InCareLoadedState());
    expect(find.text('in_care'), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) =>
          w is RichText &&
          w.text.toPlainText() == 'in_care_message "in_care"'),
      findsOneWidget,
    );
    expect(find.text('Edifício Lello - 101'), findsOneWidget);
    expect(find.text('Carlos'), findsOneWidget);
    expect(find.text('cuidados@lello.com'), findsOneWidget);
    expect(saveEnabled(tester), isFalse);
    expect(bloc.hasUnsavedChanges, isFalse);
    // A unidade de teste não tem contexto numérico → idUnidade=0.
    final get = harness.http.requests.single;
    expect(get.url.path, unitPersonalDataPath);
    expect(get.url.queryParameters['idUnidade'], '0');
    await expectLater(
      find.byType(InCarePage),
      matchesGoldenFile('goldens/in_care_page.png'),
    );
  });

  testWidgets('editar o nome habilita salvar e atualiza os dados',
      (tester) async {
    await pumpInCare(tester);

    await tester.enterText(nameField(), 'Carlos Silva');
    await tester.pumpAndSettle();
    expect(bloc.hasUnsavedChanges, isTrue);
    expect(saveEnabled(tester), isTrue);

    await tester.tap(saveButton());
    await tester.pumpAndSettle();

    final put = harness.http.requests.singleWhere((r) => r.method == 'PUT');
    final body = jsonDecode(put.body) as Map<String, dynamic>;
    expect(body['dadosContatoUnidade']['nomeAosCuidados'], 'Carlos Silva');
    expect(body['dadosContatoUnidade']['emailAosCuidados'], 'cuidados@lello.com');
    expect(body['dadosPessoais']['cpf'], '12345678901');
    expect(bloc.state, const InCareUpdateSuccessState());
    expect(bloc.accessData?.unitContactData.careName, 'Carlos Silva');
    expect(find.text('profile_update_success'), findsOneWidget);

    await tester.tap(find.text('ok'));
    await tester.pumpAndSettle();
    expect(find.text('profile_update_success'), findsNothing);
    expect(bloc.hasUnsavedChanges, isFalse);
    expect(saveEnabled(tester), isFalse);
  });

  testWidgets('nome e e-mail precisam ser preenchidos juntos', (tester) async {
    await pumpInCare(tester);

    // Nome preenchido e e-mail vazio.
    await tester.enterText(nameField(), 'Carlos Silva');
    await tester.enterText(emailField(), '');
    await tester.pumpAndSettle();
    await tester.tap(saveButton());
    await tester.pumpAndSettle();
    expect(find.text('validation_required'), findsOneWidget);
    expect(requested(), isNot(contains('PUT $unitPersonalDataPath')));

    // E-mail inválido.
    await tester.enterText(emailField(), 'abc');
    await tester.tap(saveButton());
    await tester.pumpAndSettle();
    expect(find.text('validation_invalid_email'), findsOneWidget);

    // E-mail preenchido e nome vazio.
    await tester.enterText(emailField(), 'x@lello.com');
    await tester.enterText(nameField(), '');
    await tester.pumpAndSettle();
    await tester.tap(saveButton());
    await tester.pumpAndSettle();
    expect(find.text('validation_required'), findsOneWidget);
    expect(requested(), isNot(contains('PUT $unitPersonalDataPath')));

    // Os dois vazios é válido: limpa o "aos cuidados".
    await tester.enterText(emailField(), '');
    await tester.pumpAndSettle();
    expect(saveEnabled(tester), isTrue);
    await tester.tap(saveButton());
    await tester.pumpAndSettle();
    expect(requested(), contains('PUT $unitPersonalDataPath'));
    final body = jsonDecode(harness.http.requests.last.body);
    expect(body['dadosContatoUnidade']['nomeAosCuidados'], '');
    expect(body['dadosContatoUnidade']['emailAosCuidados'], '');
    expect(find.text('profile_update_success'), findsOneWidget);
  });

  testWidgets('falha ao salvar mostra o erro e "tentar de novo" recarrega',
      (tester) async {
    await pumpInCare(tester);
    harness.http.on('PUT', unitPersonalDataPath,
        status: 500, body: {'message': 'x'});

    await tester.enterText(nameField(), 'Outro');
    await tester.pumpAndSettle();
    await tester.tap(saveButton());
    await tester.pumpAndSettle();

    expect(bloc.state, isA<InCareFailureState>());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);

    await tester.tap(find.text('error_handling_widget_button_reTry').first);
    await tester.pumpAndSettle();

    expect(bloc.state, const InCareLoadedState());
    expect(find.text('Carlos'), findsOneWidget);
    expect(requested().where((r) => r == 'GET $unitPersonalDataPath'),
        hasLength(2));
  });

  testWidgets('falha ao carregar: "voltar" do erro fecha a página',
      (tester) async {
    harness.http.on('GET', unitPersonalDataPath,
        status: 500, body: {'message': 'x'});
    await open(tester);

    expect(bloc.state, isA<InCareFailureState>());
    expect(find.byType(ErrorHandlingWidget), findsOneWidget);

    final errors = await popErrors(() async {
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
    });

    expect(find.byType(InCarePage), findsNothing);
    expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    expect(errors, isEmpty);
  });

  testWidgets('estados inicial e de loading mostram o indicador',
      (tester) async {
    await pumpInCare(tester);

    await emitState(tester, bloc, const InCareLoadingState(), settle: false);
    await tester.pump();
    expect(find.text('please_wait'), findsOneWidget);

    await emitState(tester, bloc, const InCareInitialState(), settle: false);
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('voltar com mudanças pendentes pede confirmação',
      (tester) async {
    await open(tester);
    await tester.enterText(nameField(), 'Mudou');
    await tester.pumpAndSettle();
    expect(bloc.hasUnsavedChanges, isTrue);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.maybePop();
    await tester.pumpAndSettle();

    expect(find.text('paper_zero_unsaved_changes_dialog_title'), findsOneWidget);
    await tester.tap(find.text('paper_zero_unsaved_changes_dialog_cancel'));
    await tester.pumpAndSettle();
    expect(find.text('paper_zero_unsaved_changes_dialog_title'), findsNothing);
    expect(find.byType(InCarePage), findsOneWidget);

    // Confirmar fecha a página, sem pop extra do callback.
    final errors = await popErrors(() async {
      navigator.maybePop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('paper_zero_unsaved_changes_dialog_confirm'));
      await tester.pumpAndSettle();
    });

    expect(find.byType(InCarePage), findsNothing);
    expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    expect(errors, isEmpty);
  });

  testWidgets('voltar sem mudanças fecha direto', (tester) async {
    await open(tester);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    final errors = await popErrors(() async {
      navigator.maybePop();
      await tester.pumpAndSettle();
    });

    expect(find.text('paper_zero_unsaved_changes_dialog_title'), findsNothing);
    expect(find.byType(InCarePage), findsNothing);
    expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    expect(errors, isEmpty);
  });

  testWidgets('seta da app bar fecha a página', (tester) async {
    await open(tester);

    final errors = await popErrors(() async {
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();
    });

    expect(find.byType(InCarePage), findsNothing);
    expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    expect(errors, isEmpty);
  });
}
