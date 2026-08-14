import 'dart:async';
import 'dart:convert';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart' hide BlendMode, Image, Animation;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/messaging/message_handler.dart'
    as PushMessageHandler;
import 'package:morar/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/hex_color.dart';
import 'package:morar/core/widgets/permission_notification_page.dart';
import 'package:morar/feature/home/domain/entity/home_item.dart';
import 'package:morar/feature/home/domain/entity/unity.dart';
import 'package:morar/feature/home/presentation/bloc/home_bloc.dart';
import 'package:morar/feature/home/presentation/controllers/home_navigation_redirect_resolver.dart';
import 'package:morar/feature/home/presentation/controllers/home_navigation_tabs_resolver.dart';

import 'package:morar/feature/home/presentation/widget/empty_state_widget.dart';
import 'package:morar/feature/home/presentation/widget/expiration_dialog.dart';
import 'package:morar/feature/home/presentation/widget/home_app_bar.dart';
import 'package:morar/feature/home/presentation/widget/unit_selection_overlay.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:morar/feature/home/presentation/widget/home_dialogs/widgets/switch_role_alert_dialog/switch_role_alert_dialog_widget.dart';
import 'package:morar/feature/home/presentation/widget/pages/comodities_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/easy_fix_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/home_page.dart';
import 'package:morar/feature/home/presentation/widget/pages/unity_page.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/pages/notifications_preferences.dart';
import 'package:morar/feature/me/domain/entity/condominium.dart';
import 'package:morar/feature/me/presentation/bloc/me_bloc.dart';
import 'package:morar/feature/notifications/notification_scope_label.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/session/presentation/bloc/session_state.dart';
import 'package:morar/lello_app.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';

import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/feature/notifications/data/models/notification_model.dart';
import 'package:shared_features/shared_features.dart';

import '../../../me/domain/entity/me.dart';
import '../../../sub_user/presentation/pages/edit/send_access_renew_request_success_page.dart';

class HomeNavigationPageArgs {
  final SharedApplicationRedirectRoute? redirectRoute;

  HomeNavigationPageArgs({this.redirectRoute});
}

class _HomeNavigationTabItem {
  final HomeNavigationTab tab;
  final HomeItem item;

  _HomeNavigationTabItem({
    required this.tab,
    required this.item,
  });
}

class HomeNavigationPage extends StatefulWidget {
  final bool isGeneric;
  final Function(ThemeData)? changeTheme;
  final String? talkToLelloWhatsAppNumber;

  const HomeNavigationPage({
    Key? key,
    this.isGeneric = false,
    this.changeTheme,
    this.talkToLelloWhatsAppNumber,
  }) : super(key: key);

  @override
  _HomeNavigationPageState createState() => _HomeNavigationPageState();
}

class _HomeNavigationPageState extends State<HomeNavigationPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const double _navHorizontalMargin = 24.0;
  static const double _navMaxBarWidth = 520.0;
  static const double _navBarHeight = 68.0;
  static const double _navIndicatorHeight = 4.0;
  static const double _navIconBottomSpacing = 3.0;
  static const double _navIconSize = 30.0;
  static const Color _navBackgroundColor = Color(0xFFF3F3F3);

  int currentPage = 0;
  final homeBloc = ApplicationContainer.instance().resolve<HomeBloc>();
  final NotificationController notificationController =
      ApplicationContainer.instance().resolve<NotificationController>();
  final CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve<CircuitBreakerController>();
  late HomeNavigationTabsResolver tabsResolver;
  late HomeNavigationRedirectResolver redirectResolver;
  SharedPreferences? sharedPreferences;

  bool isDropdownOpen = false;

  List<_HomeNavigationTabItem> _allTabs() => [
        _HomeNavigationTabItem(
          tab: HomeNavigationTab.home,
          item: HomeItem(
            icon: _getIcon("assets/ic_home.svg"),
            activeIcon: _getActiveIcon("assets/ic_home_selected.svg"),
            title: "home",
            child: HomePage(
              closeOverlay: closeOverLay,
              isGeneric: widget.isGeneric,
              pictureOnTap: () {
                closeOverLay();
                Navigator.of(context).pushNamed(ApplicationRoute.me);
              },
              onNavigateToComodidades: () {
                _jumpToTab(HomeNavigationTab.comodities);
              },
            ),
          ),
        ),
        _HomeNavigationTabItem(
          tab: HomeNavigationTab.easyFix,
          item: HomeItem(
            icon: _getIcon("assets/ic_easy_fix.svg"),
            activeIcon: _getActiveIcon("assets/ic_easy_fix_selected.svg"),
            title: "easy_fix",
            child: EasyFixPage(
              closeOverlay: closeOverLay,
              isGeneric: widget.isGeneric,
              talkToLelloWhatsAppNumber: widget.talkToLelloWhatsAppNumber,
            ),
          ),
        ),
        _HomeNavigationTabItem(
          tab: HomeNavigationTab.unity,
          item: HomeItem(
            icon: _getIcon("assets/ic_unity.svg"),
            activeIcon: _getActiveIcon("assets/ic_unity_selected.svg"),
            title: "units_title",
            child: UnityPage(closeOverlay: closeOverLay),
          ),
        ),
        _HomeNavigationTabItem(
          tab: HomeNavigationTab.comodities,
          item: HomeItem(
            icon: _getIcon("assets/ic_comfort.svg"),
            activeIcon: _getActiveIcon("assets/ic_comfort_selected.svg"),
            title: "comfort",
            child: ComoditiesPage(closeOverlay: closeOverLay),
          ),
        ),
      ];

  List<_HomeNavigationTabItem> _visibleTabs() {
    final visibleTabs = tabsResolver.resolveVisibleTabs().toSet();
    return _allTabs()
        .where((tabItem) => visibleTabs.contains(tabItem.tab))
        .toList();
  }

  int _safeCurrentPage(List<_HomeNavigationTabItem> visibleTabs) {
    if (visibleTabs.isEmpty) {
      return 0;
    }
    return currentPage.clamp(0, visibleTabs.length - 1).toInt();
  }

  void _syncCurrentPage(List<_HomeNavigationTabItem> visibleTabs) {
    final safePage = _safeCurrentPage(visibleTabs);
    if (safePage == currentPage) {
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        currentPage = safePage;
      });
    });
  }

  void _changeCurrentPage(int index) {
    setState(() {
      isDropdownOpen = false;
      currentPage = index;
    });
    notificationController.setState(notificationController.bloc.state);
  }

  void _jumpToTab(
    HomeNavigationTab tab, {
    List<_HomeNavigationTabItem>? visibleTabs,
  }) {
    final tabs = visibleTabs ?? _visibleTabs();
    final index = tabs.indexWhere((tabItem) => tabItem.tab == tab);
    if (index < 0) {
      return;
    }
    _changeCurrentPage(index);
  }

  int _homeTabIndex(List<_HomeNavigationTabItem> visibleTabs) {
    final index = visibleTabs
        .indexWhere((tabItem) => tabItem.tab == HomeNavigationTab.home);
    if (index >= 0) {
      return index;
    }
    return _safeCurrentPage(visibleTabs);
  }

  Future<bool> _onSystemBackPressed(
    List<_HomeNavigationTabItem> visibleTabs,
  ) async {
    if (isDropdownOpen) {
      setState(() {
        isDropdownOpen = false;
      });
      return false;
    }

    final safeCurrentPage = _safeCurrentPage(visibleTabs);
    final homeIndex = _homeTabIndex(visibleTabs);

    if (safeCurrentPage != homeIndex) {
      _changeCurrentPage(homeIndex);
      return false;
    }

    // Already on Home root: let the system handle back (minimize/close app).
    return true;
  }

  SvgPicture _getIcon(String svgPath) {
    return SvgPicture.asset(
      svgPath,
      height: _navIconSize,
      width: _navIconSize,
    );
  }

  SvgPicture _getActiveIcon(String svgPath) {
    return SvgPicture.asset(
      svgPath,
      height: _navIconSize,
      width: _navIconSize,
      colorFilter: ColorFilter.mode(
        Theme.of(context).primaryColor,
        BlendMode.srcIn,
      ),
    );
  }

  late SessionBloc sessionBloc;
  late MeBloc meBloc;
  late HomeDialogBloc dialogBloc;
  late GetToken getToken;
  bool showDialogAlert = false;
  bool showExpirationDialog = true;

  StreamSubscription? _subscription;

  late GhostNotificationUsecase ghostNotificationUsecase;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    sessionBloc = BlocProvider.of(context);
    tabsResolver = HomeNavigationTabsResolver(
      sessionBloc: sessionBloc,
      circuitBreakController: circuitBreakController,
    );
    redirectResolver = HomeNavigationRedirectResolver(
      sessionBloc: sessionBloc,
      isGeneric: widget.isGeneric,
    );
    meBloc = ApplicationContainer.instance().resolve<MeBloc>();
    dialogBloc = ApplicationContainer.instance().resolve<HomeDialogBloc>();
    getToken = ApplicationContainer.instance().resolve<GetToken>();
    ghostNotificationUsecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    //myBackgroundMessageHandler();
    //TODO: Check if session isnt loading and is null
    //sessionBloc.beginLoadSession();

    _subscription = this.sessionBloc.stream.listen(_onSessionChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notificationController.getNotificationList();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  void registerFcm() {
    homeBloc.registerFcmToken();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        verifyLogoutGhostNotification();
        _subscription = this.sessionBloc.stream.listen(_onSessionChanged);
        notificationController.getNotificationList();
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
      default:
        break;
    }
  }

  SharedApplicationRedirectRoute? _redirectRote;

  bool _isFirst = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    HomeNavigationPageArgs? arguments =
        ModalRoute.of(context)?.settings.arguments as HomeNavigationPageArgs?;

    /// Check if the session is loaded and the theme is generic
    if (sessionBloc.state is SessionLoadedState &&
        widget.isGeneric &&
        _isFirst) {
      _isFirst = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        changeTheme(this.sessionBloc.state as SessionLoadedState);
      });
    }

    print(
        'FCM: home - build - arguments?.redirectRoute?.inApp: ${arguments?.redirectRoute?.inApp}');

    return MultiBlocListener(
        listeners: [
          BlocListener<SessionBloc, SessionState>(
            bloc: sessionBloc,
            listener: (context, state) async {
              if (state is SessionFailedState) {
                await _redirectExpireSession(state, context);
              } else if (state is SessionLoadedState) {
                notificationController.getNotificationList();
                /*homeBloc.checkExpiration().then((isUnder30days) async {
                  sharedPreferences = await SharedPreferences.getInstance();
                  final show =
                      sharedPreferences?.getBool('show_expiration_dialog');
                  if (isUnder30days && (show == null || show == true)) {
                    if (showExpirationDialog) {
                      final isOwner = homeBloc.isOwner;
                      _showExpirationDialog(context, isOwner);
                    }
                  }
                });*/
                if (state.switchFailed == true) {
                  Flushbar(
                    duration: Duration(seconds: 5),
                    message: getString(context, "error_switch_role"),
                  )..show(context);
                } else {
                  registerFcm();
                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    changeTheme(state);
                  });
                }
              }
            },
          ),
          BlocListener<HomeDialogBloc, HomeDialogState>(
            bloc: dialogBloc,
            listener: (context, state) async {
              if (state is NotificationPermissionState) {
                await Navigator.pushNamed(
                    context, ApplicationRoute.permissionNotification,
                    arguments: PermissionNotificationPageArgs(
                        isGeneric: widget.isGeneric));
                dialogBloc.initialState();
              } else if (state is AlertSwitchRoleState && mounted) {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => SwitchRoleAlertDialogWidget(
                          onPressed: () async {
                            Navigator.pop(context, true);
                            selectUnity(
                              state.switchCondominium,
                              state.switchUnity,
                              sessionBloc.state,
                            );
                          },
                        ));
              }
            },
          ),
          BlocListener(
            bloc: notificationController.bloc,
            listener: (context, state) {},
          ),
        ],
        child: PushMessageHandler.MessageHandler(
          notificationController: notificationController,
          appWidget: BlocBuilder<SessionBloc, SessionState>(
            bloc: sessionBloc,
            builder: (context, state) {
              if (state is SessionInitialState) {
                debugPrint('FCM: home - build - SessionInitialState');
                return _buildLoading(theme);
              } else if (state is SessionLoadedState) {
                print('FCM: home - build - SessionLoadedState');
                if (arguments != null) {
                  checkNotificationArgs(arguments, context, state);
                }
                return _buildBody(theme, sessionBloc,
                    sessionBloc.state.session?.me?.allUnits ?? []);
              } else if (state is SessionLoadingState) {
                print('FCM: home - build - SessionLoadingState');
                return _buildLoading(theme);
              } else if (state is SessionFailedState) {
                print('FCM: home - build - SessionFailedState');
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await _redirectExpireSession(state, context);
                });
                return Container();
              } else
                return Container();
            },
          ),
        ));
  }

  Future<void> _redirectExpireSession(
      SessionFailedState state, BuildContext context) async {
    final userCpf = state.user?.cpf ?? "noCPF";
    final failure = state.failure.toString();

    sessionBloc.emptyState();

    final assTokn = (await getToken.call(null)).fold((l) => null, (r) => r);

    final accessToken = assTokn?.accessToken ?? "noToken";
    final refreshToken = assTokn?.refreshToken ?? "noRefresh";
    Navigator.pushNamedAndRemoveUntil(
      context,
      SharedApplicationRoute.expiredSession,
      (route) => false,
      arguments: ExpiredSessionArguments(
        reason: state.failure is KnownFailure
            ? (state.failure as KnownFailure).code
            : "Sessão expirada generico",
        cpf: userCpf,
        accessToken: accessToken,
        refreshToken: refreshToken,
        failure: failure.toString(),
        timestamp: DateTime.now().toIso8601String(),
        source: 'redirectExpireSession',
      ),
    );
  }

  void checkNotificationArgs(HomeNavigationPageArgs arguments,
      BuildContext context, SessionLoadedState state) {
    print('FCM: checkNotificationArgs - arguments: ${arguments.redirectRoute}');

    if (arguments.redirectRoute != null && //se tem
        arguments.redirectRoute?.uuid.toString() != //se mão foi usado
            this._redirectRote?.uuid.toString()) {
      this._redirectRote = arguments.redirectRoute;

      //se inApp ou se não tem context (referencia/unidade) ir para inApp que tem todas as infos
      if (arguments.redirectRoute?.inApp == true ||
          _redirectRote?.context == null) {
        switchRedirect(SharedApplicationRedirectRoute(
          rote: "NOTIFICACOES_NAO_LIDAS",
          context: arguments.redirectRoute?.context ?? "",
          objectId: arguments.redirectRoute?.objectId ?? "",
          inApp: false,
          notificationId: arguments.redirectRoute?.notificationId ?? "",
          uuidGroup: arguments.redirectRoute?.uuidGroup ?? "",
        ));
      } else if (state.session?.unity?.notificationContext !=
          _redirectRote?.context) {
        var switchUnity =
            state.session?.me?.allUnitsEntity.cast<Unity?>().firstWhere(
                  (element) =>
                      element?.notificationContext == _redirectRote?.context,
                  orElse: () => null,
                );
        Condominium? switchCondominium = state.session?.me?.condominiums!
            .cast<Condominium?>()
            .firstWhere(
                (element) =>
                    element?.blocks?.any((element) =>
                        element.units?.any((element) =>
                            element.notificationContext ==
                            _redirectRote?.context) ??
                        false) ??
                    false,
                orElse: () => null);

        if (switchUnity != null && switchCondominium != null) {
          dialogBloc.switchRolesNeeded(switchCondominium, switchUnity);
        }
      } else {
        if (mounted) {
          switchRedirect(_redirectRote!);
        }
      }
    }
  }

  Widget _buildLoading(ThemeData theme) {
    var pallete = LelloTheme.palleteOf(theme);
    return Container(
        color: pallete.customColor(),
        alignment: Alignment.center,
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: Dimens.spacingLarge),
            Text(getString(context, "home_page_fetching_profile"),
                style: LelloTextStyles.title(theme)),
            SizedBox(height: Dimens.spacingSmall),
            Text(getString(context, "please_wait"),
                style: LelloTextStyles.subBody(theme)),
          ],
        )));
  }

  Widget _buildBody(
      ThemeData theme, SessionBloc sessionBloc, List<List<dynamic>> units) {
    return Theme(
      data: theme,
      child: StreamBuilder<List<CircuitItemRule>>(
        stream: circuitBreakController.ruleStream.stream,
        builder: (context, _) {
          final visibleTabs = _visibleTabs();
          final safeCurrentPage = _safeCurrentPage(visibleTabs);
          _syncCurrentPage(visibleTabs);

          final currentItemTitle = visibleTabs.isNotEmpty
              ? visibleTabs[safeCurrentPage].item.title
              : "";

          return WillPopScope(
            onWillPop: () => _onSystemBackPressed(visibleTabs),
            child: Stack(
              children: [
                Scaffold(
                  appBar: currentItemTitle == "lello_club"
                      ? PreferredSize(
                          preferredSize: Size.fromHeight(0),
                          child: AppBar(),
                        )
                      : PreferredSize(
                          preferredSize: Size.fromHeight(
                              MediaQuery.of(context).padding.top + 72),
                          child: HomeAppBar(
                            isDropdownOpen: isDropdownOpen,
                            isGeneric: widget.isGeneric,
                            notificationListBloc: notificationController.bloc,
                            gestureOnTap: () {
                              setState(() {
                                isDropdownOpen = !isDropdownOpen;
                              });
                            },
                            pictureOnTap: () {
                              closeOverLay();
                              Navigator.of(context)
                                  .pushNamed(ApplicationRoute.me);
                            },
                            onNotificationTap: () {
                              closeOverLay();
                              _navigateToNotifications();
                            },
                          ),
                        ),
                  body: GestureDetector(
                    onTap: closeOverLay,
                    child: _buildBottomNavigationPages(
                      visibleTabs: visibleTabs,
                      currentIndex: safeCurrentPage,
                    ),
                  ),
                  bottomNavigationBar: _buildBottomNavigationBar(
                    context,
                    theme,
                    visibleTabs: visibleTabs,
                    currentIndex: safeCurrentPage,
                  ),
                ),
                if (isDropdownOpen)
                  Positioned.fill(
                    child: UnitSelectionOverlay(
                      units: units,
                      sessionState: sessionBloc.state,
                      onUnitSelected: (condo, unity) {
                        selectUnity(condo, unity, sessionBloc.state);
                      },
                      onClose: () {
                        setState(() {
                          isDropdownOpen = false;
                        });
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationPages({
    required List<_HomeNavigationTabItem> visibleTabs,
    required int currentIndex,
  }) {
    if (visibleTabs.isEmpty) {
      return const EmptyStateWidget();
    }

    return SizedBox.expand(
      child: GestureDetector(
        onTap: closeOverLay,
        child: IndexedStack(
          index: currentIndex,
          children: visibleTabs.map((tab) => tab.item.child).toList(),
        ),
      ),
    );
  }

  void _navigateToNotifications() {
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.notificacoesAcessar(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.title.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium!.reference.toString(),
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationListPage(
          dialogBloc: dialogBloc,
          homeBloc: homeBloc,
          closeOverlay: () => Navigator.of(context).pop(),
          sessionBloc: sessionBloc,
          appOriginEnum: AppOriginEnum.owner,
          HomeNavigationPage: HomeNavigationPage(),
          onConfigurationTap: () => PreferencesNotificationPage.show(context),
          applicationContainer: ApplicationContainer.instance(),
          checkRbac: sessionBloc
              .checkRback(ApplicationRbac.morarPreferenciasNotificacoes),
          scopeLabelBuilder: (notification) => buildNotificationScopeLabel(
              notification, sessionBloc.state.session?.me),
          onTap: (notification) {
            notificationDetailRedirect(notification);
          },
          notificationController: notificationController,
        ),
      ),
    );
  }

  void closeOverLay() {
    if (isDropdownOpen) {
      setState(() {
        isDropdownOpen = false;
      });
    }
  }

  Widget _buildBottomNavigationBar(
    BuildContext context,
    ThemeData theme, {
    required List<_HomeNavigationTabItem> visibleTabs,
    required int currentIndex,
  }) {
    if (visibleTabs.isEmpty) {
      return const SizedBox.shrink();
    }

    final pallete = LelloTheme.palleteOf(theme);
    const navBackground = _navBackgroundColor;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(
        left: _navHorizontalMargin,
        right: _navHorizontalMargin,
        bottom: 10,
      ),
      child: SizedBox(
        height: _navBarHeight,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _navMaxBarWidth),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: pallete.hubText().withOpacity(0.16),
                    blurRadius: 12,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: pallete.hubText().withOpacity(0.2),
                    blurRadius: 18,
                    offset: const Offset(-6, 8),
                  ),
                  BoxShadow(
                    color: pallete.hubText().withOpacity(0.2),
                    blurRadius: 18,
                    offset: const Offset(6, 8),
                  ),
                  BoxShadow(
                    color: pallete.hubText().withOpacity(0.28),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SnakeNavigationBar.color(
                  height: _navBarHeight,
                  behaviour: SnakeBarBehaviour.pinned,
                  snakeShape: SnakeShape.indicator,
                  snakeViewColor: navBackground,
                  selectedItemColor: pallete.primary(),
                  unselectedItemColor: pallete.hubText(),
                  backgroundColor: navBackground,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  currentIndex: currentIndex,
                  elevation: 0,
                  onTap: (index) {
                    _changeCurrentPage(index);
                  },
                  items: visibleTabs
                      .map((tab) => _buildBottomBarItem(
                            item: tab.item,
                            primaryColor: pallete.primary(),
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildBottomBarItem({
    required HomeItem item,
    required Color primaryColor,
  }) {
    return BottomNavigationBarItem(
      icon: _buildBottomBarIcon(
        icon: item.icon,
        selected: false,
        primaryColor: primaryColor,
      ),
      activeIcon: _buildBottomBarIcon(
        icon: item.activeIcon,
        selected: true,
        primaryColor: primaryColor,
      ),
      label: '',
    );
  }

  Widget _buildBottomBarIcon({
    required Widget icon,
    required bool selected,
    required Color primaryColor,
  }) {
    return SizedBox(
      height: _navBarHeight,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: _navIconBottomSpacing),
              child: icon,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              curve: Curves.easeOut,
              height: _navIndicatorHeight,
              width: double.infinity,
              color: selected ? primaryColor : Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }

  void selectUnity(Condominium condominium, Unity unity, SessionState state) {
    state.session?.unity = unity;
    state.session?.condominium = condominium;
    currentPage = 0;
    homeBloc.selectedUnity(unity);
  }

  void _onSessionChanged(SessionState sessionState) {
    if (sessionState is SessionLoadedState) {
      if (this._redirectRote?.didRedirect == false &&
          sessionState.session?.unity?.notificationContext ==
              this._redirectRote?.context &&
          mounted) {
        switchRedirect(this._redirectRote!);
      }
    }
  }

  void switchRedirect(SharedApplicationRedirectRoute redirectRousdte) {
    //identifica e redireciona rota
    print(redirectRousdte);

    final redirectResult = redirectResolver.resolve(redirectRousdte);

    switch (redirectResult.action) {
      case HomeRedirectAction.openNotifications:
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          print(
              'FCM: switchRedirect - uuidGroup: ${redirectRousdte.uuidGroup}');
          notificationController.setRedirectNotification(
            redirectRousdte.notificationId,
            redirectRousdte.uuidGroup,
          );
          _navigateToNotifications();
        });
        break;

      case HomeRedirectAction.openComoditiesTab:
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            _jumpToTab(HomeNavigationTab.comodities);
          }
        });
        break;

      case HomeRedirectAction.navigateRoute:
        if (redirectResult.route != null) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              Navigator.pushNamed(
                context,
                redirectResult.route!,
                arguments: redirectResult.arguments,
              );
            }
          });
        }
        break;

      case HomeRedirectAction.none:
        final fallbackRoute = redirectRousdte.rote;
        if (fallbackRoute != null &&
            LelloApp.routes.keys.any((element) => element == fallbackRoute)) {
          SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
            if (mounted) {
              Navigator.pushNamed(context, fallbackRoute);
            }
          });
        }
        break;
    }

    //apaga rote antigo
    this._redirectRote?.didRedirect = true;
  }

  notificationDetailRedirect(SingleNotification notification) {
    if (notification.canRedirect) {
      if (sessionBloc.state.session?.unity?.notificationContext !=
          notification.reference) {
        Unity? switchUnity = sessionBloc.state.session?.me?.allUnitsEntity
            .cast<Unity?>()
            .firstWhere(
              (element) =>
                  element?.notificationContext == notification.reference,
              orElse: () => null,
            );
        Condominium? switchCondominium = sessionBloc
            .state.session?.me?.condominiums!
            .cast<Condominium?>()
            .firstWhere(
                (element) =>
                    element?.blocks?.any((element) =>
                        element.units?.any((element) =>
                            element.notificationContext ==
                            notification.reference) ??
                        false) ??
                    false,
                orElse: () => null);

        if (switchUnity != null && switchCondominium != null) {
          Navigator.of(context).pushReplacementNamed(
            SharedApplicationRoute.home,
            arguments: HomeNavigationPageArgs(
              redirectRoute: SharedApplicationRedirectRoute(
                context: notification.reference!,
                rote: notification.redirectPath!,
                objectId: notification.redirectId,
                notificationId: notification.id,
                uuidGroup: notification.uuidGroup ?? "",
              ),
            ),
          );
        } else {
          switchRedirect(SharedApplicationRedirectRoute(
            context: notification.reference!,
            rote: notification.redirectPath!,
            objectId: notification.redirectId,
            notificationId: notification.id,
            uuidGroup: notification.uuidGroup ?? "",
          ));
        }
      } else {
        switchRedirect(SharedApplicationRedirectRoute(
          context: notification.reference!,
          rote: notification.redirectPath!,
          objectId: notification.redirectId,
          notificationId: notification.id,
          uuidGroup: notification.uuidGroup ?? "",
        ));
      }
    }
  }

  verifyLogoutGhostNotification() async {
    var preferences = await getSharedPreference();
    String? ghost =
        preferences.getString(SharedPreferencesKeys.ghostNotificationLogout);
    if (ghost != null && ghost.isNotEmpty) {
      GhostNotificationModel model = _deserialize(ghost);
      await preferences.setString(
          SharedPreferencesKeys.ghostNotificationLogout, "");
      ghostNotificationUsecase.call(GhostNotificationParams(
        id: model.id!,
        type: model.type ?? "LIMPEZA_DADOS",
      ));
    }
  }

  Future<SharedPreferences> getSharedPreference() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.reload();
    return instance;
  }

  GhostNotificationModel _deserialize(String serialized) =>
      GhostNotificationModel.fromJson(json.decode(serialized));

  changeTheme(SessionLoadedState state) {
    if (widget.isGeneric) {
      if (state.session?.condominium?.layout != null) {
        var layout = state.session!.condominium!.layout;
        Color? primary =
            layout!.primary.isEmpty ? null : HexColor(layout.primary);
        Color? secondary =
            layout.secondary.isEmpty ? null : HexColor(layout.secondary);
        bool isDark = false;

        //check session for override
        var overrideColor = sessionBloc.getThemeColor();
        if (overrideColor != null) {
          primary = overrideColor.primaryColor;
          secondary = overrideColor.secondaryColor;
          isDark = overrideColor.isDark ?? false;
        }
        if (primary != null && secondary != null) {
          if (widget.changeTheme != null) {
            ColorPallete initialTheme = isDark
                ? DarkPallete(primary: primary, secondary: secondary)
                : LightPallete(primary: primary, secondary: secondary);
            var newTheme = LelloTheme.themeWithPallete(
                isDark ? Brightness.dark : Brightness.light, initialTheme);
            widget.changeTheme!.call(newTheme);
          }
        }
      }
    }
  }

  Future<Map<String, dynamic>>? myBackgroundMessageHandler() {
    FirebaseMessaging.instance.getInitialMessage().then(
      (remoteMessage) {
        print('FCM: myBackgroundMessageHandler: $remoteMessage');
        print('FCM: myBackgroundMessageHandler: ${remoteMessage?.toMap()}');
        if (remoteMessage != null) {
          final NotificationModel data =
              NotificationModel.fromJson(remoteMessage.data);
          data.redirectId = remoteMessage.data["redirectId"];
          data.redirectPath = remoteMessage.data["redirectPath"];
          data.inApp = remoteMessage.data["inApp"];
          data.uuidGroup = remoteMessage.data["uuidGroup"];
          if (data.redirectId?.isNotEmpty == true &&
              data.redirectPath?.isNotEmpty == true &&
              data.reference?.isNotEmpty == true) {
            switchRedirect(SharedApplicationRedirectRoute(
              rote: data.redirectPath!,
              context: data.reference!,
              objectId: data.redirectId,
              notificationId: data.id,
              inApp: data.inApp ?? false,
              uuidGroup: data.uuidGroup ?? "",
            ));
          }
        }
      },
    );
    return null;
  }

  Future _showExpirationDialog(
    BuildContext context,
    bool isOwner,
  ) {
    showExpirationDialog = false;
    return showDialog(
      context: context,
      builder: (ctx) => Center(
        child: Dialog(
          child: ExpirationDialog(
            onRenewalRequestPressed: () async {
              final success = await homeBloc.requestAccessRenewal();
              if (success) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const SendAccessRenewRequestSuccessPage(),
                  ),
                );
              }
            },
            isOwner: isOwner,
            onChecked: (notShowAgain) {
              sharedPreferences?.setBool(
                  'show_expiration_dialog', !notShowAgain);
            },
          ),
        ),
      ),
    );
  }
}
