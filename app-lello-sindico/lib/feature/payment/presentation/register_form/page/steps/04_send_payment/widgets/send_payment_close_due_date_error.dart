import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SendPamentCloseDueDateError extends StatefulWidget {
  final Function() onClose;
  const SendPamentCloseDueDateError({super.key, required this.onClose});

  @override
  State<SendPamentCloseDueDateError> createState() =>
      _SendPamentCloseDueDateErrorState();
}

class _SendPamentCloseDueDateErrorState
    extends State<SendPamentCloseDueDateError> {
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
                    "assets/ic_due_date_error.svg",
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_due_documents_label"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).greyDarker())),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_document_due_error"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitleBold(theme)),
                  SizedBox(height: Dimens.spacing),
                  Text(getString(context, "payments_due_deadline_error"),
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
