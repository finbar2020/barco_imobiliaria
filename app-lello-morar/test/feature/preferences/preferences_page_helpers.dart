/// Helpers locais para os widget tests das preferências
/// (`lib/feature/preferences/presentation/**`): caminhos/JSON da
/// `PreferencesApi`, chaves do SharedPreferences dos cards da home, um
/// `HomeBloc` falso e o empilhador de rotas.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

/// Caminhos da `PreferencesApi`.
const zeroPaperPath = '/me/preferences/zero-paper';
const notificationPath = '/me/preferences/notification';

/// CPF do usuário da sessão de teste (`testMe().cpf`), usado nas chaves do
/// SharedPreferences dos cards da home.
const testCpf = '12345678901';
const favoritesKey = 'PREFERENCES_HOME_CARDS$testCpf';
const onboardingKey = 'PREFERENCES_HOME_CARDS_ONBOARDING$testCpf';

Map<String, dynamic> zeroPaperJson({
  String? announcements = 'digital',
  String? acts = 'printed',
  String? slips = 'printed_digital',
  String? statements,
  bool allUnits = false,
}) =>
    {
      'delivery_announcements': announcements,
      'delivery_acts': acts,
      'delivery_slips': slips,
      'delivery_statements': statements,
      'all_units': allUnits,
    };

Map<String, dynamic> notificationJson(String? module, {bool active = true}) =>
    {'active': active, 'module': module};

/// HomeBloc falso: o real dispara a busca de banners na construção e é
/// resolvido pela tela de cards só para `getCards()` após salvar.
class FakeHomeBloc extends Fake implements HomeBloc {
  int getCardsCalls = 0;

  @override
  void getCards() {
    getCardsCalls++;
  }

  @override
  Future<void> close() async {}
}

/// Empilha uma rota `/home` e depois [route] (com [arguments]) sobre a
/// página raiz do `pumpPage`, para que `Navigator.pop`/`popUntil(home)`
/// tenham para onde voltar.
class RouteLauncher extends StatefulWidget {
  const RouteLauncher({required this.route, this.arguments, super.key});

  final String route;
  final Object? arguments;

  @override
  State<RouteLauncher> createState() => _RouteLauncherState();
}

class _RouteLauncherState extends State<RouteLauncher> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigator = Navigator.of(context);
      navigator.pushNamed(SharedApplicationRoute.home);
      navigator.pushNamed(widget.route, arguments: widget.arguments);
    });
  }

  @override
  Widget build(BuildContext context) =>
      const Scaffold(key: Key('launcher'), body: SizedBox());
}
