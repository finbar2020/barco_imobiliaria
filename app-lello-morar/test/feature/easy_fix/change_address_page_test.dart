import 'dart:convert';

import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/easy_fix/domain/entity/city_entity.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/bloc/change_address_state.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/controllers/change_address_controller.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/pages/change_address_failure_page.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/pages/change_address_page.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/pages/change_address_success_page.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/pages/update_unit_data_page.dart';
import 'package:morar/feature/easy_fix/presentation/change_address/widgets/change_address_form.dart';

import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';
import 'fake_via_cep.dart';

const _unitPath = '/condominiums/c1/easyfix/unit-contact';
const _updatePath = '/condominiums/c1/easyfix/unit-contact/update';
const _citiesPath = '/condominiums/c1/easyfix/cities';
const _inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');

const _saoPaulo = {'ibge_code': 3550308, 'name': 'SAO PAULO'};
const _campinas = {'ibge_code': 3509502, 'name': 'CAMPINAS'};
const _rio = {'ibge_code': 3304557, 'name': 'RIO DE JANEIRO'};

Map<String, dynamic> _unit({
  String? state = 'SP',
  bool withCity = true,
  String? complement = 'ap 1',
}) =>
    {
      'name': 'Ana Silva',
      'cpf_cnpj': '12345678901',
      'email': 'ana@lello.com',
      'cellphone': '11999998888',
      'phone': '1132048116',
      'cep': '01001-000',
      'address': 'Praça da Sé',
      'address_number': '1',
      'address_complement': complement,
      'address_neighborhood': 'Sé',
      'address_state': state,
      'address_city': withCity ? _saoPaulo : null,
    };

/// Tela inicial que empurra [route] por cima, para testar `pop`s.
class _Launcher extends StatelessWidget {
  const _Launcher(this.route);
  final String route;

  @override
  Widget build(BuildContext context) => Scaffold(
        key: const Key('launcher'),
        body: Center(
          child: TextButton(
            onPressed: () => Navigator.pushNamed(context, route),
            child: const Text('abrir'),
          ),
        ),
      );
}

void main() {
  late PageHarness harness;
  late RecordingNavigatorObserver observer;
  late FakeViaCep viaCep;

  final routes = <String, WidgetBuilder>{
    ApplicationRoute.changeAddress: (_) => const ChangeAddressPage(),
    ApplicationRoute.changeAddressSuccess: (_) => ChangeAddressSuccessPage(),
    ApplicationRoute.changeAddressFailure: (_) => ChangeAddressFailurePage(),
  };
  const locOverrides = {'validation_invalid_length': 'precisa de %s'};

  setUp(() async {
    harness = await installPageHarness();
    observer = RecordingNavigatorObserver();
    viaCep = FakeViaCep();
    // `getStates()` usa `rootBundle.loadString`, que cacheia o Future criado
    // na zona FakeAsync do teste anterior; sem limpar, o `await` seguinte
    // agenda a continuação numa zona morta e a página nunca carrega.
    rootBundle.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, (call) async => false);
    harness.http.on('GET', _unitPath, body: _unit());
    harness.http.on('GET', _citiesPath, body: [_saoPaulo, _campinas]);
    harness.http.on('PUT', _updatePath, body: {});
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(_inAppReviewChannel, null);
  });

  ChangeAddressController controller() =>
      harness.resolve<ChangeAddressController>();

  Finder field(int index) => find.byType(TextFormField).at(index);

  /// Monta a página inteira numa superfície alta (o formulário é longo).
  Future<void> pumpChangeAddress(WidgetTester tester) => viaCep.run(
        () => pumpPage(
          tester,
          const ChangeAddressPage(),
          observer: observer,
          routes: routes,
          surface: const Size(400, 1500),
          locOverrides: locOverrides,
        ),
      );

  /// Abre [route] a partir de uma tela base, para observar os `pop`s.
  Future<void> open(WidgetTester tester, String route) async {
    await viaCep.run(() => pumpPage(
          tester,
          _Launcher(route),
          observer: observer,
          routes: routes,
          surface: const Size(400, 1500),
          locOverrides: locOverrides,
        ));
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  Iterable<String> requested() =>
      harness.http.requests.map((r) => '${r.method} ${r.url.path}');

  group('ChangeAddressPage', () {
    testWidgets('carrega a unidade e preenche o formulário', (tester) async {
      await pumpChangeAddress(tester);

      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      expect(find.text('update_unit_data_title'), findsOneWidget);
      expect(find.byType(ChangeAddressForm), findsOneWidget);
      expect(find.text('ana@lello.com'), findsOneWidget);
      expect(find.text('(11) 99999-8888'), findsOneWidget);
      expect(find.text('01001-000'), findsOneWidget);
      expect(find.text('Praça da Sé'), findsOneWidget);
      expect(find.text('SAO PAULO'), findsOneWidget);
      expect(requested(), ['GET $_unitPath', 'GET $_citiesPath']);
      expect(controller().states, contains('SP'));
      expect(controller().cities.map((c) => c.name), ['SAO PAULO', 'CAMPINAS']);
      await expectLater(
        find.byType(ChangeAddressPage),
        matchesGoldenFile('goldens/change_address_page.png'),
      );
    });

    testWidgets('estados inicial e de loading', (tester) async {
      await pumpChangeAddress(tester);
      final bloc = controller().bloc;

      await emitState(tester, bloc, const ChangeAddressInitialState());
      expect(find.byType(ChangeAddressForm), findsNothing);
      expect(find.byType(ErrorHandlingWidget), findsNothing);

      await emitState(tester, bloc, const ChangeAddressLoadingState(),
          settle: false);
      await tester.pump();
      expect(find.text('please_wait'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('validação impede salvar com dados inválidos', (tester) async {
      await pumpChangeAddress(tester);

      await tester.enterText(field(0), '');
      await tester.enterText(field(1), '(11) 9');
      await tester.enterText(field(2), '123');
      await tester.enterText(field(3), '');
      await tester.enterText(field(4), '');
      await tester.enterText(field(6), '');
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(find.text('validation_required'), findsNWidgets(4));
      expect(find.text('validation_invalid_phone'), findsOneWidget);
      expect(find.text('precisa de 9'), findsOneWidget);
      expect(requested(), isNot(contains('PUT $_updatePath')));

      await tester.enterText(field(0), 'invalido');
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();
      expect(find.text('validation_invalid_email'), findsOneWidget);
    });

    testWidgets('salvar envia os dados e abre a tela de sucesso',
        (tester) async {
      await pumpChangeAddress(tester);

      await tester.enterText(field(0), 'nova@lello.com');
      await tester.enterText(field(1), '(21) 98888-7777');
      await tester.enterText(field(4), '42');
      await tester.enterText(field(5), 'fundos');
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      final put = harness.http.requests.singleWhere((r) => r.method == 'PUT');
      final body = jsonDecode(put.body) as Map<String, dynamic>;
      expect(body['email'], 'nova@lello.com');
      expect(body['cellphone'], '21988887777');
      expect(body['address_number'], '42');
      expect(body['address_complement'], 'fundos');
      expect(body['address_city'], _saoPaulo);
      expect(body['name'], 'Ana Silva');
      expect(controller().bloc.state, isA<ChangeAddressSuccessState>());
      expect(observer.pushedNames.last, ApplicationRoute.changeAddressSuccess);
      expect(find.text('change_address_success_page_title'), findsOneWidget);
      expect(find.text('Edifício Lello - 101'), findsOneWidget);
      await expectLater(
        find.byType(ChangeAddressSuccessPage),
        matchesGoldenFile('goldens/change_address_success_page.png'),
      );

      // "Concluir" recarrega a unidade e volta para o formulário.
      await tester.tap(find.text('conclude'));
      await tester.pumpAndSettle();
      expect(find.byType(ChangeAddressSuccessPage), findsNothing);
      expect(find.byType(ChangeAddressForm), findsOneWidget);
      expect(requested().where((r) => r == 'GET $_unitPath'), hasLength(2));
    });

    testWidgets('voltar na tela de sucesso pede avaliação do app e fecha',
        (tester) async {
      await pumpChangeAddress(tester);
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();
      expect(find.byType(ChangeAddressSuccessPage), findsOneWidget);

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      final popped = navigator.maybePop();
      await tester.pumpAndSettle();

      expect(await popped, isTrue);
      expect(find.byType(ChangeAddressSuccessPage), findsNothing);
      expect(find.byType(ChangeAddressPage), findsOneWidget);
    });

    testWidgets('falha ao salvar abre a tela de falha; tentar de novo salva',
        (tester) async {
      await pumpChangeAddress(tester);
      harness.http.on('PUT', _updatePath, status: 500, body: {'message': 'x'});

      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      expect(controller().bloc.state, isA<ChangeAddressFailureState>());
      expect(observer.pushedNames.last, ApplicationRoute.changeAddressFailure);
      expect(find.text('error_unknown'), findsOneWidget);
      await expectLater(
        find.byType(ChangeAddressFailurePage),
        matchesGoldenFile('goldens/change_address_failure_page.png'),
      );

      harness.http.on('PUT', _updatePath, body: {});
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(find.byType(ChangeAddressFailurePage), findsNothing);
      expect(observer.pushedNames.last, ApplicationRoute.changeAddressSuccess);
      expect(find.byType(ChangeAddressSuccessPage), findsOneWidget);
      expect(requested().where((r) => r == 'PUT $_updatePath'), hasLength(2));
    });

    testWidgets('cancelar na tela de falha volta para o erro do formulário',
        (tester) async {
      await pumpChangeAddress(tester);
      harness.http.on('PUT', _updatePath, status: 500, body: {'message': 'x'});
      await tester.tap(find.text('save'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(ChangeAddressFailurePage), findsNothing);
      // Por baixo, o formulário mostra o ErrorHandlingWidget do estado de falha.
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
      await tester.tap(find.text('error_handling_widget_button_reTry').first);
      await tester.pumpAndSettle();
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);
    });

    testWidgets('falha ao carregar: voltar do erro e da tela de falha',
        (tester) async {
      harness.http.on('GET', _unitPath, status: 500, body: {'message': 'x'});
      await open(tester, ApplicationRoute.changeAddress);

      expect(find.byType(ChangeAddressFailurePage), findsOneWidget);
      expect(requested(), ['GET $_unitPath']);

      /// Corrigido: com a unidade nula (falha no carregamento) "tentar
      /// novamente" recarrega a unidade em vez de montar `updatedUnit`
      /// (que faz `unit!`). Como a API continua falhando, a tela de falha
      /// é reaberta.
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(requested(), ['GET $_unitPath', 'GET $_unitPath']);
      expect(find.byType(ChangeAddressFailurePage), findsOneWidget);

      // O voltar do sistema fecha a tela de falha (o WillPopScope faz o pop).
      final navigator = tester.state<NavigatorState>(find.byType(Navigator));
      navigator.maybePop();
      await tester.pumpAndSettle();
      expect(find.byType(ChangeAddressFailurePage), findsNothing);
      expect(find.byType(ErrorHandlingWidget), findsOneWidget);

      // "Voltar" do widget de erro fecha o formulário.
      await tester.tap(find.text('error_handling_widget_button_back').first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('launcher')), findsOneWidget);
    });

    testWidgets('falha ao carregar: tentar novamente com a API de volta',
        (tester) async {
      harness.http.on('GET', _unitPath, status: 500, body: {'message': 'x'});
      await open(tester, ApplicationRoute.changeAddress);
      expect(find.byType(ChangeAddressFailurePage), findsOneWidget);

      harness.http.on('GET', _unitPath, body: _unit());
      await tester.tap(find.text('try_again'));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.byType(ChangeAddressFailurePage), findsNothing);
      expect(find.byType(ChangeAddressForm), findsOneWidget);
      expect(find.text('Praça da Sé'), findsOneWidget);
      expect(requested(), ['GET $_unitPath', 'GET $_unitPath', 'GET $_citiesPath']);
    });

    testWidgets('trocar o estado recarrega as cidades e seleciona a primeira',
        (tester) async {
      await pumpChangeAddress(tester);
      harness.http.on('GET', _citiesPath, body: [_rio]);

      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('RJ').last);
      await tester.pumpAndSettle();

      expect(controller().addressStateController.text, 'RJ');
      expect(controller().addressCity, City(ibgeCode: 3304557, name: 'RIO DE JANEIRO'));
      expect(find.text('RIO DE JANEIRO'), findsOneWidget);
      final cities = harness.http.requests.last;
      expect(cities.url.path, _citiesPath);
      expect(cities.url.queryParameters['uf'], 'RJ');
    });

    testWidgets('trocar a cidade atualiza o controller', (tester) async {
      await pumpChangeAddress(tester);

      await tester.tap(find.byType(DropdownButtonFormField<City>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CAMPINAS').last);
      await tester.pumpAndSettle();

      expect(controller().addressCity, City(ibgeCode: 3509502, name: 'CAMPINAS'));
      expect(controller().updatedUnit.addressCity?.name, 'CAMPINAS');
    });

    testWidgets('CEP preenchido busca o endereço no ViaCEP', (tester) async {
      await pumpChangeAddress(tester);
      await tester.enterText(field(4), '999');

      await viaCep.run(() async {
        await tester.enterText(field(2), '01001-000');
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.pumpAndSettle();
      });

      expect(viaCep.requests.single, contains('/ws/01001000/json'));
      final c = controller();
      expect(c.cep, '01001-000');
      expect(c.addressController.text, 'Praça da Sé');
      expect(c.addressNumberController.text, '');
      expect(c.addressComplementController.text, 'lado ímpar');
      expect(c.addressNeighborhoodController.text, 'Sé');
      expect(c.addressStateController.text, 'SP');
      expect(c.addressCity?.name, 'SAO PAULO');
      expect(find.text('lado ímpar'), findsOneWidget);

      // CEP inexistente não altera nada.
      await tester.enterText(field(4), '77');
      await viaCep.run(() async {
        await tester.enterText(field(2), '99999-999');
        await tester.testTextInput.receiveAction(TextInputAction.next);
        await tester.pumpAndSettle();
      });
      expect(viaCep.requests, hasLength(2));
      expect(c.addressNumberController.text, '77');

      // `onSaved` do CEP também consulta o ViaCEP.
      await viaCep.run(() async {
        tester.state<FormState>(find.byType(Form)).save();
        await tester.pumpAndSettle();
      });
      expect(viaCep.requests, hasLength(3));
    });

    testWidgets('unidade sem estado mostra o dropdown de UF vazio',
        (tester) async {
      harness.http.on('GET', _unitPath, body: _unit(state: null, withCity: false));
      await pumpChangeAddress(tester);

      /// Corrigido: com `address_state` nulo o `DropdownButtonFormField<String>`
      /// recebe `value: null` (antes recebia `''`, que não está entre os
      /// itens, e a asserção do DropdownButton estourava no build).
      expect(tester.takeException(), isNull);
      expect(find.byType(ChangeAddressForm), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<String>), findsOneWidget);
      expect(requested(), isNot(contains('GET $_citiesPath')));
      expect(controller().updatedUnit.addressState, '');

      // Escolher uma UF passa a funcionar normalmente.
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('SP').last);
      await tester.pumpAndSettle();
      expect(controller().addressStateController.text, 'SP');
      expect(harness.http.requests.last.url.queryParameters['uf'], 'SP');
      expect(controller().addressCity?.name, 'SAO PAULO');
    });
  });

  group('UpdateUnitDataPage', () {
    testWidgets('mostra o aviso e vai para a troca de endereço',
        (tester) async {
      await pumpPage(tester, const UpdateUnitDataPage(), observer: observer);

      expect(find.text('update_unit_data_title'), findsOneWidget);
      expect(find.text('attention!'), findsOneWidget);
      expect(find.text('update_unit_data_warning'), findsOneWidget);
      await expectLater(
        find.byType(UpdateUnitDataPage),
        matchesGoldenFile('goldens/update_unit_data_page.png'),
      );

      await tester.tap(find.text('update_unit_data_primary_button'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.changeAddress);
      expect(findRoute(ApplicationRoute.changeAddress), findsOneWidget);
      expect(find.byType(UpdateUnitDataPage), findsNothing);
    });

    testWidgets('botão secundário vai para as preferências papel zero',
        (tester) async {
      await pumpPage(tester, const UpdateUnitDataPage(), observer: observer);

      await tester.tap(find.text('update_unit_data_secondary_button'));
      await tester.pumpAndSettle();

      expect(observer.pushedNames.last, ApplicationRoute.preferencesZeroPaper);
      expect(findRoute(ApplicationRoute.preferencesZeroPaper), findsOneWidget);
    });
  });
}
