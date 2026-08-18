import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_installment_status.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_quote.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/agreements_scale_bar.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/agreements_status_changed_success_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_alert_dialog.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_max_installments_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_payment_days_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_introduction_details_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_month_year.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_option.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_payment_details.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_quote_details.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — barra de escala de acordos', (tester) async {
    await pumpApp(
      tester,
      const AgreementsScaleBar(color: Color(0xFFC20332), value: 65),
      shrinkWrap: false,
      surface: const Size(400, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_scale_bar.png'),
    );
  });

  testWidgets('golden — detalhes da cota do acordo', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return AgreementsQuoteDetails(
            theme: Theme.of(context),
            index: 1,
            quote: AgreementQuote(
              dueDate: DateTime(2026, 8, 10),
              originValue: 400,
              fineValue: 20,
              feeValue: 10,
            ),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'agreements_quote': 'Cota',
        'agreements_original_value': 'Valor original',
        'agreements_fines_charges': 'Multas e encargos',
        'agreements_total_value': 'Valor total',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_quote_details.png'),
    );
  });

  testWidgets('golden — cartão de introdução do acordo', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return IntroductionDetailsCard(
            theme: Theme.of(context),
            agreement: Agreement(
              unit: '101',
              unitOwner: 'Maria Silva',
              status: AgreementStatus.pending,
              proposaldedDate: DateTime(2026, 7, 1),
              baseValue: 1200,
              fineAndCosts: 80,
              installmentQuantity: 4,
              paymentMethod: PaymentMethod.billet,
              dueDate: 10,
            ),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'agreements_proposal_made_in': 'Proposta em',
        'agreements_agreement_total_value': 'Valor total',
        'agreements_payment_method': 'Forma de pagamento',
        'agreements_billet': 'Boleto',
        'agreements_expiration_date': 'Vencimento',
        'agreements_introduction_details_card_day': 'Dia',
        'agreements_installments': 'Parcelas',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_introduction_card.png'),
    );
  });

  testWidgets('golden — cartão de introdução aprovado', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return IntroductionDetailsCard(
            theme: Theme.of(context),
            agreement: Agreement(
              unit: '202',
              unitOwner: 'João Lima',
              status: AgreementStatus.approvedByManager,
              approvalDate: DateTime(2026, 7, 15),
              baseValue: 800,
              fineAndCosts: 40,
              installmentQuantity: 2,
              paymentMethod: PaymentMethod.billet,
              dueDate: 5,
            ),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'agreements_agreement_made_in': 'Acordo em',
        'agreements_agreement_total_value': 'Valor total',
        'agreements_payment_method': 'Forma de pagamento',
        'agreements_billet': 'Boleto',
        'agreements_expiration_date': 'Vencimento',
        'agreements_introduction_details_card_day': 'Dia',
        'agreements_installments': 'Parcelas',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_introduction_approved.png'),
    );
  });

  testWidgets('golden — cartão da lista de acordos', (tester) async {
    await pumpApp(
      tester,
      AgreementsCard(
        onPressed: () {},
        agreement: Agreement(
          unit: '101',
          unitOwner: 'Maria Silva',
          status: AgreementStatus.pending,
          proposaldedDate: DateTime(2026, 7, 1),
          baseValue: 1200,
          fineAndCosts: 80,
          paymentMethod: PaymentMethod.billet,
        ),
      ),
      localized: true,
      locOverrides: const {
        'agreements_payment': 'Pagamento',
        'agreements_billet': 'Boleto',
        'agreements_value_with_fine': 'Valor com multa',
        'agreements_proposal_made_in': 'Proposta em',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_card.png'),
    );
  });

  testWidgets('golden — opção do menu de acordos', (tester) async {
    await pumpApp(
      tester,
      AgreementsOption(
        iconKey: 'assets/ic_agreements_analysis.svg',
        titleKey: 'agreements_analysis',
        optionIndex: 3,
        onTap: () {},
      ),
      localized: true,
      locOverrides: const {'agreements_analysis': 'Análise'},
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_option.png'),
    );
  });

  testWidgets('golden — agrupamento por mês', (tester) async {
    await pumpApp(
      tester,
      AgreementsMonthYear(
        index: 0,
        agreements: [
          Agreement(proposaldedDate: DateTime(2026, 8, 1)),
        ],
      ),
      localized: true,
      locOverrides: const {'august': 'agosto'},
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_month_year.png'),
    );
  });

  testWidgets('golden — detalhes das parcelas', (tester) async {
    await pumpApp(
      tester,
      PaymentDetailsCard(
        installments: [
          AgreementInstallment(
            value: 320,
            status: AgreementInstallmentsStatus.paid,
          ),
          AgreementInstallment(
            value: 320,
            status: AgreementInstallmentsStatus.pending,
          ),
        ],
      ),
      localized: true,
      locOverrides: const {
        'agreements_payments': 'Pagamentos',
        'agreements_installment': 'Parcela',
        'agreements_installment_paid': 'Paga',
        'agreements_installment_pendency': 'Pendente',
      },
      shrinkWrap: false,
      surface: const Size(400, 200),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_payment_details.png'),
    );
  });

  testWidgets('golden — cartão de acordo concluído', (tester) async {
    await pumpApp(
      tester,
      AgreementsCard(
        onPressed: () {},
        agreement: Agreement(
          unit: '303',
          unitOwner: 'Carlos Lima',
          status: AgreementStatus.completed,
          approvalDate: DateTime(2026, 6, 15),
          baseValue: 800,
          paymentMethod: PaymentMethod.credit,
        ),
      ),
      localized: true,
      locOverrides: const {
        'agreements_payment': 'Pagamento',
        'agreements_credit_card': 'Cartão',
        'agreements_value_with_fine': 'Valor com multa',
        'agreements_date': 'Acordo em',
        'agreements_completed': 'Concluído',
      },
      shrinkWrap: false,
      surface: const Size(400, 320),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_card_completed.png'),
    );
  });

  testWidgets('golden — agrupamento por mês com divisor', (tester) async {
    await pumpApp(
      tester,
      AgreementsMonthYear(
        index: 1,
        agreements: [
          Agreement(proposaldedDate: DateTime(2026, 7, 1)),
          Agreement(proposaldedDate: DateTime(2026, 8, 1)),
        ],
      ),
      localized: true,
      locOverrides: const {
        'july': 'julho',
        'august': 'agosto',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_month_year_divider.png'),
    );
  });

  testWidgets('golden — alerta das regras de acordo', (tester) async {
    await pumpApp(
      tester,
      const AgreementsAlertDialog(),
      localized: true,
      locOverrides: const {
        'agreements_rules_dialog_title': 'Atenção',
        'agreements_rules_dialog_text': 'Dias após o dia 28 podem variar.',
        'agreements_rules_dialog_confirmation': 'Entendi',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_alert_dialog.png'),
    );
  });

  testWidgets('golden — alterar dias de pagamento', (tester) async {
    await pumpApp(
      tester,
      AgreementsPaymentDaysBottomSheet(
        rules: AgreementsRules(installmentQtd: 3, days: [5, 10]),
        onPressed: (_) {},
      ),
      localized: true,
      locOverrides: const {
        'agreements_rules_change_payment_dates': 'Dias de pagamento',
        'agreements_rules_change_payment_dates_details':
            'Escolha até 5 dias do mês.',
        'agreements_rules_change': 'Alterar',
      },
      shrinkWrap: false,
      surface: const Size(400, 520),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_payment_days.png'),
    );
  });

  testWidgets('golden — alterar máximo de parcelas', (tester) async {
    await pumpApp(
      tester,
      AgreementsMaxInstallmentsBottomSheet(
        minValue: 1,
        maxValue: 3,
        rules: AgreementsRules(installmentQtd: 2, days: [5]),
        onPressed: (_) {},
      ),
      localized: true,
      locOverrides: const {
        'agreements_rules_accept_more_installments': 'Máximo de parcelas',
        'agreements_rules_accept_more_installments_details':
            'Defina o limite aceito.',
        'agreements_rules_change': 'Alterar',
      },
      shrinkWrap: false,
      surface: const Size(400, 360),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_max_installments.png'),
    );
  });

  testWidgets('golden — proposta aprovada', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: const RouteSettings(arguments: [true]),
          builder: (_) => const AgreementsStatusChangedSuccessPage(),
        ),
      ),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'agreements_proposals_agreement_approved': 'Acordo aprovado',
        'agreements_proposals_success_message': 'A proposta foi atualizada.',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_status_approved.png'),
    );
  });

  testWidgets('golden — proposta reprovada', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: const RouteSettings(arguments: [false]),
          builder: (_) => const AgreementsStatusChangedSuccessPage(),
        ),
      ),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'agreements_proposals_agreement_disapproved': 'Acordo reprovado',
        'agreements_proposals_success_message': 'A proposta foi atualizada.',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/agreements_status_disapproved.png'),
    );
  });
}
