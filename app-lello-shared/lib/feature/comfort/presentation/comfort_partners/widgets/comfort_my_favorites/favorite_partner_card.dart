import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_my_favorites/disfavor_partner_dialog.dart';
import 'package:shared_features/shared_features.dart';

class FavoritePartnerCard extends StatelessWidget {
  const FavoritePartnerCard({
    Key? key,
    required this.partner,
    required this.onPartnerSelectFunction,
    required this.disfavorPartnerFunction,
    required this.applicationContainer,
  }) : super(key: key);

  final ComfortPartner partner;
  final Function(ComfortPartner partner) onPartnerSelectFunction;
  final Function(ComfortPartner partner) disfavorPartnerFunction;
  final SharedApplicationContainer applicationContainer;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 8,
        backgroundColor: LelloTheme.palleteOf(theme).greyCard(),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.all(Dimens.spacingSmall),
      ),
      onPressed: () {
        onPartnerSelectFunction(partner);
      },
      child: Container(
        height: 300,
        padding: EdgeInsets.all(Dimens.spacingSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: LelloTheme.palleteOf(theme).greyCard(),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Dimens.spacingSmall),
            Expanded(
              flex: 3,
              child: CustomCachedNetworkImage(
                  applicationContainer: applicationContainer,
                  link: partner.partnerIntro.partnerImageLink),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Expanded(
              flex: 1,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  partner.partnerIntro.title,
                  style: LelloTextStyles.subtitleBold(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).grey()),
                ),
              ),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Expanded(
              flex: 2,
              child: disfavorPartnerButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Container disfavorPartnerButton(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.all(Dimens.spacingSmall),
      child: SecondaryButton(
          buttonBorderColor: theme.primaryColor,
          child: Container(
            child: Row(children: [
              SvgPicture.asset(
                "assets/ic_comfort_heart.svg",
                color: theme.primaryColor,
              ),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(getString(context, "comfort_disfavor_partner")),
                ),
              ),
            ]),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => DisfavorPartnerDialog(
                applicationContainer: applicationContainer,
                partner: partner,
                disfavorPartnerFunction: disfavorPartnerFunction,
              ),
            );
          }),
    );
  }
}
