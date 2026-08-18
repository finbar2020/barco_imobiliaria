import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/agreements/domain/entity/agreement.dart';
import 'package:lello/feature/agreements/domain/entity/agreement_status.dart';
import 'package:lello/feature/agreements/domain/entity/payment_method.dart';
import 'package:lello/feature/agreements/domain/entity/agreements_rules.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_analysis/widgets/agreements_scale_bar.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_alert_dialog.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_max_installments_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_rules/widgets/agreements_payment_days_bottom_sheet.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_card.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_option.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('barra de escala mostra o percentual', (tester) async {
    await pumpApp(
      tester,
      const AgreementsScaleBar(color: Color(0xFFC20332), value: 40),
      shrinkWrap: false,
      surface: const Size(400, 80),
    );
    expect(find.text('40%'), findsOneWidget);
  });

  testWidgets('toca o cartão do acordo', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      AgreementsCard(
        onPressed: () => tapped = true,
        agreement: Agreement(
          unit: '202',
          unitOwner: 'Ana',
          status: AgreementStatus.pending,
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

    await tester.tap(find.textContaining('202'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('toca a opção do menu de acordos', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      AgreementsOption(
        iconKey: 'assets/ic_agreements_analysis.svg',
        titleKey: 'agreements_analysis',
        optionIndex: 1,
        onTap: () => tapped = true,
      ),
      localized: true,
      locOverrides: const {'agreements_analysis': 'Análise'},
      shrinkWrap: false,
      surface: const Size(400, 240),
    );

    await tester.tap(find.text('Análise'));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('fecha o alerta das regras', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => const AgreementsAlertDialog(),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'agreements_rules_dialog_title': 'Atenção',
        'agreements_rules_dialog_text': 'Dias após o dia 28 podem variar.',
        'agreements_rules_dialog_confirmation': 'Entendi',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('ENTENDI'));
    await tester.pumpAndSettle();
    expect(find.text('Atenção!'), findsNothing);
  });

  testWidgets('alterna dias de pagamento e confirma', (tester) async {
    final rules = AgreementsRules(installmentQtd: 3, days: [5]);
    await pumpApp(
      tester,
      AgreementsPaymentDaysBottomSheet(
        rules: rules,
        onPressed: (_) {},
      ),
      localized: true,
      locOverrides: const {
        'agreements_rules_change_payment_dates': 'Dias de pagamento',
        'agreements_rules_change_payment_dates_details':
            'Escolha até 5 dias do mês.',
        'agreements_rules_change': 'Alterar',
        'agreements_rules_dialog_title': 'Atenção',
        'agreements_rules_dialog_text': 'Dias após o dia 28 podem variar.',
        'agreements_rules_dialog_confirmation': 'Entendi',
      },
      shrinkWrap: false,
      surface: const Size(400, 640),
    );

    await tester.tap(find.text('12'));
    await tester.pump();
    await tester.tap(find.text('29'));
    await tester.pumpAndSettle();
    expect(find.text('Atenção!'), findsOneWidget);
    await tester.tap(find.text('ENTENDI'));
    await tester.pumpAndSettle();
    expect(rules.days, containsAll([5, 12, 29]));
  });

  testWidgets('altera o máximo de parcelas', (tester) async {
    await pumpApp(
      tester,
      AgreementsMaxInstallmentsBottomSheet(
        minValue: 1,
        maxValue: 3,
        rules: AgreementsRules(installmentQtd: 1, days: [5]),
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
      surface: const Size(400, 420),
    );

    await tester.drag(find.byType(Slider), const Offset(80, 0));
    await tester.pump();
    expect(tester.widget<Slider>(find.byType(Slider)).value, greaterThan(1));
  });
}
