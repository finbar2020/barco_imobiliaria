import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class ReservationTermResponsabilityDialog extends StatelessWidget {
  final String term;
  const ReservationTermResponsabilityDialog({Key? key, required this.term})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
        child: Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: SingleChildScrollView(
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                getString(context, "space_registration_usage_term"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                term,
                textAlign: TextAlign.center,
                style: LelloTextStyles.body(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              TertiaryButton(
                  text: getString(context, "ok").toUpperCase(),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ]),
      ),
    ));
  }
}
