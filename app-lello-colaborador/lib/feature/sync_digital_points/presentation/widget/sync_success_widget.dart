import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class SyncSuccessWidget extends StatelessWidget {
  const SyncSuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/ic_success_gray.svg",
          height: 32.0,
          width: 32.0,
        ),
        SizedBox(height: Dimens.spacingMedium),
        Text(
          getString(context, "digital_point_sync_dialog_success"),
          textAlign: TextAlign.center,
          style: LelloTextStyles.subtitle(theme)?.copyWith(
            color: LelloTheme.palleteOf(theme).grey(),
          ),
        ),
        SizedBox(height: Dimens.spacing),
        InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            padding: EdgeInsets.all(Dimens.spacingSmall),
            child: Text(
              getString(context, "ok").toUpperCase(),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)
                  ?.copyWith(color: LelloTheme.palleteOf(theme).primary()),
            ),
          ),
        ),
      ],
    );
  }
}
