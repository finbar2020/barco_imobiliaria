import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/best_offers_list_view/comfort_offer_card.dart';

class ComfortBestOffersListView extends StatelessWidget {
  final List<ComfortPartnerCoupon?> coupons;
  final Function(ComfortPartnerCoupon coupon) onPressed;
  const ComfortBestOffersListView({
    Key? key,
    required this.coupons,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Builder(
      builder: (context) {
        if (coupons.isEmpty) {
          return Container();
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(Dimens.spacingMedium,
                  Dimens.spacingMedium, Dimens.spacingMedium, 0),
              child: Text(
                getString(context, "comfort_top_offers"),
                style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                  color: LelloTheme.palleteOf(theme).purpleText(),
                ),
              ),
            ),
            SizedBox(
              height: 150,
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                itemCount: coupons.length,
                itemBuilder: (context, index) {
                  return ComfortOfferCard(
                    coupon: coupons[index],
                    onPressed: onPressed,
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(width: Dimens.spacing);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
