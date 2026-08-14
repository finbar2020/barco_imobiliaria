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

class EasyFixPage extends StatefulWidget {
  final VoidCallback closeOverlay;
  final bool isGeneric;
  final String? talkToLelloWhatsAppNumber;

  const EasyFixPage({
    Key? key,
    required this.closeOverlay,
    this.isGeneric = false,
    this.talkToLelloWhatsAppNumber,
  }) : super(key: key);

  @override
  _EasyFixPageState createState() => _EasyFixPageState();
}

class _EasyFixPageState extends State<EasyFixPage> {
  static const double _contentHorizontalPadding = 5.0;
  static const double _titleLeftPadding = 10.0;
  static const double _titleBottomPadding = 8.0;

  late SessionBloc sessionBloc;
  CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
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
                        child: hasAnyEasyFixAccess(
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
                    location: BannerLocationEnum.resolvaFacil,
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
      getString(context, "easy_fix"),
      style: LelloTextStyles.title(theme),
    );
  }

  Widget buildEmptyStateTitle() {
    final theme = Theme.of(context);
    return Text(
      getString(context, "easy_fix"),
      style: LelloTextStyles.title(theme)!.copyWith(
          fontWeight: FontWeight.normal,
          color: LelloTheme.palleteOf(theme).grey()),
    );
  }

  bool hasAnyEasyFixAccess(SessionBloc sessionBloc,
      CircuitBreakerController circuitBreakController) {
    final defaultItems = HomeItemEnumUtils.easyFixPageItems;
    final hasDashboardAccess = defaultItems.any((item) =>
        sessionBloc.checkRback(item.rbac(sessionBloc)) &&
        circuitBreakController.checkVisible(
          applicationRbac: item.rbac(sessionBloc),
          reference:
              sessionBloc.state.session?.condominium?.reference.toString() ??
                  "",
        ));
    return hasDashboardAccess;
  }

  Widget _buildBody(SessionBloc sessionBloc, BuildContext context) {
    final hasAccess = hasAnyEasyFixAccess(sessionBloc, circuitBreakController);
    final dashboardWidgets = _buildDashboard(context);
    if (!hasAccess || dashboardWidgets.isEmpty) {
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
          children: [...dashboardWidgets],
        ),
      ],
    );
  }

  List<Widget> _buildDashboard(BuildContext context) {
    List<Widget> widgetsList = [];
    String reference =
        sessionBloc.state.session?.condominium?.reference.toString() ?? "";

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarPreferenciasMinhaConta,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarPreferenciasMinhaConta,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.morarPreferenciasMinhaConta),
          child: DashboardItem(
            imagePath: "assets/ic_minha_conta.svg",
            text: "my_preferences",
            route: ApplicationRoute.myPreferences,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.myPreferences);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarDocumentos,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarDocumentos,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarDocumentos),
          child: DashboardItem(
            imagePath: "assets/ic_documents.svg",
            text: "documents",
            route: ApplicationRoute.documents,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.documents);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarPpc, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarPpc,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarPpc),
          child: DashboardItem(
            imagePath: "assets/ic_accountability.svg",
            text: "lello_hub_billing",
            route: ApplicationRoute.accountability,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(
                  HomeItemEnum.accountability);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarBoletos, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarBoletos,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarBoletos),
          child: DashboardItem(
            imagePath: "assets/ic_segunda_via_boletos.svg",
            text: "income_control_billets",
            route: ApplicationRoute.billets,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.billets);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarReservas, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarReservas,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarReservas),
          child: DashboardItem(
            imagePath: "assets/reserva_de_areas_icon.svg",
            text: "reserves",
            route: ApplicationRoute.reserve,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.reserves);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarAcordos, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarAcordos,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarAcordos),
          child: DashboardItem(
            imagePath: "assets/ic_agreements.svg",
            text: "agreements",
            route: ApplicationRoute.agreements,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.agreements);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarAlteracaoTitularidade,
        reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarAlteracaoTitularidade,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.morarAlteracaoTitularidade),
          child: DashboardItem(
            imagePath: "assets/ic_change_ownership.svg",
            text: "change_ownership",
            route: ApplicationRoute.changeOwnership,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(
                  HomeItemEnum.changeOwnership);
            },
            sessionBloc: sessionBloc,
            isCardWideScreen: false,
            isGeneric: widget.isGeneric,
          ),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.morarCnd, reference: reference)) {
      widgetsList.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.morarCnd,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.morarCnd),
          child: DashboardItem(
            imagePath: "assets/ic_cnd.svg",
            text: "cnd",
            route: ApplicationRoute.certificateNoOutstandingDebt,
            closeOverlay: () async {
              widget.closeOverlay();
              await HomeItemWeightCache.updateOrder(HomeItemEnum.cnd);
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
