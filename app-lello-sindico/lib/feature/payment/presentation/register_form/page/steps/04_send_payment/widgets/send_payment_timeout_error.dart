import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SendPaymentTimeoutError extends StatefulWidget {
  final Function() tryAgain;
  final Function() backToPayment;
  const SendPaymentTimeoutError(
      {super.key, required this.tryAgain, required this.backToPayment});

  @override
  State<SendPaymentTimeoutError> createState() =>
      _SendPaymentTimeoutErrorState();
}

class _SendPaymentTimeoutErrorState extends State<SendPaymentTimeoutError> {
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
                  SizedBox(
                    height: 200,
                    child: Lottie.asset(
                      "assets/timeout_animation.json",
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_delay_apology"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).greyDarker())),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_retry_or_return_prompt"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitleBold(theme)),
                ],
              ),
            ),
            PrimaryButton(
              text: getString(context, "payments_try_again"),
              onPressed: () => widget.tryAgain(),
            ),
            SizedBox(height: Dimens.spacing),
            InvertedPrimaryButton(
              text: getString(context, "payments_return_to_payment"),
              onPressed: () => widget.backToPayment(),
            ),
          ],
        ));
  }
}
