import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/payment/domain/entity/pendency_approval_action.dart';

class TokenErrorWidget extends StatefulWidget {
  final PendencyApprovalAction action;
  final Function() onClose;
  const TokenErrorWidget(
      {super.key, required this.action, required this.onClose});

  @override
  State<TokenErrorWidget> createState() => _TokenErrorWidgetState();
}

class _TokenErrorWidgetState extends State<TokenErrorWidget> {
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
                    SvgPicture.asset(
                      "assets/ic_generic_error.svg",
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                        "Desculpe, não foi possível concluir ${_actionToString(widget.action)}.",
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.headline(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).primary())),
                    SizedBox(height: Dimens.spacing),
                    Text("Tente novamente mais tarde.",
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.subtitleBold(theme)),
                  ],
                ),
              ),
              PrimaryButton(
                text: "Voltar para aprovações pendentes",
                onPressed: () => widget.onClose(),
              ),
            ],
          )),
    );
  }

  _actionToString(PendencyApprovalAction action) {
    switch (action) {
      case PendencyApprovalAction.approve:
        return getString(context, 'payment_action_approval');
      case PendencyApprovalAction.reject:
        return getString(context, 'payment_action_cancellation');
      case PendencyApprovalAction.suspend:
        return getString(context, 'payment_action_suspension');
    }
  }
}
