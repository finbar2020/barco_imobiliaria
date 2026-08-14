import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_intro.dart';

class PartnerContactWidget extends StatelessWidget {
  const PartnerContactWidget({
    Key? key,
    required this.partnerIntro,
  }) : super(key: key);

  final ComfortPartnerIntro partnerIntro;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
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
    );
  }
}
