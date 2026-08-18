import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account.dart';
import 'package:lello/feature/accountability/domain/entity/accountability_grouped_account_entrie.dart';
import 'package:lello/feature/accountability/presentation/detail/page/accountability_details_grouped_entries_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_error_page.dart';
import 'package:lello/feature/accountability/presentation/question_create/page/question_create_success_page.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — pergunta criada com sucesso', (tester) async {
    await pumpApp(
      tester,
      QuestionCreateSuccessPage(),
      wrapInScaffold: false,
      surface: const Size(400, 640),
      localized: true,
      locOverrides: const {
        'accounttability_question_success_title': 'Pergunta enviada',
        'accounttability_question_success_subtitle':
            'A administradora receberá o seu questionamento.',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/question_create_success.png'),
    );
  });

  testWidgets('golden — erro ao criar pergunta', (tester) async {
    await pumpApp(
      tester,
      QuestionCreateErrorPage(),
      wrapInScaffold: false,
      surface: const Size(400, 640),
      localized: true,
      locOverrides: const {
        'accounttability_question_error_title': 'Não foi possível enviar',
        'accounttability_question_error_subtitle':
            'Tente novamente em instantes.',
        'accounttability_question_error_edit': 'Editar',
        'cancel': 'Cancelar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/question_create_error.png'),
    );
  });

  testWidgets('golden — lançamentos agrupados da prestação', (tester) async {
    final entity = AccountabilityGrouped(
      type: 'DESPESA',
      description: 'Manutenção predial',
      id: 1,
      debits: 200,
      credits: 50,
      accounts: [
        AccountabilityGroupedAccount(
          account: 101,
          description: 'Limpeza',
          entries: [
            AccountabilityGroupedAccaountEntrie(
              id: 1,
              date: DateTime(2026, 1, 15),
              value: 200,
              signal: 'D',
              credit: 0,
              debit: 200,
              history: 'Faxina do hall',
            ),
            AccountabilityGroupedAccaountEntrie(
              id: 2,
              date: DateTime(2026, 1, 20),
              value: 50,
              signal: 'C',
              credit: 50,
              debit: 0,
              history: 'Estorno parcial',
            ),
          ],
        ),
      ],
    );

    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: RouteSettings(
            arguments: AccountabilityDetailGroupedArguments(entity),
          ),
          builder: (_) => AccountabilityDetailsGroupedEntriesPage(),
        ),
      ),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'accountability_title': 'Prestação de contas',
        'condominium_balance_detail_name': 'Detalhe',
        'accountability_history_debit': 'Débito',
        'accountability_history_credit': 'Crédito',
        'accountability_total_expenses': 'Despesas',
        'accountability_total_income': 'Receitas',
        'accountability_history_account': 'Conta',
        'accountability_history_date': 'Data',
        'accountability_history_description': 'Histórico',
      },
      surface: const Size(400, 800),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/accountability_grouped_entries.png'),
    );
  });
}
