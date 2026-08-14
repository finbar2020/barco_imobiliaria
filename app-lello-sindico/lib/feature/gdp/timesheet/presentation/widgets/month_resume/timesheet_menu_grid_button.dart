import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TimesheetMenuGridButton extends StatelessWidget {
  final String value;
  final String title;
  final VoidCallback onPressed;
  const TimesheetMenuGridButton({
    super.key,
    required this.value,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);
    return Material(
      elevation: 5.0,
      color: value == '0' ? const Color(0xFFC4C4C4) : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          side: BorderSide(
              color:
                  value == '0' ? const Color(0xFFC4C4C4) : theme.primaryColor,
              width: 1)),
      child: InkWell(
        onTap: value == '0' ? null : onPressed,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
              Dimens.spacing, Dimens.spacing, Dimens.spacing, Dimens.spacing),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: LelloTextStyles.subtitleBold(theme),
                  children: <TextSpan>[
                    TextSpan(
                        text: value,
                        style: LelloTextStyles.title(theme)!.copyWith(
                            color: value == '0'
                                ? pallete.hubText()
                                : theme.primaryColor)),
                  ],
                ),
              ),
              Text(
                title,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                    color:
                        value == '0' ? pallete.hubText() : theme.primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
