import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AccessManagementFacialBiometricErrorPage extends StatefulWidget {
  final String? message;
  final String? code;
  const AccessManagementFacialBiometricErrorPage({
    Key? key,
    this.message,
    this.code,
  }) : super(key: key);

  @override
  State<AccessManagementFacialBiometricErrorPage> createState() =>
      _AccessManagementFacialBiometricErrorPageState();
}

class _AccessManagementFacialBiometricErrorPageState
    extends State<AccessManagementFacialBiometricErrorPage> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).warning(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: SizedBox(height: 100.0)),
                  SvgPicture.asset("assets/ic_blocked_info.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, "facial_biometric_error_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor()),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Expanded(
                    child: Text(
                      widget.message ??
                          getString(context, "facial_biometric_error_subtitle"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor()),
                    ),
                  ),
                  if (widget.code != null)
                    SizedBox(height: Dimens.spacingSmall),
                  if (widget.code != null)
                    Text(
                      "code: ${widget.code!}",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          fontSize: 8,
                          color: LelloTheme.palleteOf(theme).customColor()),
                    ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 54.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "try_again"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
