import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

class ComfortOfferCard extends StatelessWidget {
  final ComfortPartnerCoupon? coupon;
  final Function(ComfortPartnerCoupon coupon) onPressed;
  const ComfortOfferCard({
    Key? key,
    required this.coupon,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Builder(
      builder: (context) {
        if (coupon == null) {
          return Container();
        }
        return Container(
          width: 100,
          padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
          child: ElevatedButton(
            onPressed: () {
              onPressed(coupon!);
            },
            style: ElevatedButton.styleFrom(
              elevation: 8,
              backgroundColor: LelloTheme.palleteOf(theme).greyCard(),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              padding: EdgeInsets.all(Dimens.spacingSmall),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      coupon!.discountPercentage.toString(),
                      style: LelloTextStyles.titleBold(theme)?.copyWith(
                          color: LelloTheme.palleteOf(theme).purpleText()),
                    ),
                  ),
                ),
                SvgPicture.asset(
                  "assets/comfort_coupon.svg",
                  width: 50.0,
                  height: 38.0,
                ),
                SizedBox(height: Dimens.spacingSmall),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      coupon!.getComfortType(context).toUpperCase(),
                      style: LelloTextStyles.bodyBold(theme)
                          ?.copyWith(color: LelloTheme.palleteOf(theme).text()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
