import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SendPaymentExistentDocumentError extends StatefulWidget {
  final Function() onClose;
  const SendPaymentExistentDocumentError({super.key, required this.onClose});

  @override
  State<SendPaymentExistentDocumentError> createState() =>
      _SendPaymentExistentDocumentErrorState();
}

class _SendPaymentExistentDocumentErrorState
    extends State<SendPaymentExistentDocumentError> {
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
                    "assets/ic_existent_document_error.svg",
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_document_registered_error"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).greyDarker())),
                  SizedBox(height: Dimens.spacing),
                  Text(
                      getString(context, "payments_document_registered_notice"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitleBold(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_contact_consultant_notice"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)),
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
