import 'dart:convert';
import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_category.dart';
import 'package:shared_features/feature/comfort/domain/entity/comfort_partner_coupon.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_bloc.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/bloc/comfort_partners_state.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/controller/comfort_partners_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_category_partners_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_partner_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/best_offers_list_view/comfort_best_offers_list_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner.dart/comfort_partner_view.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/comfort_partner_menu/comfort_partner_menu.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/widgets/partners_list_view_vertical_scrolling/comfort_partners_list_view_vertical_scrolling.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/pages/comfort_to_your_condo_page.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_to_your_condo/widgets/comfort_to_your_condo_onboarding.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../core/circuit_breaker/models/circuit_item_rule.dart';

class ComfortPageArgs {
  String reference;
  String? unit;
  String? partnerId;
  AppOriginEnum appOriginEnum;
  bool? isProduction;
  String? comfortNotificationContext;
  dynamic route;
  bool checkOffers;
  bool checkYourCondo;
  bool checkRequest;
  bool checkFavorites;
  ComfortPageOriginEnum accessRouteOrigin;

  ComfortPageArgs({
    required this.appOriginEnum,
    required this.reference,
    required this.accessRouteOrigin,
    this.checkOffers = true,
    this.checkYourCondo = true,
    this.checkRequest = true,
    this.checkFavorites = true,
    this.unit,
    this.partnerId,
    this.isProduction,
    this.comfortNotificationContext,
    this.route,
  });
}

class ComfortPage extends StatefulWidget {
  final SharedApplicationContainer appContainer;
  final AppOriginEnum appOriginEnum;
  final bool embedded;
  final Widget? embeddedMiddleWidget;
  final VoidCallback? backFunction;

  const ComfortPage({
    Key? key,
    required this.appContainer,
    required this.appOriginEnum,
    this.embedded = false,
    this.embeddedMiddleWidget,
    this.backFunction,
  }) : super(key: key);

  @override
  _ComfortPageState createState() => _ComfortPageState();
}

class _ComfortPageState extends State<ComfortPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool? isProduction;
  late ComfortPartnersController comfortPartnersController;
  late AnimationController _controller;
  late Animation<double> _animation;
  late CircuitBreakerController circuitBreakController;
  // late ComfortPageArgs arguments;
  SharedPreferences? preferences;

  @override
  dispose() {
    _controller.dispose();
    widget.appContainer.resetLazySingleton<ComfortPartnersController>();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    comfortPartnersController =
        widget.appContainer.resolve<ComfortPartnersController>();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        if (_controller.isCompleted) {
          if (category != null) {
            updateStep(category);
            _controller.reverse();
          }
        }
      });

    _animation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(_controller);
    SharedPreferences.getInstance().then((value) => preferences = value);
    circuitBreakController =
        widget.appContainer.resolve<CircuitBreakerController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final arguments = _getArguments(context);
      comfortPartnersController.getAllPartners(arguments.accessRouteOrigin);
    });
    comfortPartnersController.comfortHomeAnalyticsTimerStart(
        debugEventIdentifier: "comfort_home_init_state");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (ModalRoute.of(context)?.isCurrent == false) return;
    switch (state) {
      case AppLifecycleState.paused:
        comfortPartnersController.comfortHomeAnalyticsStopTimer();
        break;
      case AppLifecycleState.resumed:
        comfortPartnersController.comfortHomeAnalyticsTimerStart(
            debugEventIdentifier: "comfort_home_resumed");
        break;
      case AppLifecycleState.detached:
        comfortPartnersController.comfortHomeAnalyticsStopTimer();
        break;
      default:
        break;
    }
  }

  ComfortPartnerCategory? category;
  bool redirect = false;

  ComfortPageArgs _getArguments(BuildContext context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    if (routeArgs is ComfortPageArgs) return routeArgs;
    final session = comfortPartnersController.sessionBloc.state.session;
    String reference = "";
    try {
      reference = session?.condominium?.reference?.toString() ?? "";
    } catch (_) {
      try {
        reference = session?.selectedCondominium?.reference?.toString() ?? "";
      } catch (_) {
        reference = "";
      }
    }
    return ComfortPageArgs(
      appOriginEnum: widget.appOriginEnum,
      reference: reference,
      accessRouteOrigin: ComfortPageOriginEnum.dashboard,
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = _getArguments(context);
    isProduction = arguments.isProduction;

    final theme = Theme.of(context);
    final blocContent = BlocConsumer<ComfortPartnersBloc, ComfortPartnersState>(
      bloc: comfortPartnersController.comfortPartnersBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is LoadingComfortPartnersState) {
          return widget.embedded
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: Dimens.spacingLarge),
                  child: Center(child: LoadingWidget()),
                )
              : Column(
                  children: [
                    Expanded(child: LoadingWidget()),
                  ],
                );
        }

        if (state is ErrorComfortPartnersState) {
          final errorWidget = ErrorHandlingWidget(
            errorCode: state.errorCode,
            error: state.errorDescription,
            reTryFunction: () {
              comfortPartnersController.getAllPartners(
                  ComfortPageOriginEnum.comfortPageTryAgain);
            },
            backFunction: widget.embedded
                ? (widget.backFunction ?? () {})
                : () => Navigator.pop(context, true),
            showBackButton: !widget.embedded || widget.backFunction != null,
            isProduction: isProduction ?? true,
          );
          if (widget.embedded) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: errorWidget,
            );
          }
          return Column(
            children: [
              Expanded(child: errorWidget),
            ],
          );
        }

        if (state is LoadedComfortPartnerDetailsState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _redirectFromNotification(arguments, state);
            arguments.comfortNotificationContext = null;
          });
        }
        if (state is LoadedComfortPartnersState) {
          if (!widget.embedded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (arguments.partnerId?.isNotEmpty == true) {
                var partner = comfortPartnersController.allPartnersList
                    .firstWhereOrNull(
                        (element) => element.id == arguments.partnerId);
                if (partner != null) {
                  comfortPartnersController.goToPartnerDetailsPage(
                      partner, ComfortPageOriginEnum.banner);
                  Navigator.pushReplacementNamed(
                    context,
                    SharedApplicationRoute.comfortPartner,
                    arguments: ComfortPartnerPageArgs(
                      applicationContainer: widget.appContainer,
                      comfortPartnersController: comfortPartnersController,
                      reference: arguments.reference,
                      unit: arguments.unit,
                      appOriginEnum: widget.appOriginEnum,
                    ),
                  );
                } else {
                  _redirectToCategoryFromBanner(arguments);
                }
              } else {
                _redirectFromNotification(arguments, state);
                arguments.comfortNotificationContext = null;
              }
            });
          }
          if (widget.embedded) {
            return _buildEmbeddedContent(context, state, arguments);
          }
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (arguments.checkOffers)
                  ComfortBestOffersListView(
                    coupons: comfortPartnersController.getTopCouponsList(),
                    onPressed: (coupon) =>
                        onCouponSelected(coupon, arguments),
                  ),
                if (!(state.comfortPartnerCategoryIsFilter))
                  ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount:
                        comfortPartnersController.categories.length,
                    itemBuilder: (context, index) {
                      return ComfortPartnersListViewVerticalScrolling(
                        applicationContainer: widget.appContainer,
                        partners: comfortPartnersController.partnersList(
                            category: comfortPartnersController
                                .categories[index]),
                        onPressed: ((partner) {
                          onPartnerSelected(partner, arguments);
                        }),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(width: Dimens.spacing);
                    },
                  ),
                if (state.comfortPartnerCategoryIsFilter)
                  FadeTransition(
                    opacity: _animation,
                    child: ComfortPartnerViewWidget(
                      appOriginEnum: widget.appOriginEnum,
                      appContainer: widget.appContainer,
                      checkYourCondo: arguments.checkYourCondo,
                      applicationContainer: widget.appContainer,
                      onTap: (cat) {
                        onTap(cat, arguments);
                      },
                      comfortPartnersController: comfortPartnersController,
                      onPartnerSelected: (ComfortPartner partner) {
                        comfortPartnersController.goToPartnerDetailsPage(
                            partner, ComfortPageOriginEnum.coupon);
                        Navigator.pushNamed(context,
                            SharedApplicationRoute.comfortPartner,
                            arguments: ComfortPartnerPageArgs(
                                applicationContainer: widget.appContainer,
                                comfortPartnersController:
                                    comfortPartnersController,
                                reference: arguments.reference,
                                unit: arguments.unit,
                                appOriginEnum: widget.appOriginEnum));
                      },
                      backPressed: () {
                        category = null;
                        _controller.forward().then((value) {
                          updateStep(null);
                          _controller.reverse();
                        });
                      },
                      categories: comfortPartnersController.categories,
                    ),
                  ),
              ],
            ),
          );
        }

        return SizedBox.shrink();
      },
    );

    if (widget.embedded) {
      return Theme(
        data: theme,
        child: blocContent,
      );
    }
    return StreamBuilder<List<CircuitItemRule>>(
      stream: circuitBreakController.ruleStream.stream,
      builder: (context, snapshot) {
        return Scaffold(
          body: WillPopScope(
            onWillPop: () async => _onPop(),
            child: Theme(
              data: theme,
              child: blocContent,
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmbeddedContent(
    BuildContext context,
    LoadedComfortPartnersState state,
    ComfortPageArgs arguments,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComfortPartnerMenu(
          categories: comfortPartnersController.categories,
          onTap: (cat) {
            onTap(cat, arguments);
          },
          appOriginEnum: widget.appOriginEnum,
          comfortPartnersController: comfortPartnersController,
          appContainer: widget.appContainer,
        ),
        if (widget.embeddedMiddleWidget != null) widget.embeddedMiddleWidget!,
        if (widget.embeddedMiddleWidget == null && arguments.checkOffers)
          ComfortBestOffersListView(
            coupons: comfortPartnersController.getTopCouponsList(),
            onPressed: (coupon) => onCouponSelected(coupon, arguments),
          ),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: comfortPartnersController.categories.length,
          itemBuilder: (context, index) {
            return ComfortPartnersListViewVerticalScrolling(
              applicationContainer: widget.appContainer,
              partners: comfortPartnersController.partnersList(
                  category:
                      comfortPartnersController.categories[index]),
              onPressed: (partner) =>
                  onPartnerSelected(partner, arguments),
            );
          },
          separatorBuilder: (context, index) {
            return SizedBox(height: Dimens.spacing);
          },
        ),
      ],
    );
  }

  _redirectToCategoryFromBanner(ComfortPageArgs arguments) async {
    if (redirect) return;
    ComfortPartnerCategory? convertCategory =
        convertRouteFromCategoryEnum(arguments.partnerId!);
    List<String> categoriesUp = List.generate(
        comfortPartnersController.categories.length,
        (index) =>
            enumToString(comfortPartnersController.categories[index]) ?? "");
    var item = categoriesUp.cast<String?>().firstWhere(
        (element) => element == enumToString(convertCategory),
        orElse: () => null);
    if (item != null) {
      ComfortPartnerCategory? cate = comfortPartnersController.categories
          .cast<ComfortPartnerCategory?>()
          .firstWhere(
              (element) =>
                  element == stringToEnum(ComfortPartnerCategory.values, item),
              orElse: () => null);
      if (cate != null) {
        redirect = true;
        setState(() {
          category = cate;
          comfortPartnersController.changeCategory(cate);
        });
        onTap(cate, arguments);
        return;
      }
    }
  }

  _redirectFromNotification(
      ComfortPageArgs arguments, LoadedComfortState state) {
    if (arguments.route != null && redirect == false) {
      FeaturesRoutesEnum? enumFromRoute = arguments.route is FeaturesRoutesEnum
          ? arguments.route
          : stringToEnum(FeaturesRoutesEnum.values, arguments.route);
      if (enumFromRoute == FeaturesRoutesEnum.COMODIDADES_CATEGORIA) {
        ComfortPartnerCategory convertCategory =
            convertRouteFromCategoryEnum(arguments.comfortNotificationContext!);
        redirect = true;
        List<String> categoriesUp = List.generate(
            comfortPartnersController.categories.length,
            (index) =>
                enumToString(comfortPartnersController.categories[index]) ??
                "");
        var item = categoriesUp.cast<String?>().firstWhere(
            (element) => element == enumToString(convertCategory),
            orElse: () => null);
        if (item != null) {
          ComfortPartnerCategory? cate = comfortPartnersController.categories
              .cast<ComfortPartnerCategory?>()
              .firstWhere(
                  (element) =>
                      element ==
                      stringToEnum(ComfortPartnerCategory.values, item),
                  orElse: () => null);
          if (cate != null) {
            onTap(cate, arguments);
          }
        }
      } else if (enumFromRoute == FeaturesRoutesEnum.COMODIDADES_PARCEIRO) {
        redirect = true;
        var item = comfortPartnersController.allPartnersList
            .cast<ComfortPartner?>()
            .firstWhere(
                (element) =>
                    element?.notificationParameter ==
                        arguments.comfortNotificationContext ||
                    element?.id == arguments.comfortNotificationContext,
                orElse: () => null);
        if (item != null) {
          comfortPartnersController.goToPartnerDetailsPage(
              item, ComfortPageOriginEnum.inAppNotification);
          Navigator.pushNamed(context, SharedApplicationRoute.comfortPartner,
              arguments: ComfortPartnerPageArgs(
                  applicationContainer: widget.appContainer,
                  comfortPartnersController: comfortPartnersController,
                  reference: arguments.reference,
                  unit: arguments.unit,
                  appOriginEnum: widget.appOriginEnum));
          redirect = true;
        }
      }
    }
  }

  void onCouponSelected(
      ComfortPartnerCoupon coupon, ComfortPageArgs comfortPageArgs) {
    List<ComfortPartner?> partners = comfortPartnersController.partnersList();
    ComfortPartner? partner = partners
        .firstWhere((element) => element?.id == coupon.partnerId, orElse: null);
    if (partner != null) {
      onPartnerSelected(partner, comfortPageArgs);
    }
  }

  void onPartnerSelected(
      ComfortPartner partner, ComfortPageArgs comfortPageArgs) {
    comfortPartnersController.goToPartnerDetailsPage(
        partner, ComfortPageOriginEnum.coupon);
    Navigator.pushNamed(context, SharedApplicationRoute.comfortPartner,
        arguments: ComfortPartnerPageArgs(
            applicationContainer: widget.appContainer,
            comfortPartnersController: comfortPartnersController,
            reference: comfortPageArgs.reference,
            unit: comfortPageArgs.unit,
            appOriginEnum: widget.appOriginEnum));
  }

  onTap(ComfortPartnerCategory cat, ComfortPageArgs arguments) {
    comfortPartnersController.comfortHomeAnalyticsStopTimer();
    sendAnalyticsEvent(arguments, cat);
    if (cat == ComfortPartnerCategory.toYourCondo) {
      bool showOnboarding = _checkOnboarding();
      if (showOnboarding) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ComfortToYourCondoOnboarding(
              comfortPartnersController: comfortPartnersController,
              appContainer: widget.appContainer,
              appOriginEnum: widget.appOriginEnum,
              unit: arguments.unit,
              reference: arguments.reference,
            ),
          ),
        ).then((value) =>
            comfortPartnersController.comfortHomeAnalyticsTimerStart(
                debugEventIdentifier: "comfort_home_onboarding_back"));
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ToYourCondoPage(
              comfortPartnersController: comfortPartnersController,
              appContainer: widget.appContainer,
              appOriginEnum: widget.appOriginEnum,
              unit: arguments.unit,
              reference: arguments.reference,
            ),
          ),
        ).then((value) =>
            comfortPartnersController.comfortHomeAnalyticsTimerStart(
                debugEventIdentifier: "comfort_home_to_your_condo_back"));
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ComfortCategoryPartnersPage(
            category: cat,
            comfortPartnersController: comfortPartnersController,
            appContainer: widget.appContainer,
            appOriginEnum: widget.appOriginEnum,
            reference: arguments.reference,
            unit: arguments.unit,
          ),
        ),
      ).then((_) =>
          comfortPartnersController.comfortHomeAnalyticsTimerStart(
              debugEventIdentifier: "comfort_home_category_back"));
    }
  }

  sendAnalyticsEvent(ComfortPageArgs args, ComfortPartnerCategory cat) async {
    switch (args.appOriginEnum) {
      case AppOriginEnum.owner:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsOwner.comodidadesCategoriaAcessar(),
          userId:
              comfortPartnersController.sessionBloc.state.session?.me?.id ?? "",
          userType: await comfortPartnersController.getUserType,
          unitValue: comfortPartnersController
                  .sessionBloc.state.session!.unity?.title
                  ?.toString() ??
              "",
          referenceValue: comfortPartnersController
                  .sessionBloc.state.session!.condominium?.reference
                  ?.toString() ??
              "",
          appOrigin: args.appOriginEnum,
          otherParameters: {
            "category": _getCategoryName(cat),
            "nome_usuario":
                comfortPartnersController.sessionBloc.state.session!.me?.name,
            "email": comfortPartnersController
                    .sessionBloc.state.session!.me?.email ??
                "",
            "nome_condominio": comfortPartnersController
                    .sessionBloc.state.session!.condominium?.name ??
                "",
            "endereco_condominio": comfortPartnersController
                    .sessionBloc.state.session!.condominium?.address ??
                "",
            "origem_acesso": enumToString(args.accessRouteOrigin) ?? ""
          },
        );
      case AppOriginEnum.employee:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsEmployee.comodidadesCategoriaAcessar(),
          userType: await comfortPartnersController.getUserType,
          userId:
              comfortPartnersController.sessionBloc.state.session?.me?.id ?? "",
          referenceValue: comfortPartnersController
                  .sessionBloc.state.session!.condominium?.reference
                  .toString() ??
              "",
          appOrigin: args.appOriginEnum,
          otherParameters: {
            "category": _getCategoryName(cat),
            "nome_usuario": comfortPartnersController
                    .sessionBloc.state.session!.me.nameFormatted ??
                "",
            "email":
                comfortPartnersController.sessionBloc.state.session!.me.email ??
                    "",
            "nome_condominio": comfortPartnersController
                    .sessionBloc.state.session!.condominium?.name ??
                "",
            "origem_acesso": enumToString(args.accessRouteOrigin) ?? ""
          },
        );
      case AppOriginEnum.manager:
        AnalyticsLogEvents.logEvent(
          event: AnalyticsEventsManager.comodidadesCategoriaAcessar(),
          userType: await comfortPartnersController.getUserType,
          referenceValue: comfortPartnersController
                  .sessionBloc.state.session?.selectedCondominium?.reference
                  .toString() ??
              "",
          appOrigin: args.appOriginEnum,
          otherParameters: {
            "category": _getCategoryName(cat),
            "nome_usuario":
                comfortPartnersController.sessionBloc.state.session?.me?.name ??
                    "",
            "email": comfortPartnersController
                    .sessionBloc.state.session?.me?.email ??
                "",
            "nome_condominio": comfortPartnersController
                    .sessionBloc.state.session?.selectedCondominium?.name ??
                "",
            "endereco_condominio": comfortPartnersController
                    .sessionBloc.state.session?.selectedCondominium?.address ??
                "",
            "origem_acesso": enumToString(args.accessRouteOrigin) ?? ""
          },
        );
    }
  }

  void updateStep(ComfortPartnerCategory? category) {
    setState(() {
      comfortPartnersController.changeCategory(category);
    });
  }

  Future<bool> _onPop() async {
    if (comfortPartnersController.currentCategory == null) {
      comfortPartnersController.comfortHomeAnalyticsStopTimer();
      comfortPartnersController.analyticsComfortPageBack();
      Navigator.popUntil(
          context, ModalRoute.withName(SharedApplicationRoute.home));
    } else {
      comfortPartnersController.comfortHomeAnalyticsTimerStart(
          debugEventIdentifier: "comfort_home_on_pop");
      category = null;
      _controller.forward().then((value) {
        updateStep(null);
        _controller.reverse();
      });
    }
    return false;
  }

  bool _checkOnboarding() {
    //check if preferences is initialized

    if (preferences == null) return false;

    var onboarding = preferences!
        .getString(SharedPreferencesKeys.comfortToYourCondoOnboarding);
    Map<String, dynamic> onboardingComfort = {
      'onboarding': true,
    };
    if (onboarding != null && onboarding.isNotEmpty) {
      onboardingComfort = json.decode(onboarding);
    }
    if (onboardingComfort["onboarding"] == true) {
      preferences?.setString(SharedPreferencesKeys.comfortToYourCondoOnboarding,
          json.encode({'onboarding': false}));
      return true;
    } else {
      return false;
    }
  }

  String _getCategoryName(ComfortPartnerCategory category) {
    switch (category) {
      case ComfortPartnerCategory.toYourHome:
        return "PARA_SUA_CASA";
      case ComfortPartnerCategory.toYou:
        return "PARA_VOCE";
      case ComfortPartnerCategory.toYourPet:
        return "PARA_SEU_PET";
      case ComfortPartnerCategory.toYourVehicle:
        return "PARA_SEU_VEICULO";
      case ComfortPartnerCategory.toYourCondo:
        return "PARA_SEU_CONDOMINIO";
      case ComfortPartnerCategory.toYourFamily:
        return "PARA_SUA_FAMILIA";
      default:
        return "OUTROS";
    }
  }

  ComfortPartnerCategory convertRouteFromCategoryEnum(String route) {
    switch (route) {
      case "OUTROS":
      case "others":
        return ComfortPartnerCategory.others;
      case "PARA_VOCE":
      case "toYou":
        return ComfortPartnerCategory.toYou;
      case "PARA_SUA_CASA":
      case "toYourHome":
        return ComfortPartnerCategory.toYourHome;
      case "PARA_SEU_PET":
      case "toYourPet":
        return ComfortPartnerCategory.toYourPet;
      case "PARA_SEU_VEICULO":
      case "toYourVehicle":
        return ComfortPartnerCategory.toYourVehicle;
      case "PARA_SEU_CONDOMINIO":
      case "toYourCondo":
        return ComfortPartnerCategory.toYourCondo;
      case "PARA_SUA_FAMILIA":
      case "toYourFamily":
        return ComfortPartnerCategory.toYourFamily;
      default:
        return ComfortPartnerCategory.others;
    }
  }
}
