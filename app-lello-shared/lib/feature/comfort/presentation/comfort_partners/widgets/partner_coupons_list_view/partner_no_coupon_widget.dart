import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

class PartnerNoCouponWidget extends StatelessWidget {
  final ComfortPartner partner;
  final Function(ComfortPartner partner, {ComfortPartnerCoupon? coupon})
      onPressed;

  const PartnerNoCouponWidget({
    Key? key,
    required this.partner,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: LelloTheme.palleteOf(theme).greyCard(),
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Column(children: [
          Text(
            getString(context, "comfort_partner_no_coupon"),
            textAlign: TextAlign.center,
            style: LelloTextStyles.subtitleBold(theme)
                ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
          ),
          SizedBox(height: Dimens.spacingMedium),
          if (partner.site.isNotEmpty)
            PrimaryButton(
                child: Text(getString(context, "comfort_go_to_partner_page"),
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.button(theme)?.copyWith(
                        color: LelloTheme.palleteOf(theme).background())),
                text: getString(context, "comfort_go_to_partner_page"),
                onPressed: () async {
                  onPressed(partner);
                })
        ]),
      ),
    );
  }
}
