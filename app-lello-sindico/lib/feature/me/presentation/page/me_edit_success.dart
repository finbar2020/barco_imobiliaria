import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/app_review/app_review.dart';

import '../../../../core/dependency/application_container.dart';
import '../../../../core/navigation/application_route.dart';
import '../controller/me_controller.dart';

class MeEditSuccessPage extends StatelessWidget {
  const MeEditSuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MeController controller =
        ApplicationContainer.instance().resolve<MeController>();

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
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                        labelLarge: theme.textTheme.labelLarge
                            ?.copyWith(color: Colors.black)),
                  ),
                  child: PrimaryButton(
                      buttonColor: Colors.white,
                      text: getString(context, "close"),
                      onPressed: () {
                        Navigator.popUntil(
                            context, ModalRoute.withName(ApplicationRoute.me));
                        controller.getMe(forceUpdate: false);
                        AppReview.call(context: context);
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
