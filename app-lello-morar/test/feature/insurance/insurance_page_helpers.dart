/// Helpers locais dos widget tests da feature `insurance`: JSON da API,
/// tabela de prêmios, tela base para empilhar a `InsurancePage` (voltar),
/// sessão falsa com remote config e mocks de clipboard/path_provider.
import 'dart:io';

import 'package:essentials/essentials.dart' show FirebaseRemoteConfig;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_premium_value_model.dart';
import 'package:morar/feature/insurance/data/model/insurance_table_model.dart';
import 'package:morar/feature/insurance/presentation/pages/insurance_page.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/page_harness.dart';
import '../../helpers/pump_app.dart';

/// `unitId` da sessão de teste (`testUnity().id`).
const insurancePath = '/insurance/u1';

const insuranceTelefone = '0800-123-4567';
const insuranceAssistencia = '(11) 4004-0000';

Map<String, dynamic> insuranceJson({
  String status = 'hired',
  double cost = 10,
  String? termo = 'https://termos.lello/termos.pdf',
}) =>
    {
      'insurance_status': status,
      'insurance_data': {
        'name': 'Casa Protegida',
        'cost': cost,
        'id_unit': 'u1',
        'id_insurance': 'i1',
        'flag_join': 'S',
      },
      'insurance_info': {
        'id_produto_compl': 'pc',
        'id_produto': 'p',
        'saiba_mais': 'https://saiba.mais',
        'ativo': true,
        'termo_de_uso': termo,
      },
    };

InsurancePremiumValueModel _value(String id, String valor) =>
    InsurancePremiumValueModel(idTitulo: id, valor: valor);

/// Tabela com três planos: custo mínimo 10, intermediário 20 e máximo 30.
InsuranceTableModel insuranceTable() => InsuranceTableModel(
      telefone: insuranceTelefone,
      assistencia: insuranceAssistencia,
      premio: [
        InsurancePremiumModel(custo: 10, valores: [
          _value('t1', 'R\$ 5.000'),
          _value('t2', 'R\$ 2.000'),
          _value('t3', 'R\$ 1.000'),
        ]),
        InsurancePremiumModel(custo: 20, valores: [
          _value('t1', 'R\$ 10.000'),
          _value('t2', 'R\$ 4.000'),
        ]),
        InsurancePremiumModel(custo: 30, valores: [
          _value('t1', 'R\$ 20.000'),
        ]),
      ],
      titulos: {'t1': 'Incêndio', 't2': 'Roubo'},
    );

/// Rota em que a `InsurancePage` é empilhada sobre a [InsuranceLauncher].
const insuranceRoute = '/seguro-sob-teste';
const openInsuranceKey = Key('abrir-seguro');
const insuranceBaseKey = Key('tela-base-seguro');

class InsuranceLauncher extends StatelessWidget {
  const InsuranceLauncher({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        key: insuranceBaseKey,
        body: Center(
          child: ElevatedButton(
            key: openInsuranceKey,
            onPressed: () => Navigator.pushNamed(context, insuranceRoute),
            child: const Text('abrir seguro'),
          ),
        ),
      );
}

/// Monta a tela base e empurra a `InsurancePage`.
Future<void> pumpInsurance(
  WidgetTester tester, {
  RecordingNavigatorObserver? observer,
  Map<String, WidgetBuilder> routes = const {},
  bool settle = true,
  Size surface = const Size(400, 800),
}) async {
  await pumpPage(
    tester,
    const InsuranceLauncher(),
    observer: observer,
    surface: surface,
    routes: {insuranceRoute: (_) => const InsurancePage(), ...routes},
  );
  await tester.tap(find.byKey(openInsuranceKey));
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Sessão falsa que expõe o `FirebaseRemoteConfig` (falso) do harness, para
/// cobrir a leitura dos links de termos no `InsuranceController`.
class SessionWithRemoteConfig extends FakeSessionBloc {
  SessionWithRemoteConfig({super.insuranceTable});

  @override
  FirebaseRemoteConfig? get getRemoteConfig => FirebaseRemoteConfig.instance;
}

/// Faz `Clipboard.setData` (e demais métodos de `SystemChannels.platform`)
/// responderem sem erro; devolve as chamadas feitas.
List<MethodCall> mockPlatformChannel() {
  final calls = <MethodCall>[];
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, (call) async {
    calls.add(call);
    return null;
  });
  addTearDown(() => TestDefaultBinaryMessengerBinding
      .instance.defaultBinaryMessenger
      .setMockMethodCallHandler(SystemChannels.platform, null));
  return calls;
}

/// Textos copiados para a área de transferência.
Iterable<String> copiedTexts(List<MethodCall> calls) => calls
    .where((c) => c.method == 'Clipboard.setData')
    .map((c) => (c.arguments as Map)['text'] as String);

class FakePathProvider extends PathProviderPlatform {
  FakePathProvider(this.dir);
  final Directory dir;

  @override
  Future<String?> getApplicationDocumentsPath() async => dir.path;

  @override
  Future<String?> getTemporaryPath() async => dir.path;

  @override
  Future<String?> getApplicationSupportPath() async => dir.path;
}

Directory installFakePathProvider() {
  final previous = PathProviderPlatform.instance;
  final dir = Directory.systemTemp.createTempSync('morar_insurance');
  PathProviderPlatform.instance = FakePathProvider(dir);
  addTearDown(() {
    PathProviderPlatform.instance = previous;
    dir.deleteSync(recursive: true);
  });
  return dir;
}
