import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';

class TimeoutDialog extends StatelessWidget {
  final Function() onPop;

  const TimeoutDialog({
    super.key,
    required this.onPop,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
                "assets/ic_timeout_error.svg",
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "timeout_dialog_title"),
              style: theme.textTheme.headlineLarge
                  ?.copyWith(color: theme.primaryColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            Text(
              getString(context, "timeout_dialog_message"),
              style: theme.textTheme.bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: onPop,
              text: getString(context, "timeout_dialog_back_to_details"),
              buttonColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
