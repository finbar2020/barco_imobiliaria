import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc.dart';
import 'package:lello/feature/home/presentation/page/home_page.dart';
import 'package:lello/feature/home/presentation/widget/home_app_bar.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/dashboard_preferences/presentation/page/notifications_preferences_page.dart';
import 'package:lello/feature/notifications/notification_scope_label.dart';
import 'package:shared_features/shared_features.dart';

class HomeSliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final bool showBalance;
  final Function? onExpanded;
  final pendencyNumber;
  final bool isGeneric;
  final VoidCallback? onNotificationTap;

  final radius = 8.0;

  HomeSliverAppBarDelegate({
    this.showBalance = true,
    this.onExpanded,
    this.pendencyNumber,
    this.isGeneric = false,
    this.onNotificationTap,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Wrap(children: [
      Container(
        child: Container(
          color: Colors.transparent,
          child: Stack(children: [
            _buildContent(context, shrinkOffset),
          ]),
        ),
      ),
    ]);
  }

  Widget _buildContent(BuildContext context, double shrinkOffset) {
    final bloc = BlocProvider.of<HomeBloc>(context);
    NotificationController notificationController =
        ApplicationContainer.instance().resolve<NotificationController>();

    return Container(
      clipBehavior: Clip.none,
      child: Column(
        children: <Widget>[
          HomeAppBar(
            isGeneric: isGeneric,
            gestureOnTap: () {
              _onAppBarTapped(context);
            },
            isDropdownOpen: bloc.state.showCondominumSelector,
            pictureOnTap: () {},
            onNotificationTap: onNotificationTap ??
                () {
                  final sessionBloc =
                      ApplicationContainer.instance().resolve<SessionBloc>();

                  ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.clickNotificacao(),
                    referenceValue: sessionBloc
                            .state.session?.selectedCondominium?.reference ??
                        "",
                  );

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => NotificationListPage(
                        dialogBloc: null,
                        homeBloc: bloc,
                        onConfigurationTap: sessionBloc.checkRback(
                                ApplicationRbac.sindicoPreferenciasNotificacoes)
                            ? () {
                                NotificationsPreferencesPage.show(context);
                              }
                            : null,
                        closeOverlay: () => Navigator.of(context).pop(),
                        sessionBloc: sessionBloc,
                        appOriginEnum: AppOriginEnum.manager,
                        HomeNavigationPage: const HomePage(),
                        applicationContainer: ApplicationContainer.instance(),
                        scopeLabelBuilder: (notification) =>
                            buildNotificationScopeLabel(notification,
                                sessionBloc.state.session?.me),
                        onTap: (notification) {
                          HomeNavigationItemExtension(
                                  HomeNavigationItemEnum.home)
                              .notificationDetailRedirect(
                                  notification, sessionBloc, context, null);
                        },
                        notificationController: notificationController,
                      ),
                    ),
                  );
                },
            notificationListBloc: notificationController.bloc,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => Dimens.homeAppBarHeight - 20;

  @override
  double get minExtent => Dimens.homeBalanceHeightCollapsed;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  void _onAppBarTapped(BuildContext context) {
    final HomeBloc bloc = BlocProvider.of<HomeBloc>(context);
    if (bloc.state.showCondominumSelector) {
      bloc.collapseCondominiumSelector();
    } else {
      bloc.showCondominiumSelector();
    }
    onExpanded!(bloc.state.showCondominumSelector);
  }
}
