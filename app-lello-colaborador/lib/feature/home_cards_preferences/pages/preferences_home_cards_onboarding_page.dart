import 'package:colaborador/feature/home_cards_preferences/controller/preferences_home_cards_controller.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class PreferencesHomeCardsOnboardingPage extends StatelessWidget {
  final PreferencesHomeCardsController controller;
  const PreferencesHomeCardsOnboardingPage({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: theme.primaryColor,
            onPressed: () {
              Navigator.popUntil(
                  context, ModalRoute.withName(SharedApplicationRoute.home));
            },
          ),
        ),
        title: Text(
          "",
          style: LelloTextStyles.titleSmall(theme)!
              .copyWith(color: LelloTheme.palleteOf(theme).hubText()),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                      "assets/img_preferences_cards_onboarding.svg"),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    getString(context, "preferences_cards_onboarding_title"),
                    style: LelloTextStyles.titleSmallBold(theme),
                  ),
                  SizedBox(height: Dimens.spacing),
                  Text(
                    getString(context, "preferences_cards_onboarding_subtitle"),
                    style: LelloTextStyles.body(theme),
                  ),
                ],
              ),
            ),
            PrimaryButton(
                text: getString(context, "preferences_cards_onboarding_btn"),
                onPressed: () {
                  controller.getCards(context);
                  Navigator.pop(context);
                })
          ],
        ),
      ),
    );
  }
}
