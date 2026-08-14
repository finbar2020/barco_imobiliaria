import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_coupon_card.dart';
import 'package:shared_features/shared_features.dart';

class PartnerCouponsListView extends StatefulWidget {
  final ComfortPartner partner;
  final List<ComfortPartnerCoupon> coupons;
  final Function(ComfortPartner partner, {ComfortPartnerCoupon? coupon})
      onPressed;
  final SharedApplicationContainer applicationContainer;
  final Function(ComfortPartner partner, {ComfortPartnerCoupon? coupon})?
      onShowDialog;
  final Function(ComfortPartner partner, {ComfortPartnerCoupon? coupon})?
      onDialogDismissed;
  final Function()? onLifecyclePaused, onLifecycleResumed, onLifecycleDetached;
  final Function()? onGoToPartnerPage;
  final Function(ComfortPartner partner, ComfortPartnerCoupon? coupon)
      analyticsOptIn, analyticsLgpdAcessar, analyticsRedirectButton;

  const PartnerCouponsListView({
    Key? key,
    required this.partner,
    required this.coupons,
    required this.onPressed,
    required this.analyticsLgpdAcessar,
    required this.analyticsOptIn,
    required this.analyticsRedirectButton,
    this.onShowDialog,
    this.onDialogDismissed,
    this.onLifecyclePaused,
    this.onLifecycleResumed,
    this.onLifecycleDetached,
    this.onGoToPartnerPage,
    required this.applicationContainer,
  }) : super(key: key);

  @override
  State<PartnerCouponsListView> createState() => _PartnerCouponsListViewState();
}

class _PartnerCouponsListViewState extends State<PartnerCouponsListView>
    with WidgetsBindingObserver {
  List<ComfortPartnerCoupon> coupons = [];
  String? selectedCouponId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    coupons = widget.coupons;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        print("Resumed");
        break;
      case AppLifecycleState.detached:
        print("Detached");
        break;
      default:
        print("default");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (coupons.isEmpty) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Dimens.spacingMedium, vertical: Dimens.spacing),
          child: Container(
            height: PartnerCouponCard.cardHeight(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: coupons.length,
              itemBuilder: (context, index) {
                return PartnerCouponCard(
                  applicationContainer: widget.applicationContainer,
                  partner: widget.partner,
                  coupon: coupons[index],
                  onPressed: widget.onPressed,
                  onShowDialog: widget.onShowDialog!(widget.partner,
                          coupon: coupons[index]) ??
                      () {},
                  onDialogDismissed: widget.onDialogDismissed!(widget.partner,
                          coupon: coupons[index]) ??
                      () {},
                  onLifecyclePaused: widget.onLifecyclePaused ?? () {},
                  onLifecycleResumed: widget.onLifecycleResumed ?? () {},
                  onLifecycleDetached: widget.onLifecycleDetached ?? () {},
                  onGoToPartnerPage: widget.onGoToPartnerPage ?? () {},
                  analyticsLgpdAcessar: widget.analyticsLgpdAcessar,
                  analyticsRedirectButton: widget.analyticsRedirectButton,
                  analyticsOptIn: widget.analyticsOptIn,
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: Dimens.spacing);
              },
            ),
          ),
        ),
      ],
    );
  }
}
