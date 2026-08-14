import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ResinConfirmationDialog extends StatelessWidget {
  final Function() confirmationFunction;
  final String title;
  final String subtitle;
  const ResinConfirmationDialog({
    Key? key,
    this.title = "",
    this.subtitle = "",
    required this.confirmationFunction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title.isNotEmpty)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(Dimens.spacing),
                child: Text(
                  title,
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            if (subtitle.isNotEmpty)
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(Dimens.spacing),
                child: Text(
                  subtitle,
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              ),
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimens.spacingSmall, horizontal: Dimens.spacingLarge),
      child: Column(
        children: [
          PrimaryButton(
            height: 32.0,
            onPressed: () {
              confirmationFunction();
              Navigator.pop(context);
            },
            text: getString(context, "confirm"),
          ),
          SizedBox(height: Dimens.spacingSmall),
          SecondaryButton(
            height: 32.0,
            onPressed: () {
              Navigator.pop(context);
            },
            buttonBorderColor: Colors.white,
            child: Text(getString(context, "back")),
          ),
        ],
      ),
    );
  }
}
