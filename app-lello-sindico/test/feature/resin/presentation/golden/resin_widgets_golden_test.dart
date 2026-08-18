import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account.dart';
import 'package:lello/feature/resin/domain/entity/resin_bank_account_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_params.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_filter.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_receipt_type.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_status.dart';
import 'package:lello/feature/resin/domain/entity/resin_refund_type.dart';
import 'package:lello/feature/resin/presentation/resin_attention_page/page/resin_attention_page.dart';
import 'package:lello/feature/resin/presentation/resin_create_refund_success_error/widgets/resin_create_refund_error_widget.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_form_data.dart';
import 'package:lello/feature/resin/presentation/resin_new_bank_account/widgets/resin_new_bank_account_type_checkbox_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_bank_accounts_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_confirmation_dialog.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_history_filter_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_delete_bank_account_dialog.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipt_bottom_sheet/resin_receipt_bottom_sheet_checkbox_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_receipts_receipt_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_status_selector_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_total_values_widget.dart';
import 'package:lello/feature/resin/presentation/widgets/resin_updating_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — erro ao criar reembolso', (tester) async {
    await pumpApp(
      tester,
      const ResinCreateRefundErrorWidget(refundType: ResinRefundType.refund),
      wrapInScaffold: false,
      surface: const Size(400, 420),
      localized: true,
      locOverrides: const {
        'resin_create_refund_error': 'Não foi possível criar o reembolso.',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_refund_error.png'),
    );
  });

  testWidgets('golden — seletor de status pago', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return ResinStatusSelectorWidget(
            context: context,
            refundRelatoryStatus: ResinRefundStatus.paid,
          );
        },
      ),
      localized: true,
      locOverrides: const {'paid': 'Pago'},
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_status_paid.png'),
    );
  });

  testWidgets('golden — status cancelado e inconsistente', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return Column(
            children: [
              ResinStatusSelectorWidget(
                context: context,
                refundRelatoryStatus: ResinRefundStatus.canceled,
              ),
              ResinStatusSelectorWidget(
                context: context,
                refundRelatoryStatus: ResinRefundStatus.inconsistency,
              ),
              ResinStatusSelectorWidget(
                context: context,
                refundRelatoryStatus: ResinRefundStatus.sended,
              ),
              ResinStatusSelectorWidget(
                context: context,
                refundRelatoryStatus: ResinRefundStatus.processed,
              ),
              ResinStatusSelectorWidget(
                context: context,
                refundRelatoryStatus: ResinRefundStatus.closing,
              ),
            ],
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'canceled': 'Cancelado',
        'inconsistency': 'Inconsistência',
        'sended': 'Enviado',
        'processed': 'Processado',
        'closing': 'Fechamento',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_status_variants.png'),
    );
  });

  testWidgets('golden — totais do caixa local', (tester) async {
    await pumpApp(
      tester,
      ResinTotalValuesWidget(
        resinParams: ResinParams(
          requestMaxValue: 5000,
          avaliableValue: 3200,
        ),
      ),
      localized: true,
      locOverrides: const {
        'resin_total_limit_value': 'Limite',
        'resin_total_to_prove': 'A comprovar',
        'resin_total_remaining': 'Disponível',
      },
      shrinkWrap: false,
      surface: const Size(400, 120),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_total_values.png'),
    );
  });

  testWidgets('golden — diálogo de confirmação', (tester) async {
    await pumpApp(
      tester,
      ResinConfirmationDialog(
        title: 'Confirmar envio?',
        subtitle: 'O reembolso será enviado para análise.',
        confirmationFunction: () {},
      ),
      localized: true,
      locOverrides: const {
        'confirm': 'Confirmar',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_confirmation_dialog.png'),
    );
  });

  testWidgets('golden — diálogo de confirmação só com subtítulo', (tester) async {
    await pumpApp(
      tester,
      ResinConfirmationDialog(
        subtitle: 'Deseja continuar?',
        confirmationFunction: () {},
      ),
      localized: true,
      locOverrides: const {
        'confirm': 'Confirmar',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_confirmation_dialog_subtitle.png'),
    );
  });

  testWidgets('golden — atualizando resin', (tester) async {
    await pumpApp(
      tester,
      const ResinUpdatingWidget(),
      localized: true,
      locOverrides: const {'resin_updating': 'Atualizando...'},
      settle: false,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_updating.png'),
    );
  });

  testWidgets('golden — comprovante sem arquivo', (tester) async {
    await pumpApp(
      tester,
      ResinReceiptsReceiptWidget(
        receipt: ResinRefundReceipt(
          receiptValue: 150,
          sendDate: DateTime(2026, 8, 10, 14, 30),
        ),
        excludeReceipt: () {},
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_receipt.png'),
    );
  });

  testWidgets('golden — diálogo para excluir conta', (tester) async {
    await pumpApp(
      tester,
      ResinDeleteBankAccountDialog(confirmationFunction: () {}),
      localized: true,
      locOverrides: const {
        'resin_delete_bank_account_confirmation':
            'Deseja excluir esta conta bancária?',
        'resin_delete_bank_account_delete': 'Excluir',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_delete_bank_account.png'),
    );
  });

  testWidgets('golden — lista vazia de contas bancárias', (tester) async {
    await pumpApp(
      tester,
      ResinBankAccountsWidget(
        bankAccounts: const [],
        onAccountSelected: (_) {},
        deleteAccountFunction: (_) {},
        uploadBankAccounts: () {},
      ),
      localized: true,
      locOverrides: const {
        'resin_bank_accounts': 'Contas bancárias',
        'resin_new_account': 'Nova conta',
        'resin_bank_accounts_empty': 'Nenhuma conta cadastrada',
      },
      shrinkWrap: false,
      surface: const Size(400, 240),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_bank_accounts_empty.png'),
    );
  });

  testWidgets('golden — lista de contas bancárias', (tester) async {
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_bank_accounts.png'),
    );
  });

  testWidgets('golden — tipo do comprovante', (tester) async {
    await pumpApp(
      tester,
      ResinReceiptBottomSheetCheckboxWidget(
        receipt: ResinRefundReceipt(
          receiptValue: 90,
          receiptType: ResinRefundReceiptType.tax_note,
        ),
      ),
      localized: true,
      locOverrides: const {
        'resin_refund_receipt_type_tax_note': 'Nota fiscal',
        'resin_refund_receipt_type_receipt': 'Recibo',
      },
      shrinkWrap: false,
      surface: const Size(400, 80),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_receipt_type.png'),
    );
  });

  testWidgets('golden — contas bancárias atualizando', (tester) async {
    await pumpApp(
      tester,
      ResinBankAccountsWidget(
        bankAccounts: const [],
        onAccountSelected: (_) {},
        deleteAccountFunction: (_) {},
        uploadBankAccounts: () {},
        isUpdating: true,
      ),
      localized: true,
      locOverrides: const {
        'resin_bank_accounts': 'Contas bancárias',
        'resin_new_account': 'Nova conta',
        'resin_bank_accounts_empty': 'Nenhuma conta cadastrada',
        'resin_updating': 'Atualizando...',
      },
      shrinkWrap: false,
      surface: const Size(400, 260),
      settle: false,
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_bank_accounts_updating.png'),
    );
  });

  testWidgets('golden — conta bancária sem banco', (tester) async {
    await pumpApp(
      tester,
      ResinBankAccountsWidget(
        bankAccounts: [
          ResinBankAccount(
            bank: null,
            agency: '0001',
            accountNumber: '123',
            document: '123',
            supplierName: 'Fornecedor sem banco',
            accountType: ResinBankAccountType.current,
          ),
        ],
        onAccountSelected: (_) {},
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_bank_accounts_no_bank.png'),
    );
  });

  testWidgets('golden — tipo de conta corrente e poupança', (tester) async {
    final form = ResinNewBankAccountFormData(
      agencyController: TextEditingController(),
      accountController: TextEditingController(),
      digitController: TextEditingController(),
      accountType: ResinBankAccountType.current,
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_bank_account_type.png'),
    );
  });

  testWidgets('golden — lista vazia de comprovantes', (tester) async {
    await pumpApp(
      tester,
      ResinReceiptsWidget(
        resinParams: ResinParams(),
        refund: ResinRefund(
          requestDate: DateTime(2026, 8, 1),
          requester: 'Ana',
          status: ResinRefundStatus.sended,
          type: ResinRefundType.refund,
          value: 200,
          receipts: const [],
        ),
      ),
      localized: true,
      locOverrides: const {
        'resin_receipts_title': 'Comprovantes',
        'resin_receipts_total_refund_value': 'Valor do reembolso',
        'resin_receipts_total_receipts_value': 'Total comprovado',
        'resin_receipts_empty': 'Nenhum comprovante enviado',
      },
      shrinkWrap: false,
      surface: const Size(400, 420),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_receipts_empty.png'),
    );
  });

  testWidgets('golden — filtro do histórico de resin', (tester) async {
    await pumpApp(
      tester,
      ResinHistoryFilterWidget(
        filter: ResinRefundFilter(
          protocol: 'ABC-1',
          startDate: DateTime(2026, 1, 1),
          endDate: DateTime(2026, 8, 1),
        ),
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_history_filter.png'),
    );
  });

  testWidgets('golden — erro ao criar adiantamento', (tester) async {
    await pumpApp(
      tester,
      const ResinCreateRefundErrorWidget(refundType: ResinRefundType.advance),
      wrapInScaffold: false,
      surface: const Size(400, 420),
      localized: true,
      locOverrides: const {
        'resin_create_advance_error': 'Não foi possível criar o adiantamento.',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_create_advance_error.png'),
    );
  });

  testWidgets('golden — página de atenção do resin', (tester) async {
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
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/resin_attention.png'),
    );
  });
}
