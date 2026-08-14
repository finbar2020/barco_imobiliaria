import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AgreementOptionsCard extends StatelessWidget {
  final bool check;
  final String? icon;
  final String title;
  final bool simpleText;
  final String subtitle;
  final Function(bool?) onChanged;
  final bool enabled;
  const AgreementOptionsCard({
    Key? key,
    required this.check,
    required this.onChanged,
    required this.title,
    this.subtitle = "",
    this.simpleText = false,
    this.icon,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.light;
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Container(
        height: 87.0,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: LelloTheme.palleteOf(theme).separator()),
            color: enabled ? null : Colors.grey.shade200),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: Checkbox(
                activeColor: theme.primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                side: BorderSide(
                  width: 1.0,
                  color: LelloTheme.palleteOf(theme).separator(),
                ),
                value: check,
                onChanged: onChanged,
              ),
            ),
            if (icon != null) SizedBox(width: Dimens.spacing),
            if (icon != null) SvgPicture.asset(icon!),
            SizedBox(width: Dimens.spacing),
            if (!simpleText)
              Flexible(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(getString(context, title),
                          style: LelloTextStyles.subtitle(theme)),
                      Text("[$subtitle]",
                          style: LelloTextStyles.subtitle(theme)),
                    ],
                  ),
                ),
              ),
            if (simpleText) Text(title, style: LelloTextStyles.subtitle(theme))
          ],
        ),
      ),
    );
  }
}
