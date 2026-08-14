import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';
import 'package:shared_features/shared_features.dart';

class PartnerIntroWidget extends StatelessWidget {
  const PartnerIntroWidget({
    Key? key,
    required this.changeFavoriteStatus,
    required this.partnerIntro,
    required this.applicationContainer,
  }) : super(key: key);

  final ComfortPartnerIntro partnerIntro;
  final Function(String partnerId, String partnerName, bool isFavorite)
      changeFavoriteStatus;
  final SharedApplicationContainer applicationContainer;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
              Dimens.spacingMedium, Dimens.spacingMedium, 0, 0),
          child: Container(
            height: 60.0,
            width: 60.0,
            child: CustomCachedNetworkImage(
                applicationContainer: applicationContainer,
                link: partnerIntro.partnerImageLink),
          ),
        ),
        SizedBox(width: 12.0),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              top: Dimens.spacingMedium,
              bottom: Dimens.spacingMedium,
              right: Dimens.spacingMedium,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  partnerIntro.getComfortType(context),
                  style: LelloTextStyles.subtitle(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Text(
                  partnerIntro.title,
                  style: LelloTextStyles.subtitleBold(theme)
                      ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
              ],
            ),
          ),
        ),
        //TODO: NÃO REMOVER TOTALMENTE POIS PODE SER NECESSÁRIO NO FUTURO
        // PartnerFavoriteStatusWidget(
        //     onTap: changeFavoriteStatus, partnerIntro: partnerIntro),
      ],
    );
  }
}
