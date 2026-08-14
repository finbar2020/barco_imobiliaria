import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/widget/hex_color.dart';

class VerifyAppAndBiometricStatus extends StatelessWidget {
  final VoidCallback onPressed;
  final bool useApp;
  final bool hasBiometric;
  final bool hasBiometricRegistered;

  VerifyAppAndBiometricStatus({
    Key? key,
    required this.onPressed,
    required this.useApp,
    required this.hasBiometric,
    required this.hasBiometricRegistered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            useApp == true
                ? SvgPicture.asset("assets/ic_has_app.svg")
                : SvgPicture.asset("assets/ic_hasnt_app.svg"),
            SizedBox(width: Dimens.spacingXSmall),
            useApp == true
                ? Text(getString(context, "residents_has_app"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: LelloTextStyles.bodyBold(theme)!
                        .copyWith(color: LelloTheme.palleteOf(theme).success()))
                : Text(getString(context, "residents_hasnt_app"),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: LelloTextStyles.bodyBold(theme)!
                        .copyWith(color: HexColor("#989898"))),
          ],
        ),
        SizedBox(height: Dimens.spacing),
        if (hasBiometric)
          hasBiometricRegistered
              ? Row(
                  children: [
                    SvgPicture.asset("assets/ic_has_biometric.svg"),
                    SizedBox(width: Dimens.spacingXSmall),
                    Text(getString(context, "residents_registered_facial"),
                        style: LelloTextStyles.subBody(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).success())),
                  ],
                )
              : InkWell(
                  onTap: onPressed,
                  child: Text(
                    getString(context, "residents_send_biometric_invite"),
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: theme.primaryColor,
                      decorationColor: theme.primaryColor,
                    ),
                  ),
                ),
      ],
    );
  }
}
