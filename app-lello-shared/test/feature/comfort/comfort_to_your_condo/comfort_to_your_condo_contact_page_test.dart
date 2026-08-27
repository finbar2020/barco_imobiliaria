import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_contact_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_result_page.dart';

import '../../../helpers/firebase_mocks.dart';
import '../../../helpers/pump_app.dart';
import '../comfort_core_fixtures.dart';
import 'to_your_condo_harness.dart';

const requestPath = '/condominiums/C1/comfort/requestPartners';

void main() {
  late RecordingNavigatorObserver observer;
  late ToYourCondoHarness harness;

  setUpAll(() async {
    await setUpFakeFirebase();
  });

  setUp(() {
    observer = RecordingNavigatorObserver();
  });

  tearDown(() async {
    await harness.dispose();
  });

  /// Base -> página de contato, com o controller já com parceiros carregados
  /// (a página usa o último estado carregado ao enviar).
  Future<void> pumpContact(WidgetTester tester,
      {FakeSession? session, bool load = true}) async {
    harness = ToYourCondoHarness.create(session: session);
    if (load) await harness.loadPartners();
    await pumpPage(
      tester,
      basePage(),
      observer: observer,
      routes: {contactRouteName: (_) => harness.contactPage()},
    );
    await pushRoute(tester, contactRouteName);
  }

  Finder sendButton() => find.widgetWithText(ElevatedButton, 'Enviar solicitação');

  bool sendEnabled(WidgetTester tester) =>
      tester.widget<ElevatedButton>(sendButton()).enabled;

  Map<String, dynamic> sentBody() => jsonDecode(harness.http.requests
      .lastWhere((r) => r.url.path == requestPath)
      .body) as Map<String, dynamic>;

  testWidgets('mostra as opções e o botão começa desabilitado', (tester) async {
    await pumpContact(tester);

    expect(find.text('Como deseja ser contatado?'), findsOneWidget);
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Whatsapp'), findsOneWidget);
    expect(find.text('Telefone'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(sendEnabled(tester), isFalse);
  });

  testWidgets('e-mail da sessão: selecionar habilita, desmarcar limpa',
      (tester) async {
    await pumpContact(tester);

    await tester.tap(find.text('E-mail'));
    await tester.pumpAndSettle();
    expect(find.text('user@lello.com'), findsOneWidget);
    expect(find.text('Informar outro e-mail'), findsOneWidget);
    expect(find.byType(TextFormField), findsNothing);
    expect(sendEnabled(tester), isFalse);

    await tester.tap(find.text('user@lello.com'));
    await tester.pumpAndSettle();
    expect(sendEnabled(tester), isTrue);

    await expectLater(find.byType(MaterialApp),
        matchesGoldenFile('goldens/to_your_condo_contact_email.png'));

    // Desmarca o e-mail: some a lista e o botão desabilita.
    await tester.tap(find.text('E-mail'));
    await tester.pumpAndSettle();
    expect(find.text('user@lello.com'), findsNothing);
    expect(sendEnabled(tester), isFalse);
  });

  testWidgets('outro e-mail: valida o campo antes de enviar e envia o válido',
      (tester) async {
    await pumpContact(tester);
    harness.http.on('POST', requestPath, body: {});

    await tester.tap(find.text('E-mail'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Informar outro e-mail'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsOneWidget);
    expect(sendEnabled(tester), isFalse);

    await tester.enterText(find.byType(TextFormField), 'invalido');
    await tester.pumpAndSettle();
    expect(sendEnabled(tester), isTrue);
    await tester.tap(sendButton());
    await tester.pumpAndSettle();
    expect(find.text('validation_invalid_email'), findsOneWidget);
    expect(harness.http.requests.where((r) => r.url.path == requestPath), isEmpty);

    await tester.enterText(find.byType(TextFormField), 'novo@email.com');
    await tester.tap(sendButton());
    await tester.pumpAndSettle();

    expect(sentBody(), {
      'email': 'novo@email.com',
      'whatsapp': '',
      'phone': '',
      'partners': ['p1', 'p4'],
    });
    expect(find.byType(ComfortToYourCondoResultPage), findsOneWidget);
    expect(find.text('Solicitação enviada com sucesso!'), findsOneWidget);

    await tester.tap(find.text('comfort_disfavor_conclude'));
    await tester.pumpAndSettle();
    expect(findBasePage(), findsOneWidget);
    expect(find.byType(ComfortToYourCondoContactPage), findsNothing);
  });

  testWidgets('sem e-mail nem telefone na sessão já abre os campos',
      (tester) async {
    await pumpContact(
        tester,
        session: FakeSession(
          condominium: FakeCondo(),
          selectedCondominium: FakeCondo(),
          me: FakeMe(email: '', phone: null),
        ));

    await tester.tap(find.text('E-mail'));
    await tester.pumpAndSettle();
    expect(find.text('Informe um e-mail'), findsOneWidget);
    expect(find.text('Informar outro e-mail'), findsNothing);
    expect(find.byType(TextFormField), findsOneWidget);

    await tester.tap(find.text('Whatsapp'));
    await tester.pumpAndSettle();
    expect(find.text('Informe um número'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    await tester.tap(find.text('Telefone'));
    await tester.pumpAndSettle();
    expect(find.text('Informe um número'), findsNWidgets(2));
    expect(find.byType(TextFormField), findsNWidgets(3));

    // Whatsapp inválido bloqueia o envio.
    await tester.enterText(find.byType(TextFormField).at(1), '123');
    await tester.pumpAndSettle();
    expect(sendEnabled(tester), isTrue);
    await tester.tap(sendButton());
    await tester.pumpAndSettle();
    expect(find.text('validation_invalid_phone'), findsWidgets);
    expect(find.byType(ComfortToYourCondoResultPage), findsNothing);

    // Desmarcar whatsapp e telefone limpa as escolhas.
    await tester.tap(find.text('Whatsapp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Telefone'));
    await tester.pumpAndSettle();
    expect(find.byType(TextFormField), findsOneWidget);
    expect(sendEnabled(tester), isFalse);
  });

  testWidgets('whatsapp e telefone da sessão são enviados', (tester) async {
    await pumpContact(tester);
    harness.http.on('POST', requestPath, body: {});

    await tester.tap(find.text('Whatsapp'));
    await tester.pumpAndSettle();
    expect(find.text('11999998888'), findsOneWidget);
    expect(find.text('Informar outro número'), findsOneWidget);
    await tester.tap(find.text('11999998888'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Telefone'));
    await tester.pumpAndSettle();
    expect(find.text('11999998888'), findsNWidgets(2));
    await tester.tap(find.text('Informar outro número').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField), '11988887777');
    await tester.pumpAndSettle();

    await tester.tap(sendButton());
    await tester.pumpAndSettle();

    expect(sentBody(), {
      'email': '',
      'whatsapp': '11999998888',
      'phone': '11988887777',
      'partners': ['p1', 'p4'],
    });
    expect(find.text('Solicitação enviada com sucesso!'), findsOneWidget);
  });

  testWidgets('telefone da sessão selecionado direto', (tester) async {
    await pumpContact(tester);
    harness.http.on('POST', requestPath, body: {});

    await tester.tap(find.text('Telefone'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('11999998888'));
    await tester.pumpAndSettle();
    await tester.tap(sendButton());
    await tester.pumpAndSettle();

    expect(sentBody()['phone'], '11999998888');
    expect(sentBody()['whatsapp'], '');
  });

  testWidgets('falha no envio abre o resultado de erro e permite tentar de novo',
      (tester) async {
    await pumpContact(tester);
    harness.http.on('POST', requestPath, status: 500, body: {'message': 'erro'});

    await tester.tap(find.text('E-mail'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('user@lello.com'));
    await tester.pumpAndSettle();
    await tester.tap(sendButton());
    await tester.pumpAndSettle();

    expect(find.text('Falha no envio da solicitação'), findsOneWidget);
    expect((harness.bloc.state as LoadedComfortPartnersState).isFailedCondoPartners,
        isTrue);

    // Tentar novamente com o servidor de volta: nova requisição e sucesso.
    harness.http.on('POST', requestPath, body: {});
    await tester.tap(find.text('try_again'));
    await tester.pumpAndSettle();

    expect(harness.http.requests.where((r) => r.url.path == requestPath),
        hasLength(2));
    expect(find.text('Solicitação enviada com sucesso!'), findsOneWidget);
    expect(
        (harness.bloc.state as LoadedComfortPartnersState).isSuccessYourCondoPartners,
        isTrue);
  });

  testWidgets('falha: cancelar volta para a página base', (tester) async {
    await pumpContact(tester);
    harness.http.on('POST', requestPath, status: 500, body: {'message': 'erro'});

    await tester.tap(find.text('Whatsapp'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('11999998888'));
    await tester.pumpAndSettle();
    await tester.tap(sendButton());
    await tester.pumpAndSettle();

    await tester.tap(find.text('cancel'));
    await tester.pumpAndSettle();

    expect(findBasePage(), findsOneWidget);
    expect(find.byType(ComfortToYourCondoContactPage), findsNothing);
  });

  testWidgets('estado de carregando mostra o loading', (tester) async {
    await pumpContact(tester);

    harness.bloc
        // ignore: invalid_use_of_visible_for_testing_member
        .emit(const LoadingComfortPartnersState());
    await tester.pump();
    await tester.pump();

    expect(find.byType(LoadingWidget), findsOneWidget);
    expect(find.text('Como deseja ser contatado?'), findsNothing);
  });
}
