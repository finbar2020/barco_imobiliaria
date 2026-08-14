import 'package:essentials/ui/widget/button/inverted_primary_button.dart';
import 'package:essentials/ui/widget/button/primary_button.dart';
import 'package:essentials/ui/widget/button/secondary_button.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';

class BalanceApprovalModal extends StatelessWidget {
  final double? balance;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final PendencyApprovalAction action;

  const BalanceApprovalModal({
    Key? key,
    required this.balance,
    required this.onConfirm,
    required this.onCancel,
    required this.action,
  }) : super(key: key);

  String get actionText {
    switch (action) {
      case PendencyApprovalAction.approve:
        return 'aprovação';
      case PendencyApprovalAction.reject:
        return 'rejeição';
      case PendencyApprovalAction.suspend:
        return 'suspensão';
    }
  }

  String formatCurrency(double value) {
    final formatter = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text('Este é seu saldo atual:',
                  style: LelloTextStyles.subtitleBold(theme)),
            ),
            const SizedBox(height: 24),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomLeft: Radius.circular(6),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(6),
                          bottomRight: Radius.circular(6),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Saldo do Condomínio',
                              style: LelloTextStyles.subtitle(theme)!
                                  .copyWith(color: theme.disabledColor)),
                          const SizedBox(height: 4),
                          Text(
                              balance != null
                                  ? formatCurrency(balance!)
                                  : "Não foi possível carregar o saldo",
                              style: LelloTextStyles.title(theme)!
                                  .copyWith(color: theme.disabledColor)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text('Deseja continuar a $actionText?',
                style: LelloTextStyles.subtitleBold(theme)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                onPressed: onConfirm,
                child: Text(
                  'Sim, continuar $actionText',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: InvertedPrimaryButton(
                onPressed: onCancel,
                child: const Text('Não, voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
