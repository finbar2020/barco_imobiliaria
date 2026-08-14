import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HubButton extends StatelessWidget {
  final String title;
  final Widget icon;
  final bool isEnabled;
  final VoidCallback? onPressed;
  final Widget? comingSoonBadge;

  HubButton(
      {Key? key,
      required this.title,
      required this.icon,
      this.comingSoonBadge,
      this.onPressed,
      this.isEnabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Material(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            side: BorderSide(color: pallete.separator(), width: 1)),
        child: InkWell(
          onTap: isEnabled
              ? () {
                  if (onPressed != null) {
                    onPressed!();
                  }
                }
              : null,
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    icon,
                    Padding(
                      padding: EdgeInsets.only(bottom: Dimens.spacing),
                      child: comingSoonBadge ?? Container(),
                    )
                  ],
                ),
                SizedBox(height: Dimens.spacingXSmall),
                Text(
                  title,
                  style: LelloTextStyles.subtitleBold(theme)!
                      .copyWith(color: pallete.hubText()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
