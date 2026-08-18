import 'package:essentials/ui/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payment/domain/entity/contas_pagar.dart';
import 'package:lello/feature/payment/domain/entity/lancamento.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item.dart';
import 'package:lello/feature/payment/domain/entity/payment_history_item_status.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_in_approval.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_ledger_account.dart';
import 'package:lello/feature/payment/domain/entity/payment_installment_supplier.dart';
import 'package:lello/feature/payment/presentation/history_list/widgets/payment_history_list_item.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/info_banner_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/no_access_to_this_feature_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_error_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_success_widget.dart';
import 'package:lello/feature/payment/presentation/register/widget/empty_folder_widget.dart';
import 'package:lello/feature/payment/presentation/register/widget/payment_delete_file_dialog.dart';
import 'package:lello/feature/payment/domain/entity/ledger_account.dart';
import 'package:lello/feature/payment/presentation/register_form/page/steps/02_register_installments/page/register_installments_recomendation_bottom_sheet.dart';
import 'package:lello/feature/payment/presentation/register_form/page/widgets/step_indicator.dart';
import 'package:lello/feature/payment/presentation/send_financial_department/page/payment_send_financial_department_success_page.dart';
import 'package:lello/feature/payment/presentation/widget/payment_conta_pagar_item.dart';
import 'package:lello/feature/payment/presentation/widget/payment_list_item.dart';
import 'package:lello/feature/payment/presentation/widget/payment_pendency_info_bottomsheet.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — item de pagamento em aprovação', (tester) async {
    await pumpApp(
      tester,
      PaymentListItem(
        showFileButton: false,
        payment: PaymentInstallmentInApprovalEntity(
          installmentId: 2,
          dueDate: '15/08/2026',
          lancamento: LancamentoEntity(
            transactionId: 12345,
            status: 'Pendente',
            netValue: 1500,
            registrationDate: '01/08/2026',
            supplier: PaymentInstallmentSupplier(tradeName: 'Fornecedor XYZ'),
            ledgerAccount: PaymentInstallmentLedgerAccount(
              shortCode: 123,
              name: 'Manutenção',
            ),
          ),
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 260),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_list_item.png'),
    );
  });

  testWidgets('golden — item de conta a pagar', (tester) async {
    await pumpApp(
      tester,
      PaymentContaPagarItem(
        showFileButton: false,
        payment: ContasPagarEntity(
          installmentId: 99,
          supplierName: 'Energia SA',
          value: 890.5,
          statusDescription: 'pendente',
          releaseDate: '01/08/2026',
          dueDate: '20/08/2026',
          transactionId: 1,
          transactionQuantity: 3,
        ),
      ),
      shrinkWrap: false,
      surface: const Size(400, 220),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_conta_pagar_item.png'),
    );
  });

  testWidgets('golden — item do histórico de pagamento', (tester) async {
    await pumpApp(
      tester,
      PaymentHistoryListItem(
        PaymentHistoryItem(
          releaseId: '456',
          supplierName: 'Limpeza Ltda',
          totalValue: 320,
          installments: 1,
          inclusionDate: DateTime(2026, 8, 1),
          processingStatus: PaymentHistoryItemStatus.progress,
        ),
      ),
      localized: true,
      locOverrides: const {
        'payments_history_label_lancamento': 'Lançamento',
        'payments_history_label_valor': 'Valor',
        'payments_history_label_parcelas': 'Parcelas',
        'payments_history_label_data': 'Data',
      },
      shrinkWrap: false,
      surface: const Size(400, 160),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_history_item.png'),
    );
  });

  testWidgets('golden — indicador de etapas do cadastro', (tester) async {
    await pumpApp(
      tester,
      const RegisterFormStepIndicator(totalSteps: 4, currentStep: 1),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_step_indicator.png'),
    );
  });

  testWidgets('golden — banner informativo de pendência', (tester) async {
    await pumpApp(
      tester,
      InfoBannerWidget(
        theme: LelloTheme.light,
        onClose: () {},
      ),
      localized: true,
      locOverrides: const {
        'payment_pendency_banner_info':
            'Confira os dados antes de aprovar o pagamento.',
      },
      shrinkWrap: false,
      surface: const Size(400, 120),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_info_banner.png'),
    );
  });

  testWidgets('golden — diálogo de exclusão de arquivo', (tester) async {
    await pumpApp(
      tester,
      PaymentDeleteFileDialog(onConfirm: () {}, onCancel: () {}),
      localized: true,
      locOverrides: const {
        'register_payment_exclude_file_confirmation':
            'Deseja excluir este arquivo?',
        'yes': 'Sim',
        'register_payment_cancel': 'Cancelar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_delete_file_dialog.png'),
    );
  });

  testWidgets('golden — sem acesso à funcionalidade', (tester) async {
    await pumpApp(
      tester,
      const NoAccessToThisFeatureWidget(),
      shrinkWrap: false,
      surface: const Size(400, 480),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_no_access.png'),
    );
  });

  testWidgets('golden — pasta vazia no cadastro', (tester) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) {
          return EmptyFolderWidget(
            height: 220,
            width: 360,
            theme: Theme.of(context),
          );
        },
      ),
      localized: true,
      locOverrides: const {
        'register_payment_empty_carousel_text': 'Nenhum arquivo anexado',
      },
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_empty_folder.png'),
    );
  });

  testWidgets('golden — erro ao validar token', (tester) async {
    await pumpApp(
      tester,
      TokenErrorWidget(
        action: PendencyApprovalAction.reject,
        onClose: () {},
      ),
      localized: true,
      locOverrides: const {
        'payment_action_cancellation': 'o cancelamento',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_token_error.png'),
    );
  });

  testWidgets('golden — token validado com sucesso', (tester) async {
    await pumpApp(
      tester,
      TokenSuccessWidget(
        action: PendencyApprovalAction.approve,
        onClose: () {},
      ),
      localized: true,
      locOverrides: const {
        'payment_word': 'Pagamento',
        'payment_status_approved': 'aprovado',
        'payment_back_to_pending_approvals': 'Voltar para aprovações pendentes',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_token_success.png'),
    );
  });

  testWidgets('golden — token de suspensão com sucesso', (tester) async {
    await pumpApp(
      tester,
      TokenSuccessWidget(
        action: PendencyApprovalAction.suspend,
        onClose: () {},
      ),
      localized: true,
      locOverrides: const {
        'payment_word': 'Pagamento',
        'payment_status_suspended': 'suspenso',
        'payment_back_to_pending_approvals': 'Voltar para aprovações pendentes',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_token_success_suspend.png'),
    );
  });

  testWidgets('golden — informações das aprovações pendentes', (tester) async {
    await pumpApp(
      tester,
      PaymentPendencyInfoBottomsheet(),
      shrinkWrap: false,
      surface: const Size(400, 800),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_pendency_info.png'),
    );
  });

  testWidgets('golden — envio ao financeiro com sucesso', (tester) async {
    await pumpApp(
      tester,
      const PaymentSendFinancialDepartmentSuccessPage(),
      wrapInScaffold: false,
      localized: true,
      locOverrides: const {
        'register_payment_title': 'Cadastro de pagamento',
        'payments_send_financial_success_page_title': 'Documentos enviados',
        'payments_send_financial_success_page_sub_title':
            'O financeiro vai analisar o envio.',
        'payments_send_financial_success_page_send_again': 'Enviar novamente',
        'back': 'Voltar',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_send_financial_success.png'),
    );
  });

  testWidgets('golden — conta a pagar sem dados', (tester) async {
    await pumpApp(
      tester,
      PaymentContaPagarItem(
        showFileButton: false,
        payment: ContasPagarEntity(),
      ),
      shrinkWrap: false,
      surface: const Size(400, 280),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_conta_pagar_empty.png'),
    );
  });

  testWidgets('golden — recomendação de classificação', (tester) async {
    await pumpApp(
      tester,
      RegisterInstallmentsRecomendationBottomSheet(
        LedgerAccountEntity(id: 10, name: 'Manutenção predial'),
        noLedgerAccountButton: () {},
        differentClassificationButton: () {},
        sendPaymentButton: () {},
      ),
      localized: true,
      locOverrides: const {
        'payments_last_payment_account_notice':
            'A última classificação usada foi',
        'payments_proceed_question': 'Deseja continuar?',
        'payments_confirm_send_payment': 'Confirmar envio',
        'payments_use_other_classification': 'Usar outra classificação',
        'payments_send_without_account': 'Enviar sem conta',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_installments_recommendation.png'),
    );
  });
}
