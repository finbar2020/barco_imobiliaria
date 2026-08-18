import 'package:flutter_test/flutter_test.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/condominium_balance_widget.dart';
import 'package:lello/feature/payment/presentation/pendency/widgets/dialog_payment_approved_widget.dart';

import '../../../../helpers/pump_app.dart';

void main() {
  testWidgets('golden — modal de saldo para aprovação', (tester) async {
    await pumpApp(
      tester,
      BalanceApprovalModal(
        balance: 12500.5,
        action: PendencyApprovalAction.approve,
        onConfirm: () {},
        onCancel: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/balance_approval_modal.png'),
    );
  });

  testWidgets('golden — modal de saldo indisponível', (tester) async {
    await pumpApp(
      tester,
      BalanceApprovalModal(
        balance: null,
        action: PendencyApprovalAction.reject,
        onConfirm: () {},
        onCancel: () {},
      ),
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/balance_unavailable_modal.png'),
    );
  });

  testWidgets('golden — diálogo de pagamento já aprovado', (tester) async {
    await pumpApp(
      tester,
      const DialogPaymentAproovedWidget(),
      localized: true,
      locOverrides: const {
        'attention': 'Atenção',
        'payment_approved_dialog_title':
            'Este pagamento já foi aprovado.',
        'payment_approved_dialog_subtitle':
            'Acompanhe o status no histórico.',
        'ok': 'OK',
      },
    );
    await expectLater(
      findGoldenSurface(),
      matchesGoldenFile('goldens/payment_already_approved.png'),
    );
  });
}
