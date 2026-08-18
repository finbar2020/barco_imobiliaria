import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/lancamento.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_supplier.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_recomendation_bottom_sheet.dart';
import 'package:lello/feature/payment/presentation/widget/payment_conta_pagar_item.dart';
import 'package:lello/feature/payment/presentation/widget/payment_list_item.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('toca o lançamento e dispara o id da transação', (tester) async {
    String? tapped;
    await pumpApp(
      tester,
      PaymentListItem(
        showFileButton: false,
        onPressed: (id) => tapped = id,
        payment: PaymentInstallmentInApprovalEntity(
          installmentId: 1,
          dueDate: '15/08/2026',
          lancamento: LancamentoEntity(
            transactionId: 88,
            status: 'Pendente',
            netValue: 10,
            supplier: PaymentInstallmentSupplier(tradeName: 'Acme'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('ACME'));
    await tester.pump();
    expect(tapped, '88');
  });

  testWidgets('usa razão social e conta só com nome', (tester) async {
    String? tapped;
    await pumpApp(
      tester,
      PaymentListItem(
        showFileButton: false,
        onPressed: (id) => tapped = id,
        payment: PaymentInstallmentInApprovalEntity(
          installmentId: 2,
          dueDate: '20/08/2026',
          lancamento: LancamentoEntity(
            transactionId: 12,
            status: 'Pendente',
            netValue: 40,
            supplier: PaymentInstallmentSupplier(legalName: 'Fornecedor Legal'),
            ledgerAccount: PaymentInstallmentLedgerAccount(name: 'Conta xyz'),
          ),
        ),
      ),
    );

    expect(find.text('Fornecedor Legal'), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('CONTA XYZ'),
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Fornecedor Legal'));
    await tester.pump();
    expect(tapped, '12');
  });

  testWidgets('não dispara toque sem id de transação', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      PaymentListItem(
        showFileButton: false,
        onPressed: (_) => tapped = true,
        payment: PaymentInstallmentInApprovalEntity(
          installmentId: 3,
          dueDate: '21/08/2026',
          lancamento: LancamentoEntity(
            status: 'Pendente',
            netValue: 10,
            supplier: PaymentInstallmentSupplier(tradeName: 'Sem id'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('SEM ID'));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('não dispara toque em conta a pagar sem parcela', (tester) async {
    var tapped = false;
    await pumpApp(
      tester,
      PaymentContaPagarItem(
        showFileButton: false,
        onPressed: (_) => tapped = true,
        payment: ContasPagarEntity(supplierName: 'Sem parcela'),
      ),
    );

    await tester.tap(find.text('SEM PARCELA'));
    await tester.pump();
    expect(tapped, isFalse);
  });

  testWidgets('toca a conta a pagar e dispara o id', (tester) async {
    String? tapped;
    await pumpApp(
      tester,
      PaymentContaPagarItem(
        showFileButton: false,
        onPressed: (id) => tapped = id,
        payment: ContasPagarEntity(
          installmentId: 44,
          supplierName: 'Energia',
          value: 10,
        ),
      ),
    );

    await tester.tap(find.text('ENERGIA'));
    await tester.pump();
    expect(tapped, '44');
  });

  testWidgets('recomendação confirma o envio e fecha o sheet', (tester) async {
    var sent = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (_) => RegisterInstallmentsRecomendationBottomSheet(
                  LedgerAccountEntity(id: 1, name: 'Água'),
                  noLedgerAccountButton: () {},
                  differentClassificationButton: () {},
                  sendPaymentButton: () => sent = true,
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'payments_last_payment_account_notice': 'Última conta',
        'payments_proceed_question': 'Continuar?',
        'payments_confirm_send_payment': 'Confirmar envio',
        'payments_use_other_classification': 'Usar outra',
        'payments_send_without_account': 'Sem conta',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar envio'));
    await tester.pumpAndSettle();
    expect(sent, isTrue);
    expect(find.text('Continuar?'), findsNothing);
  });

  testWidgets('recomendação usa outra classificação', (tester) async {
    var other = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (_) => RegisterInstallmentsRecomendationBottomSheet(
                  LedgerAccountEntity(id: 2, name: 'Luz'),
                  noLedgerAccountButton: () {},
                  differentClassificationButton: () => other = true,
                  sendPaymentButton: () {},
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'payments_last_payment_account_notice': 'Última conta',
        'payments_proceed_question': 'Continuar?',
        'payments_confirm_send_payment': 'Confirmar envio',
        'payments_use_other_classification': 'Usar outra',
        'payments_send_without_account': 'Sem conta',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Usar outra'));
    await tester.pumpAndSettle();
    expect(other, isTrue);
  });

  testWidgets('recomendação envia sem conta', (tester) async {
    var without = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (_) => RegisterInstallmentsRecomendationBottomSheet(
                  null,
                  noLedgerAccountButton: () => without = true,
                  differentClassificationButton: () {},
                  sendPaymentButton: () {},
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'payments_last_payment_account_notice': 'Última conta',
        'payments_proceed_question': 'Continuar?',
        'payments_confirm_send_payment': 'Confirmar envio',
        'payments_use_other_classification': 'Usar outra',
        'payments_send_without_account': 'Sem conta',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sem conta'));
    await tester.pumpAndSettle();
    expect(without, isTrue);
  });
}
