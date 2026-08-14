import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SendPaymentGenericError extends StatefulWidget {
  final Function() onClose;
  final String? status;
  final String? errorMessage;
  const SendPaymentGenericError(
      {super.key, required this.onClose, this.status, this.errorMessage});

  @override
  State<SendPaymentGenericError> createState() =>
      _SendPaymentGenericErrorState();
}

class _SendPaymentGenericErrorState extends State<SendPaymentGenericError> {
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
                    "assets/ic_generic_error.svg",
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_submission_error"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).error())),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_try_later_prompt"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitleBold(theme)),
                  SizedBox(height: Dimens.spacingLarge),
                ],
              ),
            ),
            PrimaryButton(
              text: getString(context, "close"),
              onPressed: () => widget.onClose(),
            ),
          ],
        ));
  }
}
