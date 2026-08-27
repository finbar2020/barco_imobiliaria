/// Helpers locais para os widget tests da prestação de contas
/// (`lib/feature/accountability/presentation/**`).
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_features/shared_features.dart' show SharedApplicationRoute;

/// Condomínio da sessão de teste (`testCondominium().id`).
const condominiumId = 'c1';

/// Caminhos da `AccountabilityApi`.
const periodsPath = '/accountabilities/$condominiumId';
String groupedPath(String period) =>
    '/accountabilities/$condominiumId/$period/grouped';

/// Lista de meses no formato do `accountability_month_list`
/// (`mes|Janeiro|...`), gerada com o mesmo `DateFormat('MMMM')` que
/// `AccountabilityPeriods.periodo` usa para montar o texto do dropdown.
String monthList() {
  final months = List.generate(
    12,
    (i) => toBeginningOfSentenceCase(
        DateFormat('MMMM').format(DateTime(2026, i + 1))),
  );
  return ['month', ...months].join('|');
}

/// Nome do mês [month] (1..12) como aparece no dropdown de períodos.
String monthName(int month) =>
    toBeginningOfSentenceCase(DateFormat('MMMM').format(DateTime(2026, month)));

Map<String, dynamic> periodJson(int year, int month, {String? situation}) => {
      'period': DateTime(year, month).toIso8601String(),
      'situation': situation ?? 'aprovado',
      'approval_date': DateTime(year, month, 20).toIso8601String(),
    };

Map<String, dynamic> entryJson(
  int id, {
  double credit = 0,
  double debit = 0,
  String history = 'Lançamento',
}) =>
    {
      'id': id,
      'date': DateTime(2026, 1, id).toIso8601String(),
      'value': credit - debit,
      'signal': credit > 0 ? '+' : '-',
      'credit': credit,
      'debit': debit,
      'history': history,
    };

Map<String, dynamic> groupedJson(
  int id, {
  String description = 'Despesas administrativas',
  double debits = 300,
  double credits = 0,
  List<Map<String, dynamic>>? accounts,
}) =>
    {
      'type': 'D',
      'description': description,
      'id': id,
      'debits': debits,
      'credits': credits,
      'accounts': accounts ??
          [
            {
              'account': 100 + id,
              'description': 'Conta $id',
              'entries': [
                entryJson(1, debit: 200, history: 'Pagamento 1'),
                entryJson(2, debit: 100, history: 'Pagamento 2'),
              ],
            },
          ],
    };

Map<String, dynamic> accountabilityJson({
  double initialBalance = 1000,
  double totalIncome = 500,
  double totalExpenses = -300,
  double balance = 1200,
  List<Map<String, dynamic>>? grouped,
}) =>
    {
      'condominium_id': condominiumId,
      'period': DateTime(2026, 1).toIso8601String(),
      'initial_balance': initialBalance,
      'total_income': totalIncome,
      'total_expenses': totalExpenses,
      'balance': balance,
      'accounts': <Map<String, dynamic>>[],
      'summary': <Map<String, dynamic>>[],
      'grouped_entries': grouped ??
          [
            groupedJson(1),
            groupedJson(2,
                description: 'Receitas', debits: 0, credits: 500, accounts: [
              {
                'account': 200,
                'description': 'Taxa condominial',
                'entries': [entryJson(3, credit: 500, history: 'Recebimento')],
              }
            ]),
          ],
    };

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
