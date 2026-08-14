import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';

import '../controller/accountability_detail_controller.dart';

class SendRecommendationErrorPage extends StatelessWidget {
  const SendRecommendationErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ApplicationContainer.instance()
        .resolve<AccountabilityDetailController>();
    final theme = Theme.of(context);
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
                SvgPicture.asset("assets/ic_warning.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                    getString(context,
                        "accountability_send_recommendation_failure_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!
                        .copyWith(color: Colors.white)),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                    getString(context,
                        "accountability_send_recommendation_failure_subtitle"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: Colors.white.withOpacity(0.8))),
                SizedBox(height: Dimens.spacingXLarge),
                Theme(
                  data: theme.copyWith(
                    textTheme: theme.textTheme.copyWith(
                      labelLarge: theme.textTheme.labelLarge
                          ?.copyWith(color: Colors.black),
                    ),
                  ),
                  child: PrimaryButton(
                    buttonColor: Colors.white,
                    text: getString(context, "try_again"),
                    onPressed: () async {
                      Navigator.pop(context);
                      await controller.approveRecommendation(
                        period: controller.period!.period,
                        condominiumId: controller.condominiumId!,
                      );
                      await controller.getAccountabilityList(
                        condominiumId: controller.condominiumId!,
                        periods: controller.period!,
                      );
                    },
                  ),
                ),
                SizedBox(height: Dimens.spacingMedium),
                SecondaryButton(
                    buttonBorderColor: Colors.white,
                    text: getString(context, "cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
