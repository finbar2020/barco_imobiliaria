import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class CircuitBreakerModalDisableMessager extends StatelessWidget {
  final String? title;
  final String? message;

  CircuitBreakerModalDisableMessager({
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacing),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.spacing),
            Center(
              child: SvgPicture.asset(
                "assets/ic_attention.svg",
                color: LelloTheme.palleteOf(theme).textLightest(),
                height: 70.0,
                width: 70.0,
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              title ?? "${getString(context, "circuit_breaker_widget_title")}!",
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              message ??
                  "${getString(context, "circuit_breaker_default_message")}",
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).text(),
              ),
            ),
            SizedBox(height: Dimens.spacingLarge),
            SecondaryButton(
              buttonBorderColor: LelloTheme.palleteOf(theme).accent(),
              text: getString(context, "circuit_breaker_widget_close"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: Dimens.spacingXLarge),
          ],
        ),
      ),
    );
  }
}
