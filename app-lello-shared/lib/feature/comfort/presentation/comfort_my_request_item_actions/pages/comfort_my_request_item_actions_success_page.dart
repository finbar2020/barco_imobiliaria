import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_request_item_actions/controller/comfort_my_request_item_actions_controller.dart';

class ComfortMyRequestItemActionsSuccessPage extends StatelessWidget {
  final ComfortMyRequestItemActions action;
  final String conoName;

  const ComfortMyRequestItemActionsSuccessPage(
      {Key? key, required this.action, required this.conoName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).success(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingXLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_success.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(getString(context, _getTitle(action)),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(conoName,
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(getString(context, _getSubTitle(action)),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.spacingMedium,
                vertical: Dimens.spacingLarge),
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
                  getString(context, "ok"),
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

  String _getTitle(ComfortMyRequestItemActions action) {
    switch (action) {
      case ComfortMyRequestItemActions.cancel:
        return "comfort_request_actions_cancel_success_title";
      case ComfortMyRequestItemActions.resend:
        return "comfort_request_actions_resend_success_title";
      case ComfortMyRequestItemActions.message:
        return "comfort_request_actions_message_success_title";
      default:
        return "";
    }
  }

  String _getSubTitle(ComfortMyRequestItemActions action) {
    switch (action) {
      case ComfortMyRequestItemActions.cancel:
        return "comfort_request_actions_cancel_success_subtitle";
      case ComfortMyRequestItemActions.resend:
        return "comfort_request_actions_resend_success_subtitle";
      case ComfortMyRequestItemActions.message:
        return "comfort_request_actions_message_success_subtitle";
      default:
        return "";
    }
  }
}
