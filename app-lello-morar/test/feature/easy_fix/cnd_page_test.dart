import 'dart:convert';
import 'dart:io';

import 'package:essentials/essentials.dart' hide isNull, isNotNull;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/bloc/cnd_state.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/controller/cnd_controller.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/pages/cnd_page.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/widget/cnd_error_dialog.dart';
import 'package:morar/feature/easy_fix/cnd/presentation/widget/cnd_form.dart';
import 'package:morar/feature/easy_fix/domain/entity/easy_fix_unit_entity.dart';

import '../../helpers/fake_url_launcher.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

const _unitPath = '/condominiums/c1/easyfix/unit-contact';
const _cndPath = '/condominiums/c1/easyfix/cnd';
const _pathProviderChannel = MethodChannel('plugins.flutter.io/path_provider');

/// As chaves cruas do AppLocalization de teste não cabem na linha de botões
/// do CndErrorDialog (overflow); usamos textos curtos como no app.
const _locOverrides = {
  'later': 'Depois',
  'registration_lello_warning_no_data_btn': 'Falar com a Lello',
};

Map<String, dynamic> _unit({String email = 'ana@lello.com'}) => {
      'name': 'Ana Silva',
      'cpf_cnpj': '12345678901',
      'email': email,
      'cellphone': '11999998888',
      'phone': '1132048116',
      'cep': '01001-000',
      'address': 'Praça da Sé',
      'address_number': '1',
      'address_complement': 'ap 1',
      'address_neighborhood': 'Sé',
      'address_state': 'SP',
      'address_city': {'ibge_code': 3550308, 'name': 'SAO PAULO'},
    };

/// Tela inicial que empurra a página da CND por cima, para observar `pop`s.
class _Launcher extends StatelessWidget {
  const _Launcher();

  @override
  Widget build(BuildContext context) => Scaffold(
        key: const Key('launcher'),
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: '/cnd'),
                builder: (_) => const CertificateNoOutstandingDebtPage(),
              ),
            ),
            child: const Text('abrir'),
          ),
        ),
      );
}

void main() {
  late PageHarness harness;
  late FakeUrlLauncherPlatform launcher;

  setUp(() async {
    harness = await installPageHarness();
    launcher = installFakeUrlLauncher();
    harness.http.on('GET', _unitPath, body: _unit());
  });

  CertificateNoOutstandingDebtController controller() =>
      harness.resolve<CertificateNoOutstandingDebtController>();

  void mockDebt() => harness.http.on('POST', _cndPath,
      status: 409, body: {'status': 409, 'detail': 'Há débitos em aberto'});

  void mockError() => harness.http
      .on('POST', _cndPath, status: 500, body: {'status': 500, 'detail': 'x'});

  Iterable<String> requested() =>
      harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  Future<void> open(WidgetTester tester) async {
    await pumpPage(tester, const _Launcher(),
        surface: const Size(400, 1200), locOverrides: _locOverrides);
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  Finder field(int index) => find.byType(TextFormField).at(index);

  group('CertificateNoOutstandingDebtPage', () {
    testWidgets('com débito em aberto mostra o aviso; "depois" fecha a tela',
        (tester) async {
      mockDebt();
      await open(tester);

      expect(requested(), ['GET $_unitPath', 'POST $_cndPath']);
      expect(controller().bloc.state, isA<HasOutstandingDebtState>());
      expect(find.byType(CndErrorDialog), findsOneWidget);
      expect(find.text('chat_error_title!'), findsOneWidget);
      expect(find.text('cnd_unable_issue'), findsOneWidget);
      expect(find.text('DEPOIS'), findsOneWidget);
      await expectLater(
        find.byType(Dialog),
        matchesGoldenFile('goldens/cnd_error_dialog.png'),
      );

      await tester.tap(find.text('DEPOIS'));
      await tester.pumpAndSettle();

      expect(find.byType(CndErrorDialog), findsNothing);
      expect(find.byType(CertificateNoOutstandingDebtPage), findsNothing);
      expect(find.byKey(const Key('launcher')), findsOneWidget);
    });

    testWidgets('"falar com a Lello" fecha a tela e abre o WhatsApp',
        (tester) async {
      mockDebt();
      await open(tester);

      await tester.tap(find.text('FALAR COM A LELLO'));
      await tester.pumpAndSettle();

      expect(find.byType(CertificateNoOutstandingDebtPage), findsNothing);
      expect(find.byKey(const Key('launcher')), findsOneWidget);
      expect(launcher.launched.single, startsWith('https://wa.me/'));
      expect(launcher.launched.single, contains('text=Oi'));
    });

    testWidgets('erro inesperado ao gerar mostra o widget de erro',
        (tester) async {
      mockError();
      await pumpPage(tester, const CertificateNoOutstandingDebtPage());

      expect(controller().bloc.state,
          isA<CertificateNoOutstandingDebtFailureState>());
      expect(find.byType(UnexpectedErrorWidget), findsOneWidget);
      expect(find.text('unexpected_error_title'), findsOneWidget);
    });

    testWidgets('cadastro incompleto mostra o formulário para completar',
        (tester) async {
      harness.http.on('GET', _unitPath, body: _unit(email: ''));
      mockError();
      await pumpPage(tester, const CertificateNoOutstandingDebtPage(),
          surface: const Size(400, 1200));

      /// Corrigido: com e-mail/telefone faltando o controller emite
      /// `UnitProfileLoadedEvent` em vez de tentar gerar a certidão, e o
      /// formulário aparece (antes a geração falhava e a tela ficava vazia).
      expect(controller().bloc.state, isA<UnitProfileLoadedState>());
      expect(find.byType(CertificateNoOutstandingDebtForm), findsOneWidget);
      expect(find.byType(UnexpectedErrorWidget), findsNothing);
      expect(requested(), ['GET $_unitPath']);
      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('(11) 99999-8888'), findsOneWidget);
    });

    testWidgets('falha ao carregar a unidade mostra o widget de erro',
        (tester) async {
      harness.http.on('GET', _unitPath, status: 500, body: {'message': 'x'});
      await pumpPage(tester, const CertificateNoOutstandingDebtPage());

      expect(controller().bloc.state, isA<UnitProfileFailureState>());
      expect(find.byType(UnexpectedErrorWidget), findsOneWidget);
      expect(requested(), ['GET $_unitPath']);
    });

    testWidgets('estados de loading mostram o indicador', (tester) async {
      mockError();
      await pumpPage(tester, const CertificateNoOutstandingDebtPage());
      final bloc = controller().bloc;

      await emitState(tester, bloc, const UnitProfileLoadingState(),
          settle: false);
      await tester.pump();
      expect(find.text('please_wait'), findsOneWidget);

      await emitState(
          tester, bloc, const CertificateNoOutstandingDebtLoadingState(),
          settle: false);
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await emitState(
          tester, bloc, const CertificateNoOutstandingDebtInitialState());
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(UnexpectedErrorWidget), findsNothing);
    });

    testWidgets('formulário valida e gera a certidão com os dados digitados',
        (tester) async {
      mockError();
      await pumpPage(tester, const CertificateNoOutstandingDebtPage(),
          surface: const Size(400, 1200), locOverrides: _locOverrides);

      /// Com o cadastro completo o controller gera a certidão direto após
      /// carregar a unidade (o formulário só aparece no fluxo real com
      /// cadastro incompleto), então aqui o estado é emitido manualmente.
      await emitState(tester, controller().bloc,
          UnitProfileLoadedState(unit: controller().unit!));

      expect(find.byType(CertificateNoOutstandingDebtForm), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('Ana Silva'), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(find.text('(11) 3204-8116'), findsOneWidget);
      expect(find.text('(11) 99999-8888'), findsOneWidget);
      await expectLater(
        find.byType(CertificateNoOutstandingDebtPage),
        matchesGoldenFile('goldens/cnd_page.png'),
      );

      await tester.enterText(field(1), '');
      await tester.enterText(field(3), '(11) 1');
      await tester.enterText(field(4), '(11) 1');
      await tester.tap(find.text('cnd_generate'));
      await tester.pumpAndSettle();

      expect(find.text('validation_required'), findsOneWidget);
      expect(find.text('validation_invalid_landline'), findsOneWidget);
      expect(find.text('validation_invalid_phone'), findsOneWidget);
      expect(requested().where((r) => r == 'POST $_cndPath'), hasLength(1));

      await tester.enterText(field(1), 'nova@lello.com');
      await tester.enterText(field(3), '(11) 3333-4444');
      await tester.enterText(field(4), '(11) 98888-7777');
      mockDebt();
      await tester.tap(find.text('cnd_generate'));
      await tester.pumpAndSettle();

      final post = harness.http.requests.last;
      expect(post.method, 'POST');
      expect(jsonDecode(post.body), {
        'email': 'nova@lello.com',
        'mobile_phone': '11988887777',
        'phone': '1133334444',
      });
      expect(find.byType(CndErrorDialog), findsOneWidget);
    });

    testWidgets('certidão gerada é gravada em disco e abre o visualizador',
        (tester) async {
      final dir = Directory.systemTemp.createTempSync('cnd_test');
      addTearDown(() => dir.deleteSync(recursive: true));
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
              _pathProviderChannel, (call) async => dir.path);
      addTearDown(() => TestDefaultBinaryMessengerBinding
          .instance.defaultBinaryMessenger
          .setMockMethodCallHandler(_pathProviderChannel, null));
      harness.http.on('POST', _cndPath,
          body: '%PDF-1.4 fake', headers: const {'content-type': 'application/pdf'});

      await pumpPage(tester, const CertificateNoOutstandingDebtPage(),
          settle: false);
      await tester.pump();
      await tester.pump();
      // A gravação do arquivo (`viewFile`) é IO real (abrir, escrever,
      // fechar): cada etapa só completa em runAsync e a continuação seguinte
      // só roda no próximo pump, então alternamos os dois.
      for (var i = 0; i < 8; i++) {
        await tester.runAsync(
            () => Future<void>.delayed(const Duration(milliseconds: 50)));
        await tester.pump();
        await tester.pump();
      }

      final state = controller().bloc.state;
      expect(state, isA<CertificateNoOutstandingDebtSucessState>());
      expect(
        base64Decode((state as CertificateNoOutstandingDebtSucessState).pdf),
        utf8.encode('%PDF-1.4 fake'),
      );
      final pdfs = dir.listSync().where((f) => f.path.endsWith('.pdf'));
      expect(pdfs, hasLength(1));
      expect(pdfs.single.path, contains('/cnd_'));
      expect(File(pdfs.single.path).readAsStringSync(), '%PDF-1.4 fake');
      // O visualizador (PDFScreen) é empurrado por cima da página.
      expect(find.text('Certidão Negativa de Débito'), findsOneWidget);
      // O render nativo do PDF (pdfrx) não existe no ambiente de teste.
      tester.takeException();
    });

    testWidgets('voltar fecha a página', (tester) async {
      mockError();
      await open(tester);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      final popped = navigator.maybePop();
      await tester.pumpAndSettle();

      expect(await popped, isTrue);
      expect(find.byType(CertificateNoOutstandingDebtPage), findsNothing);
      expect(find.byKey(const Key('launcher')), findsOneWidget);
    });
  });

  group('CndErrorDialog', () {
    testWidgets('destaca os trechos entre ** em negrito', (tester) async {
      await pumpApp(
        tester,
        const CndErrorDialog(),
        localized: true,
        surface: const Size(700, 800),
        locOverrides: const {
          ..._locOverrides,
          'cnd_information': 'Ligue **agora** para a **Lello** ok',
        },
      );

      final rich = tester.widget<RichText>(find.byWidgetPredicate(
        (w) => w is RichText && w.text.toPlainText().contains('agora'),
      ));
      final spans = (rich.text as TextSpan).children!.cast<TextSpan>();
      expect(spans.map((s) => s.text),
          ['Ligue ', 'agora', ' para a ', 'Lello', ' ok']);
      expect(spans[1].style?.fontWeight, FontWeight.bold);
      expect(spans[0].style, isNull);
    });
  });

  test('formatadores de telefone do controller', () {
    final c = controller();
    expect(c.landlineFormatted('1132048116'), '(11) 3204-8116');
    expect(c.landlineFormatted(''), isNull);
    // Corrigido: `mobilePhoneFormatted` formata o parâmetro recebido, e não
    // mais o campo `mobilePhone` do controller.
    c.mobilePhone = '11000000000';
    expect(c.mobilePhoneFormatted('11999998888'), '(11) 99999-8888');
    expect(c.mobilePhoneFormatted(''), isNull);
    c.setTextFields(EasyFixUnit.filled());
    expect(c.email, 'teste@gmail.com');
  });
}
