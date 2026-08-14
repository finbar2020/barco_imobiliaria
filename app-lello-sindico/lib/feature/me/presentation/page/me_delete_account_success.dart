import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';

class MeDeleteAccountSuccessPage extends StatelessWidget {
  MeDeleteAccountSuccessPage({
    Key? key,
  }) : super(key: key);
  final MeController controller =
      ApplicationContainer.instance().resolve<MeController>();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          await controller.logout();
          return true;
        },
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).success(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_success.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text("Conta excluída com sucesso.",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor(),
                      )),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
              height: 54.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(
                      context, "accounttability_question_select_conclude"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                onPressed: () async {
                  Navigator.pop(context);
                  await controller.logout();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
