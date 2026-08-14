import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({
    Key? key,
    required this.title,
    required this.theme,
    required this.isGeneric,
  }) : super(key: key);

  final ThemeData theme;
  final String title;
  final bool isGeneric;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              changeLelloForCompanyName(context, title),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subBody(theme),
            ),
            SizedBox(height: Dimens.spacingMedium),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  getString(context, "ok"),
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String changeLelloForCompanyName(BuildContext context, String getText) {
    if (isGeneric) {
      var textFormatted = getString(context, title);
      if (textFormatted.isNotEmpty) {
        return textFormatted.replaceAll("Lello", "");
      } else {
        return getString(context, title);
      }
    } else {
      return getString(context, title);
    }
  }
}
