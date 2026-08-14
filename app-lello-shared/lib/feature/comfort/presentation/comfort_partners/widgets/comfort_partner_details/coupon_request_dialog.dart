import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';

class CouponRequestDialog extends StatefulWidget {
  final ComfortPartner partner;
  final ComfortPartnerCoupon? coupon;
  final Function(ComfortPartner partner, {ComfortPartnerCoupon? coupon})
      onPressed;
  final Function()? onLifecycleResumed, onLifecyclePaused, onLifecycleDetached;
  final Function()? onGoToPartnerPage;
  final Function(ComfortPartner partner, ComfortPartnerCoupon? coupon)
      analyticsLgpdAcessar, analyticsRedirectButton, analyticsOptIn;

  CouponRequestDialog({
    Key? key,
    required this.onPressed,
    required this.partner,
    required this.coupon,
    this.onLifecycleResumed,
    this.onLifecyclePaused,
    this.onLifecycleDetached,
    this.onGoToPartnerPage,
    required this.analyticsLgpdAcessar,
    required this.analyticsRedirectButton,
    required this.analyticsOptIn,
  }) : super(key: key);

  @override
  State<CouponRequestDialog> createState() => _CouponRequestDialogState();
}

class _CouponRequestDialogState extends State<CouponRequestDialog>
    with WidgetsBindingObserver {
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onLifecycleResumed?.call();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        widget.onLifecyclePaused?.call();
        break;
      case AppLifecycleState.detached:
        widget.onLifecycleDetached?.call();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset(
                  "assets/comfort_ok.svg",
                  height: 40.0,
                  width: 40.0,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                "${getString(context, "comfort_get_coupon_almost_there")}!",
                textAlign: TextAlign.left,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              if (widget.coupon?.reusable == false)
                Text(
                  "${getString(context, "comfort_get_coupon_single_use")}",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).error(),
                  ),
                ),
              if (widget.coupon?.reusable == false)
                SizedBox(height: Dimens.spacing),
              Text(
                "${getString(context, widget.partner.cta == ComfortCTA.email ? "comfort_get_coupon_email_description_1" : "comfort_get_coupon_description_1")}",
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).textOpaque(),
                ),
              ),
              if (widget.partner.cta == ComfortCTA.email)
                Text(
                  "${getString(context, "comfort_get_coupon_email_description_2")}",
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).textOpaque(),
                  ),
                ),
              SizedBox(height: Dimens.spacing),
              if (widget.partner.cta != ComfortCTA.email)
                RichText(
                  textAlign: TextAlign.center,
                  text: new TextSpan(
                    style: LelloTextStyles.subtitle(theme),
                    children: <TextSpan>[
                      TextSpan(
                          text:
                              "${getString(context, "comfort_get_coupon_description_2")}",
                          style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).textOpaque())),
                      TextSpan(
                          text: getString(
                              context, "comfort_get_coupon_description_3"),
                          style: LelloTextStyles.subtitle(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).textOpaque())),
                    ],
                  ),
                ),
              SizedBox(height: Dimens.spacing),
              Row(
                children: [
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                        value: isChecked,
                        activeColor: theme.primaryColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(2))),
                        side: BorderSide(
                          width: 1.0,
                          color: LelloTheme.palleteOf(theme).separator(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            isChecked = value ?? false;
                          });
                          if (isChecked) {
                            widget.analyticsOptIn
                                .call(widget.partner, widget.coupon);
                          }
                        }),
                  ),
                  SizedBox(width: Dimens.spacingSmall),
                  Flexible(
                    child: InkWell(
                      onTap: () async {
                        widget.analyticsLgpdAcessar
                            .call(widget.partner, widget.coupon);
                        Launch.urlUri(context, UrlsUri.lgpd());
                      },
                      child: RichText(
                        text: TextSpan(
                          style: LelloTextStyles.body(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).textLightest(),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: getString(
                                  context, "comfort_get_coupon_lgpd_one"),
                            ),
                            TextSpan(
                              text: getString(
                                  context, "comfort_get_coupon_lgpd_two"),
                              style: LelloTextStyles.body(theme)!.copyWith(
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    LelloTheme.palleteOf(theme).textAccent(),
                                color: LelloTheme.palleteOf(theme).textAccent(),
                              ),
                            ),
                            TextSpan(
                              text: getString(
                                  context, "comfort_get_coupon_lgpd_three"),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacing),
              InkWell(
                onTap: () async {
                  widget.analyticsLgpdAcessar
                      .call(widget.partner, widget.coupon);
                  Launch.urlUri(context, UrlsUri.lgpd());
                },
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLightest(),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: getString(
                            context, "comfort_get_coupon_description_lgpd_1"),
                      ),
                      TextSpan(
                        text: getString(
                            context, "comfort_get_coupon_description_lgpd_2"),
                        style: LelloTextStyles.body(theme)!.copyWith(
                          decoration: TextDecoration.underline,
                          decorationColor: LelloTheme.palleteOf(theme).textAccent(),
                          color: LelloTheme.palleteOf(theme).textAccent(),
                        ),
                      ),
                      TextSpan(
                        text: getString(
                            context, "comfort_get_coupon_description_lgpd_3"),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingLarge),
              InkWell(
                onTap: () {
                  if (isChecked) {
                    widget.analyticsRedirectButton
                        .call(widget.partner, widget.coupon);
                    widget.onPressed(widget.partner, coupon: widget.coupon);
                    if (widget.partner.cta == ComfortCTA.link) {
                      widget.onGoToPartnerPage?.call();
                    }
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(Dimens.spacingSmall),
                  child: Text(
                    getString(
                        context,
                        widget.partner.cta == ComfortCTA.email
                            ? "comfort_request_email"
                            : "comfort_get_coupon_description_go"),
                    style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                      color: isChecked
                          ? theme.primaryColor
                          : LelloTheme.palleteOf(theme).separator(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimens.spacingSmall),
            ],
          ),
        ),
      ),
    );
  }
}
