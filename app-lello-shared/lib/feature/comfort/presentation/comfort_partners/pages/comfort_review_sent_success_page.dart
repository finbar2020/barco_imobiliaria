import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';

class ComfortReviewSentSuccessPageArgs {
  ComfortPartnersController comfortPartnersController;
  ComfortReviewSentSuccessPageArgs(this.comfortPartnersController);
}

class ComfortReviewSentSuccessPage extends StatelessWidget {
  const ComfortReviewSentSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ComfortReviewSentSuccessPageArgs;
    ComfortPartnersController comfortPartnersController =
        arguments.comfortPartnersController;
    return WillPopScope(
      onWillPop: () async {
        _onPop(comfortPartnersController);
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).success(),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacingXLarge),
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
                  _onPop(comfortPartnersController);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onPop(ComfortPartnersController comfortPartnersController) {
    comfortPartnersController
        .getAllPartners(ComfortPageOriginEnum.reviewSentSuccessPage);
  }
}
