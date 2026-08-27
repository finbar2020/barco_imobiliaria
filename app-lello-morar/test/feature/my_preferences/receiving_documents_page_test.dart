import 'dart:convert';

import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/my_preferences/domain/entities/street_type_entity.dart';
import 'package:morar/feature/my_preferences/model/zero_paper_preference_item_model.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/bloc/receiving_documents_bloc.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/bloc/receiving_documents_state.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/pages/receiving_documents_page.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/widgets/change_address_forms_widget.dart';
import 'package:morar/feature/my_preferences/presentation/pages/receiving_documents/presentation/widgets/change_email_widget.dart';
import 'package:morar/feature/preferences/presentation/widget/preferences_checkbox.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import '../easy_fix/fake_via_cep.dart';
import 'my_preferences_fixtures.dart';

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late ReceivingDocumentsBloc bloc;
  late FakeViaCep viaCep;

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.receivingDocuments: (_) => const ReceivingDocumentsPage(),
  };
  // As chaves cruas do cabeçalho "digital / impresso" não cabem na Row
  // (overflow); usamos textos curtos como no app.
  const locOverrides = {
    'preferences_zero_paper_digital': 'Digital',
    'preferences_zero_paper_printed': 'Impresso',
  };

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    // `getStates()` usa `rootBundle.loadString`, que cacheia o Future criado
    // na zona FakeAsync do teste anterior; sem limpar, o `await` seguinte
    // agenda a continuação numa zona morta e a página nunca carrega.
    rootBundle.clear();
    viaCep = FakeViaCep(ceps: {
      '02002000': FakeViaCep.saoPaulo('02002-000'),
      '01001000': FakeViaCep.saoPaulo('01001-000'),
    });
    /// Corrigido: `ReceivingDocumentsBloc.getUnitData` usa
    /// `int.tryParse(unitId) ?? 0` (como a InCarePage); antes o `!` estourava
    /// com um `notificationContext` não numérico e a tela ficava no loading.
    /// O contexto numérico aqui é o caso normal; o não numérico tem teste
    /// próprio.
    harness.sessionBloc.session.unity = testUnity(notificationContext: '77');
    harness.http.on('GET', unitPersonalDataPath, body: accessJson());
    harness.http.on('PUT', unitPersonalDataPath, body: accessJson());
    harness.http.on('GET', streetTypesPath, body: streetTypesJson);
    harness.http.on('GET', citiesPath, body: [saoPauloCity, campinasCity]);
  });

  ReceivingDocumentsLoadedState loaded() =>
      bloc.state as ReceivingDocumentsLoadedState;

  Iterable<String> requested() =>
      harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  Map<String, dynamic> lastPutBody() => jsonDecode(
      harness.http.requests.lastWhere((r) => r.method == 'PUT').body);

  Finder checkbox(int index) => find.byType(PreferencesCheckBox).at(index);
  Finder saveButton() => find.widgetWithText(ElevatedButton, 'save');
  bool saveEnabled(WidgetTester tester) =>
      tester.widget<ElevatedButton>(saveButton()).enabled;
  Finder discardButton() =>
      find.widgetWithText(OutlinedButton, 'discard_changes');
  bool discardEnabled(WidgetTester tester) =>
      tester.widget<OutlinedButton>(discardButton()).enabled;

  /// O bloc é factory no container: fixamos uma instância para a página
  /// resolver a mesma que o teste inspeciona. Precisa ser criado dentro do
  /// testWidgets (zona FakeAsync): criado no setUp, os handlers do bloc
  /// rodam na zona real e o BlocBuilder nunca é reconstruído.
  Future<void> fixBloc() async {
    bloc = ReceivingDocumentsBloc(
      harness.resolve(),
      harness.resolve(),
      harness.resolve(),
      harness.resolve(),
      harness.resolve(),
    );
    await harness.override<ReceivingDocumentsBloc>(bloc);
  }

  Future<void> pumpReceiving(WidgetTester tester,
      {Size surface = const Size(400, 1200)}) async {
    await fixBloc();
    await viaCep.run(() => pumpPage(
          tester,
          const ReceivingDocumentsPage(),
          observer: observer,
          routes: routes,
          surface: surface,
          locOverrides: locOverrides,
        ));
  }

  Future<void> open(WidgetTester tester) async {
    await fixBloc();
    await viaCep.run(() => pumpPage(
          tester,
          LauncherPage(ApplicationRoute.receivingDocuments),
          routes: routes,
          observer: observer,
          surface: const Size(400, 1400),
          locOverrides: locOverrides,
        ));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  Future<void> openAddressSheet(WidgetTester tester) async {
    await pumpReceiving(tester, surface: const Size(450, 1700));
    await tester.tap(find.text('use_another_address'));
    await tester.pumpAndSettle();
    expect(find.byType(ChangeAddressFormsWidget), findsOneWidget);
  }

  group('ReceivingDocumentsPage', () {
    testWidgets('contexto de notificação não numérico carrega com idUnidade=0',
        (tester) async {
      harness.sessionBloc.session.unity =
          testUnity(notificationContext: 'ctx-u1');
      await pumpReceiving(tester);

      expect(bloc.state, isA<ReceivingDocumentsLoadedState>());
      final get = harness.http.requests
          .firstWhere((r) => r.url.path == unitPersonalDataPath);
      expect(get.url.queryParameters['idUnidade'], '0');
    });

    testWidgets('carrega as preferências, contatos e endereço', (tester) async {
      await pumpReceiving(tester);

      expect(bloc.state, isA<ReceivingDocumentsLoadedState>());
      expect(loaded().hasChanges, isFalse);
      expect(find.text('receipt_of_documents'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('documents_receiving_msg'), findsOneWidget);
      for (final key in [
        'preferences_zero_paper_slips',
        'preferences_zero_paper_statements',
        'preferences_zero_paper_minutes',
        'preferences_zero_paper_announcements',
      ]) {
        expect(find.text(key), findsOneWidget);
      }
      expect(find.byType(PreferencesCheckBox), findsNWidgets(8));
      expect(find.text('corr@lello.com'), findsOneWidget);
      expect(find.text('01001-000, Rua das Flores, 100, Centro, São Paulo, SP'),
          findsOneWidget);
      expect(saveEnabled(tester), isFalse);
      expect(discardEnabled(tester), isFalse);
      expect(requested(),
          ['GET $streetTypesPath', 'GET $unitPersonalDataPath']);
      // O CEP do condomínio é consultado no ViaCEP para descobrir a cidade.
      expect(viaCep.requests.single, contains('/ws/02002000/json'));
      expect(bloc.data?.condoAddressData?.cityName, 'São Paulo');
      expect(bloc.data?.condoAddressData?.complement, '');
      expect(bloc.streetType?.name, 'Rua');
      expect(bloc.states, contains('SP'));
      expect(bloc.personalEmail, 'ana@lello.com');
      expect(
        loaded().preferences.map((p) => p.choice),
        [
          ZeroPaperPreferenceChoiceEnum.printed,
          ZeroPaperPreferenceChoiceEnum.email,
          ZeroPaperPreferenceChoiceEnum.email,
          ZeroPaperPreferenceChoiceEnum.both,
        ],
      );
      await expectLater(
        find.byType(ReceivingDocumentsPage),
        matchesGoldenFile('goldens/receiving_documents_page.png'),
      );
    });

    testWidgets('com endereço do condomínio mostra o endereço do condomínio',
        (tester) async {
      harness.http.on('GET', unitPersonalDataPath,
          body: accessJson(useCondoAddress: true));
      await pumpReceiving(tester);

      expect(
        find.text('02002-000, Avenida Paulista, 1000, Bela Vista, São Paulo, SP'),
        findsOneWidget,
      );
    });

    testWidgets('ViaCEP fora do ar não impede o carregamento', (tester) async {
      viaCep.status = 500;
      await pumpReceiving(tester);

      expect(bloc.state, isA<ReceivingDocumentsLoadedState>());
      expect(bloc.data?.condoAddressData?.complement, 'null');
      expect(bloc.streetType, isNull);
    });

    testWidgets('marcar e desmarcar as opções controla "salvar"',
        (tester) async {
      await pumpReceiving(tester);
      bool checked(int i) =>
          tester.widget<PreferencesCheckBox>(checkbox(i)).checked;

      // Boletos: impresso → marcar digital = ambos.
      expect(checked(0), isFalse);
      expect(checked(1), isTrue);
      await tester.tap(checkbox(0));
      await tester.pumpAndSettle();
      expect(loaded().preferences[0].choice, ZeroPaperPreferenceChoiceEnum.both);
      expect(checked(0), isTrue);
      expect(loaded().hasChanges, isTrue);
      expect(saveEnabled(tester), isTrue);
      expect(discardEnabled(tester), isTrue);

      // ambos → desmarcar digital = impresso (volta ao inicial).
      await tester.tap(checkbox(0));
      await tester.pumpAndSettle();
      expect(loaded().preferences[0].choice,
          ZeroPaperPreferenceChoiceEnum.printed);
      expect(loaded().hasChanges, isFalse);
      expect(saveEnabled(tester), isFalse);

      // impresso → tocar impresso de novo não muda nada.
      await tester.tap(checkbox(1));
      await tester.pumpAndSettle();
      expect(loaded().preferences[0].choice,
          ZeroPaperPreferenceChoiceEnum.printed);

      // Demonstrativos: digital → marcar impresso = ambos → desmarcar
      // impresso = digital.
      await tester.tap(checkbox(3));
      await tester.pumpAndSettle();
      expect(loaded().preferences[1].choice, ZeroPaperPreferenceChoiceEnum.both);
      await tester.tap(checkbox(3));
      await tester.pumpAndSettle();
      expect(loaded().preferences[1].choice, ZeroPaperPreferenceChoiceEnum.email);

      // Comunicados: ambos → desmarcar impresso = digital.
      await tester.tap(checkbox(7));
      await tester.pumpAndSettle();
      expect(loaded().preferences[3].choice, ZeroPaperPreferenceChoiceEnum.email);
      expect(loaded().hasChanges, isTrue);
    });

    testWidgets('salvar envia as preferências e o "propagar" e confirma',
        (tester) async {
      await pumpReceiving(tester);

      await tester.tap(checkbox(0));
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(loaded().accessData.propagateOtherUnits, isTrue);

      await tester.tap(saveButton());
      await tester.pumpAndSettle();

      final body = lastPutBody();
      expect(body['propagarOutrasUnidades'], isTrue);
      expect(body['dadosPessoais']['cpf'], '12345678901');
      expect(body['dadosPapelZeroUnidade']['boletosImpressos'], isTrue);
      expect(body['dadosPapelZeroUnidade']['boletosEmail'], isTrue);
      expect(body['dadosPapelZeroUnidade']['demonstrativosImpresso'], isFalse);
      expect(body['dadosPapelZeroUnidade']['demonstrativosEmail'], isTrue);
      expect(body['dadosEnderecoUnidade']['tipoLogradouro'], 'Rua');
      expect(find.text('profile_update_success'), findsOneWidget);

      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(find.text('profile_update_success'), findsNothing);
      expect(loaded().hasChanges, isFalse);
      expect(saveEnabled(tester), isFalse);

      // Desligar o "propagar" volta a ficar sem mudanças.
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(loaded().hasChanges, isTrue);
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(loaded().hasChanges, isFalse);
    });

    testWidgets('falha ao salvar mostra o erro', (tester) async {
      await pumpReceiving(tester);
      harness.http.on('PUT', unitPersonalDataPath,
          status: 500, body: {'message': 'x'});

      await tester.tap(checkbox(0));
      await tester.pumpAndSettle();
      await tester.tap(saveButton());
      await tester.pumpAndSettle();

      expect(bloc.state, isA<ReceivingDocumentsFailureState>());
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      expect(find.text('profile_update_success'), findsNothing);
      // Sem rodapé no estado de erro.
      expect(find.text('save'), findsNothing);
    });

    testWidgets('falha ao carregar: tentar de novo e voltar', (tester) async {
      harness.http.on('GET', unitPersonalDataPath,
          status: 500, body: {'message': 'x'});
      await open(tester);

      expect(bloc.state, isA<ReceivingDocumentsFailureState>());
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      harness.http.on('GET', unitPersonalDataPath, body: accessJson());
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(bloc.state, isA<ReceivingDocumentsLoadedState>());
      expect(find.byType(PreferencesCheckBox), findsNWidgets(8));

      harness.http.on('GET', unitPersonalDataPath,
          status: 500, body: {'message': 'x'});
      await emitState(tester, bloc, const ReceivingDocumentsLoadingState(),
          settle: false);
      await tester.pump();
      expect(find.text('please_wait'), findsOneWidget);

      await emitState(
          tester, bloc, const ReceivingDocumentsFailureState(error: 'x'));
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(find.byType(ReceivingDocumentsPage), findsNothing);
      expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    });

    testWidgets('estado inicial não mostra conteúdo', (tester) async {
      await pumpReceiving(tester);
      await emitState(tester, bloc, const ReceivingDocumentsInitialState());

      expect(find.byType(PreferencesCheckBox), findsNothing);
      expect(find.byType(ErrorHandlingWidget), findsNothing);
      expect(find.text('save'), findsOneWidget);
      expect(saveEnabled(tester), isFalse);
    });

    testWidgets('descartar mudanças pede confirmação e fecha a página',
        (tester) async {
      await open(tester);
      await tester.tap(checkbox(0));
      await tester.pumpAndSettle();

      await tester.tap(discardButton());
      await tester.pumpAndSettle();
      expect(
          find.text('paper_zero_unsaved_changes_dialog_title'), findsOneWidget);
      await tester.tap(find.text('paper_zero_unsaved_changes_dialog_cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ReceivingDocumentsPage), findsOneWidget);

      await tester.tap(discardButton());
      await tester.pumpAndSettle();
      await tester.tap(find.text('paper_zero_unsaved_changes_dialog_confirm'));
      await tester.pumpAndSettle();

      expect(find.byType(ReceivingDocumentsPage), findsNothing);
      expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    });

    testWidgets('voltar com mudanças pendentes pede confirmação',
        (tester) async {
      await open(tester);
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      // Sem mudanças fecha direto.
      navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(ReceivingDocumentsPage), findsNothing);

      // Nova instância do bloc, como no app (factory): `init()` só pode
      // rodar uma vez por bloc (`personalEmail` é `late final`).
      await fixBloc();
      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();
      await tester.tap(checkbox(0));
      await tester.pumpAndSettle();

      navigator.maybePop();
      await tester.pumpAndSettle();
      expect(
          find.text('paper_zero_unsaved_changes_dialog_title'), findsOneWidget);
      await tester.tap(find.text('paper_zero_unsaved_changes_dialog_cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(ReceivingDocumentsPage), findsOneWidget);

      navigator.maybePop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('paper_zero_unsaved_changes_dialog_confirm'));
      await tester.pumpAndSettle();
      expect(find.byType(ReceivingDocumentsPage), findsNothing);
      expect(find.byKey(LauncherPage.launcherKey), findsOneWidget);
    });
  });

  group('ChangeEmailWidget', () {
    testWidgets('usar o e-mail pessoal preenche e salva', (tester) async {
      await pumpReceiving(tester);

      await tester.tap(find.text('use_another_email'));
      await tester.pumpAndSettle();

      expect(find.byType(ChangeEmailWidget), findsOneWidget);
      expect(find.text('add_another_email'), findsOneWidget);
      final conclude = find.widgetWithText(ElevatedButton, 'conclude');
      expect(tester.widget<ElevatedButton>(conclude).enabled, isFalse);

      final personalSwitch = find.descendant(
          of: find.byType(ChangeEmailWidget), matching: find.byType(Switch));
      await tester.tap(personalSwitch);
      await tester.pumpAndSettle();
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(tester.widget<ElevatedButton>(conclude).enabled, isTrue);

      // Desligar limpa; ligar de novo volta a preencher.
      await tester.tap(personalSwitch);
      await tester.pumpAndSettle();
      expect(find.text('ana@lello.com'), findsNothing);
      await tester.tap(personalSwitch);
      await tester.pumpAndSettle();

      await tester.tap(conclude);
      await tester.pumpAndSettle();

      expect(find.byType(ChangeEmailWidget), findsNothing);
      expect(lastPutBody()['dadosContatoUnidade']['emailCorrespondencia'],
          'ana@lello.com');
      expect(find.text('profile_update_success'), findsOneWidget);
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      expect(bloc.state, isA<ReceivingDocumentsLoadedState>());
    });

    testWidgets('e-mail digitado é validado antes de salvar', (tester) async {
      await pumpReceiving(tester);
      await tester.tap(find.text('use_another_email'));
      await tester.pumpAndSettle();
      final conclude = find.widgetWithText(ElevatedButton, 'conclude');

      await tester.enterText(find.byType(TextFormField), 'abc');
      await tester.pumpAndSettle();
      await tester.tap(conclude);
      await tester.pumpAndSettle();
      expect(find.text('validation_invalid_email'), findsOneWidget);
      expect(find.byType(ChangeEmailWidget), findsOneWidget);
      expect(requested(), isNot(contains('PUT $unitPersonalDataPath')));

      await tester.enterText(find.byType(TextFormField), 'novo@lello.com');
      await tester.pumpAndSettle();
      await tester.tap(conclude);
      await tester.pumpAndSettle();

      expect(find.byType(ChangeEmailWidget), findsNothing);
      expect(lastPutBody()['dadosContatoUnidade']['emailCorrespondencia'],
          'novo@lello.com');
      expect(find.text('profile_update_success'), findsOneWidget);
    });

    testWidgets('golden', (tester) async {
      await pumpApp(
        tester,
        ChangeEmailWidget(email: 'ana@lello.com', onChanged: (_) {}),
        localized: true,
      );
      await expectLater(
        findGoldenSurface(),
        matchesGoldenFile('goldens/change_email_widget.png'),
      );
    });
  });

  group('ChangeAddressFormsWidget', () {
    Finder addressField(int index) => find.byType(TextFormField).at(index);
    Finder unitSwitch() => find.descendant(
        of: find.byType(ChangeAddressFormsWidget),
        matching: find.byType(Switch));

    testWidgets('abre preenchido com o endereço da unidade', (tester) async {
      await openAddressSheet(tester);

      expect(find.text('add_another_address'), findsOneWidget);
      expect(find.text('01001-000'), findsOneWidget);
      expect(find.text('das Flores'), findsOneWidget);
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Centro'), findsOneWidget);
      expect(find.text('ap 1'), findsOneWidget);
      expect(find.text('Rua'), findsOneWidget);
      expect(find.text('SP'), findsOneWidget);
      expect(find.text('SAO PAULO'), findsOneWidget);
      expect(bloc.addressCity?.name, 'SAO PAULO');
      final conclude = find.widgetWithText(ElevatedButton, 'conclude');
      expect(tester.widget<ElevatedButton>(conclude).enabled, isFalse);
      expect(harness.http.requests.last.url.queryParameters['uf'], 'SP');
      await expectLater(
        find.byType(ChangeAddressFormsWidget),
        matchesGoldenFile('goldens/change_address_forms_widget.png'),
      );
    });

    testWidgets('"usar endereço da unidade" copia o endereço do condomínio',
        (tester) async {
      await openAddressSheet(tester);

      await tester.tap(unitSwitch());
      await tester.pumpAndSettle();

      expect(find.text('02002-000'), findsOneWidget);
      expect(find.text('Paulista'), findsOneWidget);
      expect(find.text('1000'), findsOneWidget);
      expect(find.text('Bela Vista'), findsOneWidget);
      expect(find.text('Avenida'), findsOneWidget);
      expect(bloc.streetType?.name, 'Avenida');
      expect(tester.widget<TextFormField>(addressField(1)).enabled, isFalse);
      final conclude = find.widgetWithText(ElevatedButton, 'conclude');
      expect(tester.widget<ElevatedButton>(conclude).enabled, isTrue);

      await tester.tap(conclude);
      await tester.pumpAndSettle();

      expect(find.byType(ChangeAddressFormsWidget), findsNothing);
      final address = lastPutBody()['dadosEnderecoUnidade'];
      expect(address['cep'], '02002-000');
      expect(address['nomeLogradouro'], 'Paulista');
      expect(address['numero'], '1000');
      expect(address['bairro'], 'Bela Vista');
      expect(address['nomeCidade'], 'SAO PAULO');
      expect(address['uf'], 'SP');
      expect(address['tipoLogradouro'], 'Avenida');
      expect(find.text('profile_update_success'), findsOneWidget);

      // Desligar o switch reabilita os campos.
      await tester.tap(find.text('ok'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('use_another_address'));
      await tester.pumpAndSettle();
      await tester.tap(unitSwitch());
      await tester.pumpAndSettle();
      await tester.tap(unitSwitch());
      await tester.pumpAndSettle();
      expect(tester.widget<TextFormField>(addressField(1)).enabled, isTrue);
    });

    testWidgets('CEP digitado consulta o ViaCEP e preenche os campos',
        (tester) async {
      await openAddressSheet(tester);

      await viaCep.run(() async {
        await tester.enterText(addressField(0), '99999-999');
        await tester.pumpAndSettle();
      });
      expect(find.text('CEP inexistente.'), findsOneWidget);
      expect(viaCep.requests.last, contains('/ws/99999999/json'));

      await viaCep.run(() async {
        await tester.enterText(addressField(0), '01001-000');
        await tester.pumpAndSettle();
      });

      expect(find.text('CEP inexistente.'), findsNothing);
      expect(find.text('Praça da Sé'), findsOneWidget);
      expect(find.text('Sé'), findsOneWidget);
      expect(tester.widget<TextFormField>(addressField(2)).controller?.text, '');
      expect(tester.widget<TextFormField>(addressField(4)).controller?.text, '');
      expect(bloc.addressCity?.name, 'SAO PAULO');
      // O ViaCEP zera o tipo de logradouro: precisa escolher de novo.
      expect(bloc.streetType, isNull);
      final conclude = find.widgetWithText(ElevatedButton, 'conclude');

      /// Corrigido: depois do ViaCEP preencher os campos `_checkIfHasChanges`
      /// roda de novo, então "concluir" já fica habilitado (logradouro e
      /// bairro mudaram, número foi limpo) mesmo com o CEP igual ao da unidade.
      expect(tester.widget<ElevatedButton>(conclude).enabled, isTrue);

      await tester.enterText(addressField(2), '7');
      await tester.pumpAndSettle();
      expect(tester.widget<ElevatedButton>(conclude).enabled, isTrue);
      await tester.tap(conclude);
      await tester.pumpAndSettle();
      expect(find.text('validation_required'), findsOneWidget);
      expect(find.byType(ChangeAddressFormsWidget), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<StreetTypeEntity>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Avenida').last);
      await tester.pumpAndSettle();
      expect(bloc.streetType?.name, 'Avenida');

      await tester.tap(conclude);
      await tester.pumpAndSettle();

      expect(find.byType(ChangeAddressFormsWidget), findsNothing);
      final address = lastPutBody()['dadosEnderecoUnidade'];
      expect(address['cep'], '01001-000');
      expect(address['nomeLogradouro'], 'Praça da Sé');
      expect(address['numero'], '7');
      expect(address['bairro'], 'Sé');
      expect(address['nomeCidade'], 'SAO PAULO');
      expect(address['tipoLogradouro'], 'Avenida');
    });

    testWidgets('trocar estado e cidade', (tester) async {
      await openAddressSheet(tester);
      harness.http.on('GET', citiesPath, body: [rioCity, campinasCity]);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('RJ').last);
      await tester.pumpAndSettle();

      expect(harness.http.requests.last.url.queryParameters['uf'], 'RJ');
      expect(bloc.cities.map((c) => c.name), ['RIO DE JANEIRO', 'CAMPINAS']);
      expect(bloc.addressCity, isNull);
      final conclude = find.widgetWithText(ElevatedButton, 'conclude');

      /// Corrigido: o `onChanged` do estado grava a nova UF ANTES de chamar
      /// `_checkIfHasChanges`, então trocar só o estado já habilita "concluir".
      expect(tester.widget<ElevatedButton>(conclude).enabled, isTrue);
      await tester.enterText(addressField(4), 'casa 2');
      await tester.pumpAndSettle();
      expect(tester.widget<ElevatedButton>(conclude).enabled, isTrue);

      // Sem cidade o formulário não passa.
      await tester.tap(conclude);
      await tester.pumpAndSettle();
      expect(find.text('validation_required'), findsOneWidget);

      await tester.tap(find.byType(DropdownButtonFormField<City>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('RIO DE JANEIRO').last);
      await tester.pumpAndSettle();
      expect(bloc.addressCity?.name, 'RIO DE JANEIRO');

      await tester.tap(conclude);
      await tester.pumpAndSettle();

      expect(find.byType(ChangeAddressFormsWidget), findsNothing);
      final address = lastPutBody()['dadosEnderecoUnidade'];
      expect(address['uf'], 'RJ');
      expect(address['nomeCidade'], 'RIO DE JANEIRO');
      expect(address['complemento'], 'casa 2');
    });

    testWidgets('campos obrigatórios vazios bloqueiam a conclusão',
        (tester) async {
      await openAddressSheet(tester);

      await tester.enterText(addressField(1), '');
      await tester.enterText(addressField(2), '');
      await tester.enterText(addressField(3), '');
      await tester.enterText(addressField(0), '123');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ElevatedButton, 'conclude'));
      await tester.pumpAndSettle();

      expect(find.text('validation_required'), findsNWidgets(3));
      expect(find.byType(ChangeAddressFormsWidget), findsOneWidget);
      expect(requested(), isNot(contains('PUT $unitPersonalDataPath')));
    });

    testWidgets('sem tipos de logradouro carregados busca ao abrir',
        (tester) async {
      harness.http.on('GET', streetTypesPath,
          status: 500, body: {'message': 'x'});
      await pumpReceiving(tester, surface: const Size(450, 1700));
      expect(bloc.streetTypes, isEmpty);
      harness.http.on('GET', streetTypesPath, body: streetTypesJson);

      await tester.tap(find.text('use_another_address'));
      await tester.pumpAndSettle();

      expect(bloc.streetTypes, hasLength(2));
      expect(bloc.streetType?.name, 'Rua');
      expect(find.text('Rua'), findsOneWidget);
    });
  });

  test('conversão de preferências ida e volta', () {
    final bloc = harness.resolve<ReceivingDocumentsBloc>();
    final data = bloc.getPreference(
      bloc.preferencesToUnitPaperless([
        ZeroPaperItemModel(
            type: ZeroPaperPreferenceTypeEnum.bankSlip,
            choice: ZeroPaperPreferenceChoiceEnum.both),
        ZeroPaperItemModel(
            type: ZeroPaperPreferenceTypeEnum.statements,
            choice: ZeroPaperPreferenceChoiceEnum.printed),
        ZeroPaperItemModel(
            type: ZeroPaperPreferenceTypeEnum.minutesAndNotices,
            choice: ZeroPaperPreferenceChoiceEnum.email),
        ZeroPaperItemModel(
            type: ZeroPaperPreferenceTypeEnum.announcements,
            choice: ZeroPaperPreferenceChoiceEnum.email),
      ]),
    );
    expect(data.map((p) => p.choice), [
      ZeroPaperPreferenceChoiceEnum.both,
      ZeroPaperPreferenceChoiceEnum.printed,
      ZeroPaperPreferenceChoiceEnum.email,
      ZeroPaperPreferenceChoiceEnum.email,
    ]);
    bloc.setStreetType(StreetTypeEntity(type: 'R', name: 'Rua', dtFlex: ''));
    expect(bloc.streetType?.name, 'Rua');
  });
}
