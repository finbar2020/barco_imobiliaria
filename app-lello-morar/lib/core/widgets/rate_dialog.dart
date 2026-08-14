import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class RateDialog extends StatelessWidget {
  const RateDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_rate_app.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, "rate_dialog_title"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: theme.primaryColor,
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              getString(context, "rate_dialog_subtitle"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subBody(theme),
            ),
            SizedBox(height: Dimens.spacing),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => index == 4
                      ? Icon(
                          Icons.star,
                          color: theme.primaryColor,
                        )
                      : Padding(
                          padding: const EdgeInsets.only(right: 13.0),
                          child: Icon(
                            Icons.star,
                            color: theme.primaryColor,
                          ),
                        ),
                )),
            SizedBox(height: Dimens.spacingMedium),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "rate_dialog_button"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {},
              ),
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: LelloTheme.palleteOf(theme).textOpaque(),
                      ),
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "rate_dialog_second_button"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: theme.primaryColor),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
