import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';

class TokenSuccessWidget extends StatefulWidget {
  final PendencyApprovalAction action;
  final Function() onClose;

  const TokenSuccessWidget({
    super.key,
    required this.action,
    required this.onClose,
  });

  @override
  State<TokenSuccessWidget> createState() => _TokenSuccessWidgetState();
}

class _TokenSuccessWidgetState extends State<TokenSuccessWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        widget.onClose();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/ic_success_payment.svg"),
                  SizedBox(height: Dimens.spacing),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: LelloTextStyles.headline(theme),
                      children: [
                        TextSpan(
                          text: getString(context, 'payment_word'),
                          style: LelloTextStyles.headline(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                        TextSpan(
                          text: " ${_actionToString(widget.action)}",
                          style: LelloTextStyles.headline(theme)!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                        TextSpan(
                          text: " com sucesso!",
                          style: LelloTextStyles.headline(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).primary(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    "Acompanhe o andamento deste pagamento através do nosso portal ou aplicativo para Síndicos",
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme),
                  ),
                ],
              ),
            ),
            PrimaryButton(
              text: getString(context, 'payment_back_to_pending_approvals'),
              onPressed: () => widget.onClose(),
            ),
          ],
        ),
      ),
    );
  }

  String _actionToString(PendencyApprovalAction action) {
    switch (action) {
      case PendencyApprovalAction.approve:
        return getString(context, 'payment_status_approved');
      case PendencyApprovalAction.reject:
        return getString(context, 'payment_status_cancelled');
      case PendencyApprovalAction.suspend:
        return getString(context, 'payment_status_suspended');
    }
  }
}
