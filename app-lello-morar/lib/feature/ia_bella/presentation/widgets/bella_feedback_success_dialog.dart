import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class BellaFeedbackSuccessDialog extends StatelessWidget {
  final VoidCallback onClose;

  const BellaFeedbackSuccessDialog({
    super.key,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iaName = FlavorConfig.config.iaName;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              child: SvgPicture.asset(
                "assets/ic_success_green.svg",
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getStringWithParams(
                context,
                'bella_feedback_success_message',
                [iaName],
              ),
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: onClose,
              text: "Fechar",
              buttonColor: LelloTheme.palleteOf(theme).primary(),
            ),
          ],
        ),
      ),
    );
  }
}
