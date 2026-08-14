import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/widgets/custom_app_bar.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_coupon_request.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_cta_enum.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_request_purchase.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partner_reviews/pages/comfort_partner_reviews_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partner_coupons_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_review_sent_success_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/coupon_request_result_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_details/partner_general_rating_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_coupons_list_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partner_coupons_list_view/partner_no_coupon_widget.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/review_request_dialog.dart';
import 'package:shared_features/feature/comfort/presentation/widgets/partner_info_widget.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';
import 'package:shared_features/shared_features.dart';

class ComfortPartnerPageArgs {
  ComfortPartnersController comfortPartnersController;
  String reference;
  String? unit;
  AppOriginEnum appOriginEnum;
  SharedApplicationContainer applicationContainer;
  ComfortPartnerPageArgs({
    required this.comfortPartnersController,
    required this.reference,
    this.unit,
    required this.appOriginEnum,
    required this.applicationContainer,
  });
}

class ComfortPartnerPage extends StatefulWidget {
  const ComfortPartnerPage({Key? key}) : super(key: key);

  @override
  _ComfortPartnerPageState createState() => _ComfortPartnerPageState();
}

class _ComfortPartnerPageState extends State<ComfortPartnerPage>
    with WidgetsBindingObserver {
  late ComfortPartnersController comfortPartnersController;
  String? selectedRequestId;
  bool dialogAlreadyShown = false;

  late String referece;
  late String? unit;
  late AppOriginEnum appOriginEnum;
  late SharedApplicationContainer applicationContainer;
  late ComfortPartnerPageArgs arguments;
  bool _didInitializedArgs = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_didInitializedArgs) {
      arguments =
          ModalRoute.of(context)?.settings.arguments as ComfortPartnerPageArgs;
      comfortPartnersController = arguments.comfortPartnersController;
      referece = arguments.reference;
      unit = arguments.unit;
      appOriginEnum = arguments.appOriginEnum;
      applicationContainer = arguments.applicationContainer;
      if (comfortPartnersController.selectedPartner != null) {
        if (comfortPartnersController.selectedPartner!.cta ==
            ComfortCTA.cupom) {
          await comfortPartnersController.getPartnerCoupons();
        }
      }
      comfortPartnersController.comfortCardAnalyticsTimerStart(
          debugEventIdentifier: "comfort_card_change_dependecies");
      _didInitializedArgs = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.inactive:
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        print("Paused");
        comfortPartnersController.comfortCardAnalyticsStopTimer();
        break;
      case AppLifecycleState.resumed:
        print("Resumed");
        comfortPartnersController.comfortCardAnalyticsTimerStart(
            debugEventIdentifier: "lifecycle_resumed");
        comfortPartnersController.comfortPartnerPageAnalyticsStopTimer();
        //? Não é mais necesssario buscar a request de compra, pois a tela de avaliação da compra não é mais exibida
        //comfortPartnersController.findRequestPurchase(selectedRequestId);
        break;
      case AppLifecycleState.detached:
        print("Detached");
        comfortPartnersController.comfortCardAnalyticsStopTimer();
        if (comfortPartnersController.comfortPartnerPageAnalyticsTimer !=
            null) {
          comfortPartnersController.comfortPartnerPageAnalyticsTimer!
              .stopTimer();
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _onPop(comfortPartnersController);
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer(
          listener: (context, state) {
            if (state is SuccessReviewSentState) {
              Navigator.pushReplacementNamed(
                context,
                SharedApplicationRoute.comfortReviewSentSuccess,
                arguments:
                    ComfortReviewSentSuccessPageArgs(comfortPartnersController),
              );
            }
            if (state is SuccessComfortPartnerCupomState) {
              ComfortPartner partner = state.selectedPartner;
              _launchPartnerPage(
                  state.couponRequest, state.selectedPartner, state.error);
              _showReviewDialog(partner, state.requestPurchase, arguments);
            }
          },
          bloc: comfortPartnersController.comfortPartnersBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: CustomAppBar(title: "comfort"),
              body: _buildScaffoldBody(
                  context: context,
                  comfortPartnersController: comfortPartnersController,
                  comfortPartnerPageArgs: arguments),
            );
          },
        ),
      ),
    );
  }

  Widget _buildScaffoldBody(
      {required BuildContext context,
      required ComfortPartnersController comfortPartnersController,
      required ComfortPartnerPageArgs comfortPartnerPageArgs}) {
    if (comfortPartnersController.comfortPartnersBloc.state
        is LoadingComfortPartnersState)
      return Column(
        children: [
          Expanded(child: LoadingWidget()),
        ],
      );

    if (comfortPartnersController.comfortPartnersBloc.state
        is ErrorComfortPartnersState)
      return ErrorMessageWidget(
        message: getString(
            context,
            (comfortPartnersController.comfortPartnersBloc.state
                    as ErrorComfortPartnersState)
                .errorMessageKey),
      );

    if (comfortPartnersController.comfortPartnersBloc.state
        is LoadedComfortPartnerDetailsState)
      return _buildPartnerDetailsBody(
          context: context,
          comfortPartnersController: comfortPartnersController,
          state: comfortPartnersController.comfortPartnersBloc.state
              as LoadedComfortPartnerDetailsState,
          comfortPartnerPageArgs: comfortPartnerPageArgs);

    return Container();
  }

  Widget _buildPartnerDetailsBody({
    required BuildContext context,
    required ComfortPartnersController comfortPartnersController,
    required LoadedComfortPartnerDetailsState state,
    required ComfortPartnerPageArgs comfortPartnerPageArgs,
  }) {
    ComfortPartner partner = state.selectedPartner;

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PartnerIntroWidget(
            applicationContainer: applicationContainer,
            partnerIntro: partner.partnerIntro,
            changeFavoriteStatus:
                comfortPartnersController.changePartnerFavoriteStatus,
          ),
          if (partner.ratingsNumber >= 5)
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  SharedApplicationRoute.comfortPartnerReviews,
                  arguments: ComfortPartnerReviewsPageArgs(
                      partner: partner, reference: referece, unit: unit),
                );
              },
              child: PartnerGeneralRatingWidget(partner: partner),
            ),
          SizedBox(height: Dimens.spacingSmall),
          if (partner.site.isNotEmpty)
            _buildInfo(
              context: context,
              icon: "assets/ic_comfort_site.svg",
              text: partner.siteFormatted,
              url: partner.site,
              isEmail: false,
            ),
          if (partner.instagramLink.isNotEmpty)
            _buildInfo(
              context: context,
              icon: "assets/ic_comfort_insta.svg",
              text: "@${partner.instagram}",
              url: partner.instagramLink,
              isEmail: false,
            ),
          if (partner.email.isNotEmpty)
            _buildInfo(
              context: context,
              icon: "assets/ic_comfort_email.svg",
              text: partner.email,
              url: partner.emailUrl,
              isEmail: true,
            ),
          Padding(
            padding: EdgeInsets.only(
              top: Dimens.spacing,
              bottom: Dimens.spacingMedium,
              right: Dimens.spacingMedium,
              left: Dimens.spacingMedium,
            ),
            child: HtmlWidget(partner.clobContent),
          ),
          if (partner.cta == ComfortCTA.cupom) ...[
            BlocBuilder<ComfortPartnerCouponsBloc, ComfortPartnerCouponsState>(
              bloc: comfortPartnersController.comfortPartnerCouponsBloc,
              builder: (context, state) {
                if (state is LoadingCouponsState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CouponsErrorState) {
                  return ErrorMessageWidget(
                    message: getString(context, state.errorMessageKey),
                  );
                } else if (state is LoadedCouponsState) {
                  if (state.coupons.isEmpty) {
                    return PartnerNoCouponWidget(
                      partner: partner,
                      onPressed: (partner, {coupon}) {
                        clickCTA(comfortPartnersController, partner, coupon);
                      },
                    );
                  } else {
                    return PartnerCouponsListView(
                      applicationContainer: applicationContainer,
                      partner: partner,
                      coupons: state.coupons,
                      onPressed: (partner, {coupon}) {
                        comfortPartnersController.createCouponRequest(partner,
                            coupon: coupon);
                      },
                      onShowDialog: (partner, {coupon}) {
                        comfortPartnersController.analyticsClickCta(
                            partner, coupon);
                        comfortPartnersController
                            .comfortCardAnalyticsStopTimer();
                        comfortPartnersController
                            .comfortRedirectDialogAnalyticsTimerStart(
                          debugEventIdentifier: "coupons_list_view_show_dialog",
                        );
                      },
                      onDialogDismissed: (partner, {coupon}) {
                        comfortPartnersController.analyticsCtaCardDismissed(
                            partner, coupon);
                        comfortPartnersController
                            .comfortCardAnalyticsTimerStart(
                          debugEventIdentifier:
                              "coupons_list_view_dismissed_dialog",
                        );
                        comfortPartnersController
                            .comfortRedirectDialogAnalyticsStopTimer();
                      },
                      onLifecyclePaused: () => comfortPartnersController
                          .comfortRedirectDialogAnalyticsStopTimer(),
                      onLifecycleResumed: () => comfortPartnersController
                          .comfortRedirectDialogAnalyticsTimerStart(
                              debugEventIdentifier: "redirect_dialog_resumed"),
                      onLifecycleDetached: () => comfortPartnersController
                          .comfortRedirectDialogAnalyticsStopTimer(),
                      onGoToPartnerPage: () => comfortPartnersController
                          .comfortPartnerPageAnalyticsTimerStart(
                              debugEventIdentifier: "go_to_partner_page"),
                      analyticsLgpdAcessar: (partner, coupon) =>
                          comfortPartnersController.analyticsLgpdAcessar(
                              partner, coupon),
                      analyticsOptIn: (partner, coupon) =>
                          comfortPartnersController.analyticsCtaOptIn(
                              partner, coupon),
                      analyticsRedirectButton: (partner, coupon) =>
                          comfortPartnersController.analyticsCtaRedirectButton(
                              partner, coupon),
                    );
                  }
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ] else if (partner.cta == ComfortCTA.email)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                onPressed: () {
                  clickCTA(comfortPartnersController, partner, null);
                },
                text: getString(context, "comfort_request_email"),
              ),
            )
          else if (partner.cta == ComfortCTA.link)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: PrimaryButton(
                onPressed: () {
                  clickCTA(comfortPartnersController, partner, null);
                },
                text: getString(context, "comfort_request_link"),
              ),
            ),
          SizedBox(height: Dimens.spacingMedium),
        ],
      ),
    );
  }

  void clickCTA(ComfortPartnersController comfortPartnersController,
      ComfortPartner partner, ComfortPartnerCoupon? coupon) {
    comfortPartnersController.analyticsClickCta(partner, coupon);
    comfortPartnersController.comfortCardAnalyticsStopTimer();
    comfortPartnersController.comfortRedirectDialogAnalyticsTimerStart(
        debugEventIdentifier: "click_cta_show_dialog");
    showDialog(
      context: context,
      builder: (context) {
        return CouponRequestDialog(
          partner: partner,
          coupon: coupon,
          onGoToPartnerPage: () =>
              comfortPartnersController.comfortPartnerPageAnalyticsTimerStart(
                  debugEventIdentifier: "click_cta_go_to_partner_page"),
          onPressed: (partner, {coupon}) => comfortPartnersController
              .createCouponRequest(partner, coupon: coupon),
          onLifecyclePaused: () => comfortPartnersController
              .comfortRedirectDialogAnalyticsStopTimer(),
          onLifecycleResumed: () => comfortPartnersController
              .comfortRedirectDialogAnalyticsTimerStart(
                  debugEventIdentifier: "click_cta_coupon_resumed"),
          onLifecycleDetached: () => comfortPartnersController
              .comfortRedirectDialogAnalyticsStopTimer(),
          analyticsLgpdAcessar: (partner, coupon) =>
              comfortPartnersController.analyticsLgpdAcessar(partner, coupon),
          analyticsOptIn: (partner, coupon) =>
              comfortPartnersController.analyticsCtaOptIn(partner, coupon),
          analyticsRedirectButton: (partner, coupon) =>
              comfortPartnersController.analyticsCtaRedirectButton(
                  partner, coupon),
        );
      },
    ).then((_) {
      comfortPartnersController.analyticsCtaCardDismissed(partner, coupon);
      comfortPartnersController.comfortCardAnalyticsTimerStart(
          debugEventIdentifier: "click_cta_dialog_dismissed");
      comfortPartnersController.comfortRedirectDialogAnalyticsStopTimer();
    });
  }

  Future<void> _launchPartnerPage(ComfortCouponRequest? request,
      ComfortPartner partner, String? error) async {
    if (error != null && error.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComfortCupomRequesResultPage(
            isSucces: false,
            title: getString(context, "comfort_request_error_title"),
            subtitle: getString(context, "comfort_request_error_subtitle"),
          ),
        ),
      ).then((_) => comfortPartnersController.comfortCardAnalyticsTimerStart(
          debugEventIdentifier: "launch_partner_page_error"));
      return;
    }

    if (request != null) {
      selectedRequestId = request.idRequest;
      switch (request.cta) {
        case ComfortCTA.link:
        case ComfortCTA.cupom:
          await UrlLauncherNative.openUrl(
            request.urlAndQueries.toString(),
            headers: request.headers,
          );
        case ComfortCTA.email:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ComfortCupomRequesResultPage(
                isSucces: true,
                title: getString(context, "comfort_request_email_sent"),
                subtitle:
                    getString(context, "comfort_request_email_sent_subtitle"),
              ),
            ),
          );
      }
    }
  }

  void _showReviewDialog(
      ComfortPartner partner,
      ComfortRequestPurchase? requestPurchase,
      ComfortPartnerPageArgs comfortPartnerPageArgs) {
    if (requestPurchase != null &&
        requestPurchase.purchaseDone &&
        !dialogAlreadyShown) {
      dialogAlreadyShown = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => ReviewRequestDialog(
          applicationContainer: applicationContainer,
          partner: partner,
          requestPurchase: requestPurchase,
          sendRequestReview: comfortPartnersController.reviewRequest,
        ),
      ).then((value) {
        if (value == null) {
          switch (appOriginEnum) {
            case AppOriginEnum.owner:
              AnalyticsLogEvents.logEvent(
                  event: AnalyticsEventsOwner
                      .comodidadesParceiroAvaliacoesAcessar(),
                  userId: comfortPartnersController
                          .sessionBloc.state.session?.me?.id ??
                      "",
                  unitValue: comfortPartnerPageArgs.unit ?? "",
                  referenceValue: comfortPartnerPageArgs.reference,
                  appOrigin: appOriginEnum,
                  otherParameters: {
                    "id_parceiro": partner.notificationParameter,
                    "id_partner": partner.notificationParameter,
                    "nome_parceiro": partner.partnerIntro.title
                  });
              break;
            case AppOriginEnum.employee:
              AnalyticsLogEvents.logEvent(
                  event: AnalyticsEventsEmployee
                      .comodidadesParceiroAvaliacoesAcessar(),
                  referenceValue: comfortPartnerPageArgs.reference,
                  appOrigin: appOriginEnum,
                  otherParameters: {
                    "id_parceiro": partner.notificationParameter,
                    "id_partner": partner.notificationParameter,
                    "nome_parceiro": partner.partnerIntro.title
                  });
              break;
            case AppOriginEnum.manager:
              // TODO: Handle this case.
              break;
          }
          comfortPartnersController
              .getAllPartners(ComfortPageOriginEnum.toYourCondoPage);
          Navigator.pop(context);
        }
      });
    }
  }

  void _onPop(ComfortPartnersController comfortPartnersController) async {
    comfortPartnersController.comfortCardAnalyticsStopTimer();
    comfortPartnersController.analyticsPartnerPageBack();
    comfortPartnersController.backToLoadedComfortPartnersState(
        ComfortPageOriginEnum.toYourCondoPage);
  }

  Widget _buildInfo(
      {required BuildContext context,
      required String icon,
      required String text,
      required String url,
      required bool isEmail}) {
    ThemeData theme = Theme.of(context);
    TextStyle? linksStyle =
        LelloTextStyles.body(theme)?.copyWith(color: theme.primaryColor);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
      child: Column(
        children: [
          InkWell(
            onTap: () async {
              if (isEmail) {
                UrlLauncherNative.openUrl(url);
                return;
              }
              var auxURI = Uri.parse(url);
              var parsedURI = Uri.https(auxURI.authority, auxURI.path);
              UrlLauncherNative.openUrl(parsedURI.toString());
            },
            child: Row(
              children: [
                SvgPicture.asset(
                  icon,
                  color: theme.primaryColor,
                ),
                SizedBox(width: Dimens.spacingSmall),
                Flexible(
                  child: Text(
                    text,
                    style: linksStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.0),
        ],
      ),
    );
  }
}