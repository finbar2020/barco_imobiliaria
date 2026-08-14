import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/hub_button.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/condominium/presentation/widget/condominium_balance_widget_c.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:lello/feature/dashboard/presentation/bloc/dashboard_state.dart';
import 'package:lello/feature/home/domain/entity/home_item_enum.dart';
import 'package:lello/feature/home/presentation/controllers/home_analytics_timer_controller.dart';
import 'package:lello/feature/home/presentation/widget/sliver/widget/sliver_widget.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/home/presentation/controllers/banner_feature_redirect_handler.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/banners/domain/entity/banner_location_enum.dart';
import 'package:shared_features/feature/banners/presentation/widgets/banners_widget.dart';
import 'package:shared_features/shared_features.dart';

class DashboardPage extends StatefulWidget {
  final bool isGeneric;

  const DashboardPage({
    Key? key,
    this.isGeneric = false,
  }) : super(key: key);
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late SessionBloc sessionBloc;

  DashboardBloc dashBoardBloc =
      ApplicationContainer.instance().resolve<DashboardBloc>();
  HomeAnalyticsTimerController homeAnalyticsTimerController =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer(
      bloc: dashBoardBloc,
      listener: (context, state) {},
      builder: (context, state) {
        if (state is DashboardLoadedState) {
          return SliverWidget(
            isGeneric: widget.isGeneric,
            showBalance: true,
            children: <Widget>[
              SliverToBoxAdapter(
                child: CircuitBreakerWidget(
                  appContainer: ApplicationContainer.instance(),
                  reference: sessionBloc
                          .state.session?.selectedCondominium?.reference ??
                      "",
                  applicationRbac: ApplicationRbac.sindicoSaldo,
                  rbacEnabled:
                      sessionBloc.checkRback(ApplicationRbac.sindicoSaldo),
                  child: const CondominiumBalanceWidgetC(),
                ),
              ),
              SliverToBoxAdapter(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Visibility(
                    visible: sessionBloc.iSPreferencesPersonalizationActive,
                    child: InkWell(
                      onTap: () {
                        dashBoardBloc.animate.value = false;
                        Navigator.pushNamed(
                            context, ApplicationRoute.preferencesHome);
                      },
                      child: ValueListenableBuilder<bool>(
                        valueListenable: dashBoardBloc.animate,
                        builder: (BuildContext context, bool value, child) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: AvatarGlow(
                              animate: value,
                              glowColor:
                                  value ? theme.primaryColor : Colors.white,
                              glowRadiusFactor: 0.5,
                              child: Icon(
                                Icons.star_border_outlined,
                                size: 30.0,
                                color: LelloTheme.palleteOf(theme).grey(),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: Dimens.spacingMedium,
                    top: Dimens.spacingSmall,
                  ),
                  child: Text(
                    getString(context, "recent_access"),
                    style: LelloTextStyles.title(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).hubText(),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  sliver: _buildList(context, theme, state)),
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
                      location: BannerLocationEnum.home,
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
              )),
            ],
          );
        }
        return SliverWidget(
          isGeneric: widget.isGeneric,
          showBalance: true,
          children: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: Dimens.homeAppBarHeight),
                child: const Column(
                  children: [
                    Center(child: LoadingWidget()),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildList(
      BuildContext context, ThemeData theme, DashboardLoadedState state) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    List<HomeItemEnum?> itens =
        state.itens.map((e) => e.rbac(sessionBloc) ? e : null).toList();
    itens = itens.whereType<HomeItemEnum>().toList();

    return SliverGrid.count(
        childAspectRatio: 1.5,
        crossAxisCount: 2,
        mainAxisSpacing: Dimens.spacing,
        crossAxisSpacing: Dimens.spacing,
        children: [
          ...List.generate(itens.length, (index) {
            var item = itens[index]!;
            return CircuitBreakerWidget(
              appContainer: ApplicationContainer.instance(),
              reference:
                  sessionBloc.state.session?.selectedCondominium?.reference ??
                      "",
              applicationRbac: item.rbacString(),
              rbacEnabled: item.rbac(sessionBloc),
              child: HubButton(
                title: getString(context, item.title),
                icon: item.icon,
                onPressed: item.onTap(sessionBloc, context),
                isEnabled: item.isEnabled(sessionBloc),
                comingSoonBadge: item.comingSoonBadge(sessionBloc, context),
              ),
            );
          })
        ]);
  }
}
