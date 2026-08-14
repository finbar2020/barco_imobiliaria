import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_full_janitor_gdp_card.dart';
import 'package:lello/feature/staff_access_management/presentation/widget/access_profiles_info_dialog_cards/access_profiles_limited_janitor_card.dart';

import 'access_profiles_info_dialog_cards/access_profiles_full_janitor_card.dart';
import 'access_profiles_info_dialog_cards/access_profiles_full_manager_card.dart';
import 'access_profiles_info_dialog_cards/access_profiles_limited_manager_card.dart';

class AccessProfilesInfoDialog extends StatefulWidget {
  const AccessProfilesInfoDialog({super.key});

  @override
  State<AccessProfilesInfoDialog> createState() =>
      _AccessProfilesInfoDialogState();
}

class _AccessProfilesInfoDialogState extends State<AccessProfilesInfoDialog> {
  @override
  Widget build(BuildContext context) {
    final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();

    final theme = Theme.of(context);
    return Dialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: Dimens.spacing,
        vertical: Dimens.spacingMedium,
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: Dimens.spacingLarge,
          vertical: Dimens.spacingLarge,
        ),
        child: Column(
          children: [
            Icon(
              Icons.info_outline,
              color: LelloTheme.palleteOf(theme).primary(),
              size: 40,
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, "access_profile_title"),
              style: LelloTextStyles.titleSmallBold(theme)?.copyWith(
                color: LelloTheme.palleteOf(theme).primary(),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
              child: Text(
                getString(context, "access_profile_subtitle"),
                style: LelloTextStyles.subtitle(theme),
              ),
            ),
            SizedBox(height: Dimens.spacingMedium),
            const FullManagerCard(),
            SizedBox(height: Dimens.spacing),
            const LimitedManagerCard(),
            SizedBox(height: Dimens.spacing),
            if (sessionBloc.getRemoteConfig()?.getBool(
                    CustomFirebaseRemoteConfig
                        .showAccessProfileJanitorWithGDP) ??
                false)
              Column(
                children: [
                  const FullJanitorWithGdpCard(),
                  SizedBox(height: Dimens.spacing),
                ],
              ),
            const FullJanitorCard(),
            SizedBox(height: Dimens.spacing),
            const LimitedJanitorCard(),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              children: [
                const Spacer(flex: 2),
                Expanded(
                  flex: 2,
                  child: PrimaryButton(
                    height: 50,
                    onPressed: () => Navigator.pop(context),
                    text: "OK",
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
