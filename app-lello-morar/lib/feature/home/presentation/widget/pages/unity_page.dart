import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:morar/feature/home/presentation/widget/dashboard_item.dart';
import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';
import 'package:morar/feature/home/domain/entity/home_item_enum.dart';
import 'package:morar/feature/home/data/home_item_weight_cache.dart';

class UnityPage extends StatefulWidget {
  final VoidCallback closeOverlay;
  final bool isGeneric;

  const UnityPage({
    Key? key,
    required this.closeOverlay,
    this.isGeneric = false,
  }) : super(key: key);

  @override
  _UnityPageState createState() => _UnityPageState();
}

class _UnityPageState extends State<UnityPage> {
  static const double _contentHorizontalPadding = 5.0;
  static const double _titleLeftPadding = 10.0;
  static const double _titleBottomPadding = 8.0;

  late SessionBloc sessionBloc;
  CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();
  bool activeManager = false;

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
    activeManager =
        sessionBloc.state.session?.condominium?.active_manager ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iaAssetPrefix = FlavorConfig.config.iaName.toLowerCase();
    return Material(
      color: LelloTheme.palleteOf(theme).customColor(),
      child: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: _contentHorizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: Dimens.spacing,
                  bottom: _titleBottomPadding,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: _titleLeftPadding),
                        child: hasAnyUnityAccess(
                                sessionBloc, circuitBreakController)
                            ? _buildPageTitle(theme)
                            : buildEmptyStateTitle(),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    CircuitBreakerWidget(
                        reference:
                            sessionBloc.state.session?.condominium?.reference ??
                                "",
                        appContainer: ApplicationContainer.instance(),
                        applicationRbac: ApplicationRbac.morarIaBella,
                        rbacEnabled: sessionBloc
                            .checkRback(ApplicationRbac.morarIaBella),
                        child: IconButton(
                          icon: SvgPicture.asset(
                            'assets/ic_${iaAssetPrefix}_button2.svg',
                            theme: SvgTheme(
                              currentColor: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              ApplicationRoute.iaBella,
                            );
                          },
                        )),
                  ],
                ),
              ),
              StreamBuilder<List<CircuitItemRule>>(
                  stream: circuitBreakController.ruleStream.stream,
                  builder: (context, snapshot) {
                    return _buildBody(sessionBloc, context);
                  }),
              CircuitBreakerWidget(
                reference:
                    sessionBloc.state.session?.condominium?.reference ?? "",
                appContainer: ApplicationContainer.instance(),
                applicationRbac: ApplicationRbac.morarBanner,
                rbacEnabled:
                    sessionBloc.checkRback(ApplicationRbac.morarBanner),
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingSmall),
                  child: BannersWidget(
                    appContainer: ApplicationContainer.instance(),
                    sessionBloc: sessionBloc,
                    location: BannerLocationEnum.minhaUnidade,
                    maxItems: 3,
                    showCounterIndicator: true,
                    compact: true,
                    stacked: true,
                    onBannerClick: (banner) {
                      BannerFeatureRedirectHandler.redirect(
                        context: context,
                        sessionBloc: sessionBloc,
                        banner: banner,
                        isGeneric: widget.isGeneric,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPageTitle(ThemeData theme) {
    return Text(
      getString(context, "units_title"),
      style: LelloTextStyles.title(theme),
    );
  }

  Widget buildEmptyStateTitle() {
    final theme = Theme.of(context);
    return Text(
      getString(context, "units_title"),
      style: LelloTextStyles.title(theme)!.copyWith(
          fontWeight: FontWeight.normal,
          color: LelloTheme.palleteOf(theme).grey()),
    );
  }

  bool hasAnyUnityAccess(SessionBloc sessionBloc,
      CircuitBreakerController circuitBreakController) {
    final defaultItems = HomeItemEnumUtils.unityPageItems;
    final hasDashboardAccess = defaultItems.any((item) =>
        sessionBloc.checkRback(item.rbac(sessionBloc)) &&
        circuitBreakController.checkVisible(
          applicationRbac: item.rbac(sessionBloc),
          reference:
              sessionBloc.state.session?.condominium?.reference.toString() ??
                  '',
        ));
    return hasDashboardAccess;
  }

  Widget _buildBody(SessionBloc sessionBloc, BuildContext context) {
    final hasAnyAccess = hasAnyUnityAccess(sessionBloc, circuitBreakController);
    if (!hasAnyAccess) {
      return Center(
        child: EmptyStateWidget(),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Dimens.spacing),
        Wrap(
          alignment: WrapAlignment.start,
          children: _buildDashboard(context),
        ),
      ],
    );
  }

  List<Widget> _buildDashboard(BuildContext context) {
    List<Widget> widgetsList = [];
    String reference =
        sessionBloc.state.session?.condominium?.reference.toString() ?? "";
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarMoradores,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarMoradores,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarMoradores),
          child: DashboardItem(
            imagePath: "assets/ic_moradores.svg",
            text: "condominium_hub_residents",
            route: ApplicationRoute.subUser,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.subUser);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarAssembleia,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarAssembleia,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarAssembleia),
          child: DashboardItem(
            imagePath: "assets/ic_digital_assembly.svg",
            text: "digital_meeting",
            route: ApplicationRoute.digitalMeeting,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(
                  HomeItemEnum.digitalMeeting);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarVeiculos, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarVeiculos,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarVeiculos),
          child: DashboardItem(
            imagePath: "assets/ic_vehicles.svg",
            text: "me_vehicles_title",
            route: ApplicationRoute.vehiclePage,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.vehicle);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarSeguros, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarSeguros,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarSeguros),
          child: DashboardItem(
            imagePath: "assets/ic_insurance.svg",
            text: "insurance",
            route: ApplicationRoute.insurance,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.insurance);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarCorrespondencias,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarCorrespondencias,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.morarCorrespondencias),
          child: DashboardItem(
            imagePath: "assets/ic_correspondencia.svg",
            text: "mailing_title",
            route: ApplicationRoute.mailing,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.mailing);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarOcorrencias,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarOcorrencias,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarOcorrencias),
          child: DashboardItem(
            imagePath: "assets/ocorrencias_icon.svg",
            text: "reports_title",
            route: ApplicationRoute.reports,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.reports);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarAutorizarEntrada,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarAutorizarEntrada,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.morarAutorizarEntrada),
          child: DashboardItem(
            imagePath: "assets/autorizar_icon.svg",
            text: "authorize_entry",
            route: ApplicationRoute.accessControl,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.accessControl);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    return widgetsList;
  }
}
