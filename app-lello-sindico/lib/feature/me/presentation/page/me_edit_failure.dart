import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/dependency/application_container.dart';
import '../../../../core/navigation/application_route.dart';
import '../controller/me_controller.dart';

class MeEditFailurePage extends StatelessWidget {
  const MeEditFailurePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final MeController controller =
        ApplicationContainer.instance().resolve<MeController>();
    return Theme(
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
                SvgPicture.asset("assets/ic_error.svg", width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "registration_failed_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingXSmall),
                Text(getString(context, "profile_update_failed_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingMedium),
                SecondaryButton(
                    buttonBorderColor: Colors.white,
                    text: getString(context, "back"),
                    onPressed: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(ApplicationRoute.me));
                      controller.getMe(forceUpdate: false);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
