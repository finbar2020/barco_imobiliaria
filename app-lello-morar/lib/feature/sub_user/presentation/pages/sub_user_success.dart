import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/app_review/app_review.dart';

import '../../../../core/dependency/application_container.dart';

import '../controllers/sub_user_controller.dart';

class SubUserSuccessPage extends StatefulWidget {
  const SubUserSuccessPage({Key? key}) : super(key: key);

  @override
  _SubUserSuccessPageState createState() => _SubUserSuccessPageState();
}

class _SubUserSuccessPageState extends State<SubUserSuccessPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Theme(
      data: theme,
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
                        color: LelloTheme.palleteOf(theme).customColor())),
                SizedBox(height: Dimens.spacingLarge),
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
                getString(context, "conclude"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                ApplicationContainer.instance()
                    .resolve<SubUserController>()
                    .getSubUsers();
                Navigator.pop(context);
                AppReview.call(context: context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
