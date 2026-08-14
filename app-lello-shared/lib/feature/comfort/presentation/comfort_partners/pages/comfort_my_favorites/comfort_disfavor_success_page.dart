import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';

class ComfortDisfavorSuccessPageArgs {
  ComfortPartnersController comfortPartnersController;
  ComfortPartner partner;
  ComfortDisfavorSuccessPageArgs(this.comfortPartnersController, this.partner);
}

class ComfortDisfavorSuccessPage extends StatelessWidget {
  const ComfortDisfavorSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)?.settings.arguments
        as ComfortDisfavorSuccessPageArgs;
    ComfortPartnersController comfortPartnersController =
        arguments.comfortPartnersController;
    ComfortPartner partner = arguments.partner;
    return WillPopScope(
      onWillPop: () async {
        _onPop(comfortPartnersController);
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
                  Text(
                      getString(context, "comfort_disfavor_complete")
                          .replaceAll("###", partner.partnerIntro.title),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor())),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
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
                  getString(context, "comfort_disfavor_conclude"),
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
    comfortPartnersController.backToLoadedComfortPartnersState(
        ComfortPageOriginEnum.disfavorSuccessPage);
  }
}
