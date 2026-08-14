import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_my_requests/controller/comfort_my_request_controller.dart';

class ComfortRatingSuccessPageArgs {
  ComfortMyRequestsController comfortMyRequestsController;
  ComfortRatingSuccessPageArgs(this.comfortMyRequestsController);
}

class ComfortRatingSuccessPage extends StatelessWidget {
  const ComfortRatingSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ComfortRatingSuccessPageArgs;
    ComfortMyRequestsController comfortMyRequestsController =
        arguments.comfortMyRequestsController;
    return WillPopScope(
      onWillPop: () async {
        _onPop(comfortMyRequestsController);
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
                  Text(getString(context, "comfort_rate_success_title"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(getString(context, "comfort_rate_success_subtitle"),
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
                  getString(context, "comfort_rate_success_conclude"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {
                  _onPop(comfortMyRequestsController);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPop(ComfortMyRequestsController comfortMyRequestsController) {}
}
