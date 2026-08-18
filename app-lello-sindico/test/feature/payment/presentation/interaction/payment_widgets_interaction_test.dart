import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/condominium_balance_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_error_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_success_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/token_success_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('modal de saldo confirma e cancela', (tester) async {
    var confirmed = false;
    var cancelled = false;

    await pumpApp(
      tester,
      BalanceApprovalModal(
        balance: 1000,
        action: PendencyApprovalAction.approve,
        onConfirm: () => confirmed = true,
        onCancel: () => cancelled = true,
      ),
    );

    await tester.tap(find.text('Sim, continuar aprovação'));
    await tester.pump();
    expect(confirmed, isTrue);

    await tester.tap(find.text('Não, voltar'));
    await tester.pump();
    expect(cancelled, isTrue);
  });

  testWidgets('erro de token chama o fechar', (tester) async {
    var closed = false;
    await pumpApp(
      tester,
      TokenErrorWidget(
        action: PendencyApprovalAction.approve,
        onClose: () => closed = true,
      ),
      localized: true,
      locOverrides: const {
        'payment_action_approval': 'a aprovação',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.tap(find.text('Voltar para aprovações pendentes'));
    await tester.pump();
    expect(closed, isTrue);
  });

  testWidgets('voltar do sistema dispara onClose no erro de token',
      (tester) async {
    var closed = false;
    await pumpApp(
      tester,
      TokenErrorWidget(
        action: PendencyApprovalAction.reject,
        onClose: () => closed = true,
      ),
      localized: true,
      locOverrides: const {
        'payment_action_cancellation': 'o cancelamento',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.state<NavigatorState>(find.byType(Navigator)).maybePop();
    await tester.pump();
    expect(closed, isTrue);
  });

  testWidgets('sucesso de token chama o fechar', (tester) async {
    var closed = false;
    await pumpApp(
      tester,
      TokenSuccessWidget(
        action: PendencyApprovalAction.reject,
        onClose: () => closed = true,
      ),
      localized: true,
      locOverrides: const {
        'payment_word': 'Pagamento',
        'payment_status_cancelled': 'cancelado',
        'payment_back_to_pending_approvals': 'Voltar para aprovações pendentes',
      },
      shrinkWrap: false,
      surface: const Size(400, 720),
    );

    await tester.tap(find.text('Voltar para aprovações pendentes'));
    await tester.pump();
    expect(closed, isTrue);
  });
}
