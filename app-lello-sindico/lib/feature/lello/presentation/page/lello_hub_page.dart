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
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';

class LelloHubPage extends StatefulWidget {
  final bool isGeneric;

  const LelloHubPage({
    Key? key,
    this.isGeneric = false,
  }) : super(key: key);

  @override
  State<LelloHubPage> createState() => _LelloHubPageState();
}

class _LelloHubPageState extends State<LelloHubPage> {
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
    return StreamBuilder<List<CircuitItemRule>>(
        stream: circuitBreakController.ruleStream.stream,
        builder: (context, snapshot) {
          debugPrint("ReBuild: Hub");
          return SliverWidget(
            isGeneric: widget.isGeneric,
            children: <Widget>[
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Dimens.spacingMedium,
                      top: Dimens.spacingMedium,
                      right: Dimens.spacingMedium),
                  child: Text(
                    getString(context, "lello_hub_title"),
                    style: LelloTextStyles.title(theme),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                sliver: _buildList(context, theme),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: CircuitBreakerWidget(
                    reference: sessionBloc
                            .state.session?.selectedCondominium?.reference ??
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
                        location: BannerLocationEnum.empresaEEu,
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
        });
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
    String reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";
    bool hasBiometricAccess =
        sessionBloc.state.session?.selectedCondominium?.useFacialBiometric ??
            false;
    List<Widget> list = [];
    if (hasBiometricAccess) {
      if (circuitBreakController.checkVisible(
          applicationRbac: ApplicationRbac.sindicoGestaoBiometria,
          reference: reference)) {
        list.add(
          HubButton(
              title: getString(context, "access_management_title"),
              icon: SvgPicture.asset("assets/ic_access_management.svg"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.accessManagement);
              }),
        );
      }
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoDespesas,
        reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoDespesas,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoDespesas),
          child: HubButton(
              title: getString(context, "lello_hub_outcome"),
              icon: SvgPicture.asset("assets/ic_outcome.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.despesasAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.payment);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoReceitas,
        reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoReceitas,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoReceitas),
          child: HubButton(
              title: getString(context, "lello_hub_income"),
              icon: SvgPicture.asset("assets/ic_revenues.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.receitasAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.income);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoGdp, reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoGdp,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoGdp),
          child: HubButton(
              title: getString(context, "lello_hub_employee"),
              icon: SvgPicture.asset("assets/ic_people_management.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.gdpAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.gdp);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoInadimplentes,
        reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoInadimplentes,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoInadimplentes),
          child: HubButton(
              title: getString(context, "lello_hub_default"),
              icon: SvgPicture.asset("assets/ic_non_payment.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.inadimplenciaAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.nonPayments);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
            applicationRbac: ApplicationRbac.sindicoAcordos,
            reference: reference) &&
        sessionBloc.checkConfig("agreement_reference")) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoAcordos,
          rbacEnabled: sessionBloc.checkConfig("agreement_reference"),
          child: HubButton(
              title: getString(context, "lello_hub_agreements"),
              icon: SvgPicture.asset("assets/ic_hub_agreements.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.acordosAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.agreements);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoPpc, reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoPpc,
          rbacEnabled: sessionBloc.checkRback(ApplicationRbac.sindicoPpc),
          child: HubButton(
              title: getString(context, "lello_hub_billing"),
              icon: SvgPicture.asset("assets/ic_hub_billing.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.ppcAcessar(),
                    referenceValue: reference);
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.accountability);
              }),
        ),
      );
    }
    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoCaixalocal,
        reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoCaixalocal,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoCaixalocal),
          child: HubButton(
              comingSoonBadge: sessionBloc.checkConfig("resin_reference")
                  ? null
                  : HubBadge(text: getString(context, "lello_hub_badge_soon")),
              isEnabled: sessionBloc.checkConfig("resin_reference"),
              title: getString(context, "lello_hub_resin"),
              icon: SvgPicture.asset("assets/ic_local_checkout.svg"),
              onPressed: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.caixaLocalAcessar(),
                    referenceValue: reference);
                Navigator.of(context).pushNamed(ApplicationRoute.resinMenu);
              }),
        ),
      );
    }

    if (circuitBreakController.checkVisible(
        applicationRbac: ApplicationRbac.sindicoGestaoAcessos,
        reference: reference)) {
      list.add(
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference: reference,
          applicationRbac: ApplicationRbac.sindicoGestaoAcessos,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoGestaoAcessos),
          child: HubButton(
              title: getString(context, "staff_access_management"),
              icon: SvgPicture.asset("assets/ic_staff_access_management.svg"),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.staffAccessManagement);
              }),
        ),
      );
    }

    return list;
  }
}
