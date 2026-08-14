import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';

class UpdateUnitDataPage extends StatelessWidget {
  const UpdateUnitDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Column(
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/ic_update_unit_data.svg',
                  alignment: Alignment.center,
                ),
              ),
              SizedBox(
                height: Dimens.spacing,
              ),
              Text(
                getString(context, "update_unit_data_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.titleSmallBold(theme)
                    ?.copyWith(color: LelloTheme.palleteOf(theme).primary()),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.spacing),
                child: Opacity(
                  opacity: 0.7,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: getString(
                              context, "update_unit_data_subtitle_part_1"),
                          style: LelloTextStyles.subtitle(theme),
                        ),
                        TextSpan(
                          text: getString(
                              context, "update_unit_data_subtitle_part_2"),
                          style: LelloTextStyles.subtitleBold(theme),
                        ),
                        TextSpan(
                          text: getString(
                              context, "update_unit_data_subtitle_part_3"),
                          style: LelloTextStyles.subtitle(theme),
                        ),
                        TextSpan(
                          text: getString(
                              context, "update_unit_data_subtitle_part_4"),
                          style: LelloTextStyles.subtitleBold(theme),
                        ),
                        TextSpan(
                          text: getString(
                              context, "update_unit_data_subtitle_part_5"),
                          style: LelloTextStyles.subtitle(theme),
                        ),
                        TextSpan(
                          text: getString(
                              context, "update_unit_data_subtitle_part_6"),
                          style: LelloTextStyles.subtitleBold(theme),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              Text(
                "${getString(context, "attention")}!",
                style: LelloTextStyles.subtitleBold(theme)
                    ?.copyWith(decoration: TextDecoration.underline),
              ),
              SizedBox(height: Dimens.spacingXSmall),
              Text(
                getString(context, "update_unit_data_warning"),
                style: LelloTextStyles.bodyBold(theme)?.copyWith(height: 1.5),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: Dimens.spacingXLarge),
              PrimaryButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    ApplicationRoute.changeAddress,
                  );
                },
                text: getString(context, "update_unit_data_primary_button"),
              ),
              SizedBox(height: Dimens.spacing),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    ApplicationRoute.preferencesZeroPaper,
                  );
                },
                child: Text(
                    getString(context, "update_unit_data_secondary_button")),
              )
            ],
          ),
        ),
      ),
    );
  }
}
