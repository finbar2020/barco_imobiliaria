import 'package:colaborador/core/app_review/app_review.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class MeEditSuccessPageArgs {
  final Function onConfirm;
  MeEditSuccessPageArgs({
    required this.onConfirm,
  });
}

class MeEditSuccessPage extends StatelessWidget {
  const MeEditSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    MeEditSuccessPageArgs arguments =
        ModalRoute.of(context)?.settings.arguments as MeEditSuccessPageArgs;
    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context),
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
                  Text(getString(context, "profile_update_success"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor(),
                      )),
                  SizedBox(height: Dimens.spacingLarge),
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
                  elevation: 0, backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "conclude"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                onPressed: () {
                  arguments.onConfirm();
                  _onWillPop(context);
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(BuildContext context) async {
    AppReview.call(context: context);
    return true;
  }
}
