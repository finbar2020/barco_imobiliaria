import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_inconcistency.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/presentation/resin_attention_page/page/resin_attention_page.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/widgets/resin_create_refund_error_widget.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_form_data.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_confirmation_dialog.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_history_filter_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_widget.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_type_checkbox_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_bank_accounts_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipt_bottom_sheet/resin_receipt_bottom_sheet_checkbox_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_receipt_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('exclui o comprovante', (tester) async {
    var excluded = false;
    await pumpApp(
      tester,
      ResinReceiptsReceiptWidget(
        receipt: ResinRefundReceipt(receiptValue: 80),
        excludeReceipt: () => excluded = true,
      ),
      localized: true,
      locOverrides: const {
        'resin_receipts_send_date': 'Enviado em',
        'resin_receipts_value': 'Valor',
        'resin_receipts_exclude': 'Excluir',
      },
      shrinkWrap: false,
      surface: const Size(400, 160),
    );

    await tester.tap(find.text('Excluir'));
    await tester.pump();
    expect(excluded, isTrue);
  });

  testWidgets('seleciona a conta bancária', (tester) async {
    String? selected;
    await pumpApp(
      tester,
      ResinBankAccountsWidget(
        bankAccounts: [
          ResinBankAccount(
            bank: ResinBank(id: '1', bankCode: '341', bankName: 'Itaú'),
            agency: '1234',
            accountNumber: '56789-0',
            document: '123',
            supplierName: 'Fornecedor ABC',
            accountType: ResinBankAccountType.current,
          ),
        ],
        onAccountSelected: (account) => selected = account.supplierName,
        deleteAccountFunction: (_) {},
        uploadBankAccounts: () {},
      ),
      localized: true,
      locOverrides: const {
        'resin_bank_accounts': 'Contas bancárias',
        'resin_new_account': 'Nova conta',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );

    await tester.tap(find.text('Fornecedor ABC'));
    await tester.pump();
    expect(selected, 'Fornecedor ABC');
  });

  testWidgets('alterna o tipo do comprovante', (tester) async {
    final receipt = ResinRefundReceipt(receiptValue: 10);
    await pumpApp(
      tester,
      ResinReceiptBottomSheetCheckboxWidget(receipt: receipt),
      localized: true,
      locOverrides: const {
        'resin_refund_receipt_type_tax_note': 'Nota fiscal',
        'resin_refund_receipt_type_receipt': 'Recibo',
      },
      shrinkWrap: false,
      surface: const Size(400, 80),
    );

    await tester.tap(find.text('Recibo'));
    await tester.pump();
    expect(receipt.receiptType, ResinRefundReceiptType.receipt);

    await tester.tap(find.text('Recibo'));
    await tester.pump();
    expect(receipt.receiptType, isNull);
  });

  testWidgets('confirma a exclusão da conta bancária', (tester) async {
    var deleted = false;
    await pumpApp(
      tester,
      ResinBankAccountsWidget(
        bankAccounts: [
          ResinBankAccount(
            bank: ResinBank(id: '1', bankCode: '341', bankName: 'Itaú'),
            agency: '1234',
            accountNumber: '56789-0',
            document: '123',
            supplierName: 'Fornecedor ABC',
            accountType: ResinBankAccountType.current,
          ),
        ],
        onAccountSelected: (_) {},
        deleteAccountFunction: (_) => deleted = true,
        uploadBankAccounts: () {},
      ),
      localized: true,
      locOverrides: const {
        'resin_bank_accounts': 'Contas bancárias',
        'resin_new_account': 'Nova conta',
        'resin_delete_bank_account_confirmation': 'Excluir esta conta?',
        'resin_delete_bank_account_delete': 'Excluir',
        'back': 'Voltar',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );

    await tester.tap(find.byType(SvgPicture).last);
    await tester.pump();
    expect(find.text('Excluir esta conta?'), findsOneWidget);

    await tester.tap(find.text('Excluir'));
    await tester.pump();
    expect(deleted, isTrue);
  });

  testWidgets('alterna o tipo da conta bancária', (tester) async {
    final form = ResinNewBankAccountFormData(
      agencyController: TextEditingController(),
      accountController: TextEditingController(),
      digitController: TextEditingController(),
    );
    addTearDown(() {
      form.agencyController.dispose();
      form.accountController.dispose();
      form.digitController.dispose();
    });
    await pumpApp(
      tester,
      ResinNewBankAccountTypeCheckboxWidget(accountFormData: form),
      localized: true,
      locOverrides: const {
        'resin_bank_account_type_current': 'Corrente',
        'resin_bank_account_type_saving': 'Poupança',
      },
      shrinkWrap: false,
      surface: const Size(400, 120),
    );

    await tester.tap(find.text('Corrente'));
    await tester.pump();
    expect(form.accountType, ResinBankAccountType.current);

    await tester.tap(find.text('Poupança'));
    await tester.pump();
    expect(form.accountType, ResinBankAccountType.saving);

    await tester.tap(find.text('Poupança'));
    await tester.pump();
    expect(form.accountType, isNull);
  });

  testWidgets('exclui o comprovante pela lista', (tester) async {
    final refund = ResinRefund(
      requestDate: DateTime(2026, 8, 1),
      requester: 'Ana',
      status: ResinRefundStatus.sended,
      type: ResinRefundType.refund,
      value: 200,
      receipts: [ResinRefundReceipt(receiptValue: 80)],
    );
    await pumpApp(
      tester,
      ResinReceiptsWidget(
        resinParams: ResinParams(),
        refund: refund,
      ),
      localized: true,
      locOverrides: const {
        'resin_receipts_title': 'Comprovantes',
        'resin_receipts_total_refund_value': 'Valor do reembolso',
        'resin_receipts_total_receipts_value': 'Total comprovado',
        'resin_receipts_empty': 'Nenhum comprovante enviado',
        'resin_receipts_send_date': 'Enviado em',
        'resin_receipts_value': 'Valor',
        'resin_receipts_exclude': 'Excluir',
        'resin_receipts_exclude_confirmation': 'Excluir comprovante?',
        'confirm': 'Confirmar',
        'back': 'Voltar',
      },
      shrinkWrap: false,
      surface: const Size(400, 420),
    );

    expect(find.text('Nenhum comprovante enviado'), findsNothing);
    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum comprovante enviado'), findsOneWidget);
  });

  testWidgets('limpa os filtros do histórico', (tester) async {
    final filter = ResinRefundFilter(
      protocol: 'ABC-1',
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 8, 1),
      status: ResinRefundStatus.sended,
    );
    await pumpApp(
      tester,
      ResinHistoryFilterWidget(
        filter: filter,
        params: ResinParams(
          filterStartDate: DateTime(2025, 1, 1),
          filterEndDate: DateTime(2026, 12, 31),
        ),
        onSearch: () {},
      ),
      localized: true,
      locOverrides: const {
        'filter': 'Filtro',
        'reports_choose_date': 'Escolha o período',
        'from': 'De',
        'to': 'Até',
        'find': 'Buscar',
        'inconsistency': 'Inconsistência',
        'choose_an_option': 'Escolha',
        'gdp_status': 'Status',
        'protocol_number': 'Protocolo',
        'sended': 'Enviado',
        'processed': 'Processado',
        'paid': 'Pago',
        'canceled': 'Cancelado',
        'closing': 'Fechamento',
        'resin_inconsistency_registration': 'Cadastro',
        'resin_inconsistency_payment': 'Pagamento',
        'resin_inconsistency_document_illegible': 'Ilegível',
        'resin_inconsistency_duplicity': 'Duplicidade',
        'resin_inconsistency_value_above_limit': 'Acima do limite',
      },
      shrinkWrap: false,
      surface: const Size(400, 900),
    );

    await tester.tap(find.text('Limpar filtros'));
    await tester.pump();
    expect(filter.protocol, isNull);
    expect(filter.status, isNull);
  });

  testWidgets('busca e fecha o filtro do histórico', (tester) async {
    var searched = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => Scaffold(
                    body: ResinHistoryFilterWidget(
                      filter: ResinRefundFilter(
                        protocol: 'ABC-1',
                        startDate: DateTime(2026, 1, 1),
                        endDate: DateTime(2026, 8, 1),
                      ),
                      params: ResinParams(),
                      onSearch: () => searched = true,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'filter': 'Filtro',
        'reports_choose_date': 'Escolha o período',
        'from': 'De',
        'to': 'Até',
        'find': 'Buscar',
        'inconsistency': 'Inconsistência',
        'choose_an_option': 'Escolha',
        'gdp_status': 'Status',
        'protocol_number': 'Protocolo',
        'sended': 'Enviado',
        'processed': 'Processado',
        'paid': 'Pago',
        'canceled': 'Cancelado',
        'closing': 'Fechamento',
        'resin_inconsistency_registration': 'Cadastro',
        'resin_inconsistency_payment': 'Pagamento',
        'resin_inconsistency_document_illegible': 'Ilegível',
        'resin_inconsistency_duplicity': 'Duplicidade',
        'resin_inconsistency_value_above_limit': 'Acima do limite',
      },
      shrinkWrap: false,
      surface: const Size(400, 900),
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Buscar'));
    await tester.pumpAndSettle();
    expect(searched, isTrue);
    expect(find.text('Abrir'), findsOneWidget);
  });

  testWidgets('confirma o diálogo de resin', (tester) async {
    var confirmed = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => ResinConfirmationDialog(
                  subtitle: 'Confirma?',
                  confirmationFunction: () => confirmed = true,
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'confirm': 'Confirmar',
        'back': 'Voltar',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar'));
    await tester.pumpAndSettle();
    expect(confirmed, isTrue);
    expect(find.text('Confirma?'), findsNothing);
  });

  testWidgets('cancela o diálogo de resin', (tester) async {
    var confirmed = false;
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return TextButton(
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => ResinConfirmationDialog(
                  subtitle: 'Confirma?',
                  confirmationFunction: () => confirmed = true,
                ),
              );
            },
            child: const Text('Abrir'),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'confirm': 'Confirmar',
        'back': 'Voltar',
      },
    );

    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(confirmed, isFalse);
    expect(find.text('Confirma?'), findsNothing);
  });

  testWidgets('seleciona status e inconsistência no filtro', (tester) async {
    final filter = ResinRefundFilter(
      startDate: DateTime(2026, 1, 1),
      endDate: DateTime(2026, 8, 1),
    );
    await pumpApp(
      tester,
      ResinHistoryFilterWidget(
        filter: filter,
        params: ResinParams(),
        onSearch: () {},
      ),
      localized: true,
      locOverrides: const {
        'filter': 'Filtro',
        'reports_choose_date': 'Escolha o período',
        'from': 'De',
        'to': 'Até',
        'find': 'Buscar',
        'inconsistency': 'Inconsistência',
        'choose_an_option': 'Escolha',
        'gdp_status': 'Status',
        'protocol_number': 'Protocolo',
        'sended': 'Enviado',
        'processed': 'Processado',
        'paid': 'Pago',
        'canceled': 'Cancelado',
        'closing': 'Fechamento',
        'resin_inconsistency_registration': 'Cadastro',
        'resin_inconsistency_payment': 'Pagamento',
        'resin_inconsistency_document_illegible': 'Ilegível',
        'resin_inconsistency_duplicity': 'Duplicidade',
        'resin_inconsistency_value_above_limit': 'Acima do limite',
      },
      shrinkWrap: false,
      surface: const Size(400, 900),
    );

    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString().startsWith('DropdownButton'),
      ).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pago').last);
    await tester.pumpAndSettle();
    expect(filter.status, ResinRefundStatus.paid);

    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget.runtimeType.toString().startsWith('DropdownButton'),
      ).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicidade').last);
    await tester.pumpAndSettle();
    expect(filter.inconsistency, ResinRefundInconcistency.duplicity);
  });

  testWidgets('volta da tela de erro do adiantamento', (tester) async {
    await pumpApp(
      tester,
      const ResinCreateRefundErrorWidget(refundType: ResinRefundType.advance),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'resin_create_advance_error': 'Não foi possível criar o adiantamento.',
        'back': 'Voltar',
      },
    );

    expect(find.text('Não foi possível criar o adiantamento.'), findsOneWidget);
    await tester.tap(find.text('Voltar'));
    await tester.pumpAndSettle();
    expect(find.text('Não foi possível criar o adiantamento.'), findsNothing);
  });

  testWidgets('fecha a página de atenção do resin', (tester) async {
    await pumpApp(
      tester,
      Navigator(
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          settings: RouteSettings(
            arguments: ResinAttentionPageArgs(subtitle: 'Limite atingido'),
          ),
          builder: (_) => const ResinAttentionPage(),
        ),
      ),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'advance_request_warning_title': 'Atenção',
        'ok': 'Ok',
      },
    );

    expect(find.text('Atenção'), findsOneWidget);
    await tester.tap(find.text('Ok'));
    await tester.pumpAndSettle();
    expect(find.text('Atenção'), findsNothing);
  });
}
