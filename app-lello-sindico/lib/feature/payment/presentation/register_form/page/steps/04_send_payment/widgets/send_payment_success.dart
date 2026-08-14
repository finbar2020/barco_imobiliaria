import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SendPaymentSuccess extends StatefulWidget {
  final int processNumber;
  final Function() sendAnotherPayment;
  final Function() onClose;
  const SendPaymentSuccess(
      {super.key,
      required this.onClose,
      required this.processNumber,
      required this.sendAnotherPayment});

  @override
  State<SendPaymentSuccess> createState() => _SendPaymentSuccessState();
}

class _SendPaymentSuccessState extends State<SendPaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/ic_success_payment.svg",
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_success_notice"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).primary())),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_receipt_number_label"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitleBold(theme)),
                  SizedBox(height: Dimens.spacingLarge),
                  Text("${widget.processNumber}",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.title(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_tracking_notice"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)),
                ],
              ),
            ),
            PrimaryButton(
              text: getString(context, "payments_send_another"),
              onPressed: () => widget.sendAnotherPayment(),
            ),
            SizedBox(height: Dimens.spacing),
            InvertedPrimaryButton(
              onPressed: () => widget.onClose(),
              text: getString(context, "close"),
            ),
          ],
        ));
  }
}
