import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_dialog.dart';
import 'package:shared_features/shared_features.dart';

class PartnerCouponCard extends StatelessWidget {
  final ComfortPartner partner;
  final ComfortPartnerCoupon? coupon;
  final SharedApplicationContainer applicationContainer;
  final Function(ComfortPartner partner, {ComfortPartnerCoupon? coupon})
      onPressed;
  final Function() onShowDialog;
  final Function() onDialogDismissed;
  final Function()? onLifecyclePaused, onLifecycleResumed, onLifecycleDetached;
  final Function()? onGoToPartnerPage;
  final Function(ComfortPartner partner, ComfortPartnerCoupon? coupon) analyticsLgpdAcessar, analyticsRedirectButton, analyticsOptIn;
  
  const PartnerCouponCard({
    Key? key,
    required this.partner,
    required this.coupon,
    required this.onPressed,
    required this.onShowDialog,
    required this.onDialogDismissed,
    required this.applicationContainer,
    required this.analyticsLgpdAcessar,
    required this.analyticsRedirectButton,
    required this.analyticsOptIn,
    this.onLifecyclePaused,
    this.onLifecycleResumed,
    this.onLifecycleDetached,
    this.onGoToPartnerPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return coupon != null
        ? Container(
            height: cardHeight(),
            width: cardWidth(),
            child: Material(
              elevation: Dimens.spacingSmall,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  Positioned.fill(
                    bottom: 0.0,
                    child: Column(
                      children: [
                        Container(
                          width: cardWidth(),
                          height: Dimens.spacingLarge,
                          padding: EdgeInsets.symmetric(
                              horizontal: Dimens.spacingSmall),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              coupon!.title.toUpperCase(),
                              textScaleFactor: 1.0,
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.bodyBold(theme)
                                  ?.copyWith(color: theme.primaryColor),
                            ),
                          ),
                          alignment: Alignment.center,
                        ),
                        Container(
                          width: cardWidth(),
                          height: cardHeight() - Dimens.spacingLarge,
                          child: CustomCachedNetworkImage(
                            padding: EdgeInsets.all(0),
                            fit: BoxFit.contain,
                            applicationContainer: applicationContainer,
                            link: coupon!.imageLink,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                      child: new Material(
                          color: Colors.transparent,
                          child: new InkWell(
                            onTap: () {
                              onShowDialog();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return CouponRequestDialog(
                                    partner: partner,
                                    coupon: coupon!,
                                    onPressed: onPressed,
                                    onLifecyclePaused: onLifecyclePaused,
                                    onLifecycleResumed: onLifecycleResumed,
                                    onLifecycleDetached: onLifecycleDetached,
                                    onGoToPartnerPage: onGoToPartnerPage,
                                    analyticsLgpdAcessar: analyticsLgpdAcessar,
                                    analyticsRedirectButton: analyticsRedirectButton,
                                    analyticsOptIn: analyticsOptIn,
                                  );
                                },
                              ).then((_) => onDialogDismissed());
                            },
                          ))),
                ],
              ),
            ),
          )
        : Container();
  }

  static double cardHeight() => 140.0 + Dimens.spacingLarge;
  static double cardWidth() => 140.0;
}
