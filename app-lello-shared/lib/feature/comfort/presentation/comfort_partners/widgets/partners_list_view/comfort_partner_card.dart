import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnerCard extends StatelessWidget {
  final ComfortPartner? partner;
  final SharedApplicationContainer applicationContainer;
  final Function(ComfortPartner partner) onPressed;
  final bool showCardDetailsButton;
  const ComfortPartnerCard({
    Key? key,
    required this.partner,
    required this.onPressed,
    required this.applicationContainer,
    this.showCardDetailsButton = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return partner != null
        ? Container(
            padding: EdgeInsets.symmetric(vertical: Dimens.spacing),
            width: showCardDetailsButton ? null : cardWidth(),
            child: ElevatedButton(
              onPressed: () {
                onPressed(partner!);
              },
              style: ElevatedButton.styleFrom(
                elevation: 8,
                backgroundColor: LelloTheme.palleteOf(theme).greyCard(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                padding: EdgeInsets.all(Dimens.spacingSmall),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      height: 48.0,
                      width: 48.0,
                      child: CustomCachedNetworkImage(
                          applicationContainer: applicationContainer,
                          link: partner!.partnerIntro.partnerImageLink)),
                  SizedBox(height: Dimens.spacingSmall),
                  Expanded(
                    flex: 2,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        partner!.partnerIntro.title,
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).grey()),
                      ),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingXSmall),
                  Expanded(
                    flex: 3,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        _getPartnerSubtitle(context),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.bodyBold(theme)?.copyWith(
                            color: LelloTheme.palleteOf(theme).text()),
                      ),
                    ),
                  ),
                  if (showCardDetailsButton)
                    SizedBox(height: Dimens.spacingXSmall),
                  if (showCardDetailsButton)
                    Expanded(
                      flex: 3,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                          side: BorderSide(
                              width: 1.3,
                              color: LelloTheme.palleteOf(theme).primary()),
                        ),
                        child: Text(
                          getString(context, "details"),
                          style: LelloTextStyles.button(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).primary()),
                        ),
                        onPressed: () {
                          onPressed(partner!);
                        },
                      ),
                    ),
                ],
              ),
            ),
          )
        : Container();
  }

  String _getPartnerSubtitle(BuildContext context) {
    String discount = "";
    if (partner?.biggestDiscountPercentage != null &&
        partner?.biggestDiscountPercentage != 0) {
      discount = (getString(context, "comfort_discount_of_up"))
          .replaceAll("###", "${partner!.biggestDiscountPercentage}");
    }

    String comfortType = partner?.partnerIntro.getComfortType(context) ?? "";
    return discount.isNotEmpty ? "$comfortType\n$discount" : "$comfortType";
  }

  static double cardHeight() => 178.0;
  static double cardWidth() => 104.0;
}
