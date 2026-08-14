import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/hub_button.dart';
import 'package:lello/feature/condominium/presentation/widget/hub_badge.dart';
import 'package:lello/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:lello/feature/home/presentation/widget/sliver/widget/sliver_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';

class CondominiumHubPage extends StatefulWidget {
  final bool isGeneric;

  const CondominiumHubPage({
    Key? key,
    this.isGeneric = false,
  }) : super(key: key);

  @override
  State<CondominiumHubPage> createState() => _CondominiumHubPageState();
}

class _CondominiumHubPageState extends State<CondominiumHubPage> {
  late SessionBloc sessionBloc;
  late CircuitBreakerController circuitBreakController;

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
    circuitBreakController = ApplicationContainer.instance().resolve();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SliverWidget(
      isGeneric: widget.isGeneric,
      children: <Widget>[
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.only(
                left: Dimens.spacingMedium,
                top: Dimens.spacingMedium,
                right: Dimens.spacingMedium),
            child: Text(getString(context, "condominium_hub_title"),
                style: LelloTextStyles.title(theme)),
          ),
        ),
        SliverPadding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            sliver: _buildList(context, theme)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: CircuitBreakerWidget(
              reference:
                  sessionBloc.state.session?.selectedCondominium?.reference ??
                      "",
              appContainer: ApplicationContainer.instance(),
              applicationRbac: ApplicationRbac.sindicoBanner,
              rbacEnabled:
                  sessionBloc.checkRback(ApplicationRbac.sindicoBanner),
              child: Padding(
                padding: EdgeInsets.all(Dimens.spacingSmall),
                child: BannersWidget(
                  appContainer: ApplicationContainer.instance(),
                  sessionBloc: sessionBloc,
                  location: BannerLocationEnum.condominioEEu,
                  maxItems: 3,
                  showCounterIndicator: true,
                  compact: true,
                  stacked: true,
                  onBannerClick: (banner) {
                    BannerFeatureRedirectHandler.redirect(
                      context: context,
                      sessionBloc: sessionBloc,
                      banner: banner,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context, ThemeData theme) {
    return SliverGrid.count(
      childAspectRatio: 1.4,
      crossAxisCount: 2,
      mainAxisSpacing: Dimens.spacing,
      crossAxisSpacing: Dimens.spacing,
      children: _getButtons(context),
    );
  }

  List<Widget> _getButtons(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    String reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";
    List<Widget> hubButtonlist = [];
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoGestaoDeManutencao,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoGestaoDeManutencao,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoGestaoDeManutencao),
          child: HubButton(
              title: getString(context, "maintenance_management"),
              icon: SvgPicture.asset("assets/maintenance_management.svg"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.maintenanceManagement);
              }),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoSegundavia,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoSegundavia,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoSegundavia),
          child: HubButton(
              title: getString(context, "income_monthly_billets"),
              icon: SvgPicture.asset("assets/ic_barcode_menu.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.condBoletosAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.billets);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoEquipe, reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoEquipe,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoEquipe),
          child: HubButton(
              title: getString(context, "gdp_team"),
              icon: SvgPicture.asset("assets/ic_team.svg"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.gdpEmployeeList);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoReservas,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoReservas,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoReservas),
          child: HubButton(
              // comingSoonBadge: ComingSoonBadge(),
              // isEnabled: false,
              title: getString(context, "condominium_hub_manage_space"),
              icon: SvgPicture.asset("assets/ic_hub_manage_space.svg"),
              onPressed: () {
                Navigator.of(context).pushNamed(ApplicationRoute.space);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoUnidades,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoUnidades,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoUnidades),
          child: HubButton(
              title: getString(context, "condominium_hub_units"),
              icon: SvgPicture.asset("assets/ic_hub_units.svg"),
              onPressed: () {
                Navigator.of(context).pushNamed(ApplicationRoute.units);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoVoxComunicados,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoVoxComunicados,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoVoxComunicados),
          child: HubButton(
            title: getString(context, "condominium_hub_announcements"),
            isEnabled: true,
            icon: SvgPicture.asset(
              "assets/ic_announcements.svg",
              height: Dimens.homeMenuIconSize,
            ),
            onPressed: () {
              ManagerAnalyticsLogEvents.logEvent(
                  event: AnalyticsEventsManager.comunicadosAcessar(),
                  referenceValue: reference);
              Navigator.of(context)
                  .pushNamed(ApplicationRoute.announcementsMenu);
            },
          ),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoVoxAdvertencias,
            reference: reference) ||
        circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoVoxMultas,
            reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoVoxAdvertencias,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoVoxAdvertencias) ||
                  sessionBloc.checkRback(ApplicationRbac.sindicoVoxMultas),
          child: HubButton(
            title: getString(context, "condominium_hub_advertences"),
            icon: SvgPicture.asset("assets/ic_warnings_and_fines.svg",
                height: Dimens.homeMenuIconSize),
            isEnabled: true,
            onPressed: () {
              ManagerAnalyticsLogEvents.logEvent(
                  event: AnalyticsEventsManager.advertenciaMultasAcessar(),
                  referenceValue: reference);
              Navigator.of(context)
                  .pushNamed(ApplicationRoute.warningsAndFines);
            },
          ),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoDocumentos,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoDocumentos,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoDocumentos),
          child: HubButton(
              title:
                  getString(context, "condominium_hub_condominium_documents"),
              icon: SvgPicture.asset("assets/ic_condo_documents.svg"),
              onPressed: () {
                Navigator.of(context).pushNamed(ApplicationRoute.documents);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoOcorrencias,
        reference: reference)) {
      hubButtonlist.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoOcorrencias,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoOcorrencias),
          child: HubButton(
              title: getString(context, "condominium_hub_reports_book"),
              comingSoonBadge: sessionBloc.checkConfig("report_book_reference")
                  ? null
                  : HubBadge(text: getString(context, "lello_hub_badge_soon")),
              isEnabled: sessionBloc.checkConfig("report_book_reference"),
              icon: SvgPicture.asset("assets/ic_reports_book_menu.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.ocorrenciasAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.reportsBook);
              }),
        ),
      );
    }

    return hubButtonlist;
  }

// bool circuitBreakController.checkVisible({required String applicationRbac}) {
//   var itemRule = circuitBreakController.getRule(
//       applicationRbac: applicationRbac,
//       reference:
//           sessionBloc.state.session?.selectedCondominium?.reference ?? "");
//   if (itemRule?.situation == CircuitBreakerSituationEnum.hide ||
//       !sessionBloc.checkRback(applicationRbac)) return false;
//   return true;
// }
}
