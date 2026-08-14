import 'package:colaborador/core/app_connectivity/app_connectivity.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomeNotConnectedDialog {
  static show(BuildContext context) async {
    final AppConnectivity appConnectivity =
        ApplicationContainer.instance().resolve();
    await Future.delayed(const Duration(seconds: 3));
    (appConnectivity.checkConnectivity()).then((value) {
      if (!value) {
        showDialog(
          context: context,
          builder: (context) => const HomeNotConnectedDialogWidget(),
        );
      }
    });
  }
}

class HomeNotConnectedDialogWidget extends StatelessWidget {
  const HomeNotConnectedDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text("${getString(context, "attention")}!",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "home_not_connected_dialog_message_one"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingSmall),
            Text(getString(context, "home_not_connected_dialog_message_two"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).textLight())),
            SizedBox(height: Dimens.spacingLarge),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                getString(context, "ok"),
                style: LelloTextStyles.subBody(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).primary(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
