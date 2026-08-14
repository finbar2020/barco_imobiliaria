import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class MessageTimeoutDialog extends StatelessWidget {
  final Function() onReturnToMainPage;

  const MessageTimeoutDialog({
    super.key,
    required this.onReturnToMainPage,
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
              height: 200,
              child: SvgPicture.asset(
                "assets/ic_bella_timeout_error.svg",
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getStringWithParams(context, 'bella_timeout_title', [iaName]),
              style: theme.textTheme.headlineLarge
                  ?.copyWith(color: theme.primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              "Tente novamente mais tarde",
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: onReturnToMainPage,
              text: "Voltar para o início",
              buttonColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
