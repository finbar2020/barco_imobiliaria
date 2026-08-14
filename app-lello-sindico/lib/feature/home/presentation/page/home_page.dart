import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:essentials/analytics/analytics_timer.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/messaging/message_handler.dart'
    as PushMessageHandler;
import 'package:lello/core/messaging/use_case/ghost_notification_usecase.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/core/widget/permission_notification_page.dart';
import 'package:lello/feature/accountability/presentation/list/page/accountability_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_page.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/home/presentation/widget/unit_selection_overlay.dart';
import 'package:lello/feature/consultant_lello/controller/consultant_lello_controller.dart';
import 'package:lello/feature/dashboard_preferences/presentation/page/notifications_preferences_page.dart';
import 'package:lello/feature/gdp/presentation/page/gdp_main_page.dart';
import 'package:lello/feature/notifications/notification_scope_label.dart';
import 'package:lello/feature/home/domain/entity/home_navigation_enum.dart';
import 'package:lello/feature/home/presentation/bloc/home_bloc.dart';
import 'package:lello/feature/home/presentation/bloc/home_state.dart';
import 'package:lello/feature/home/presentation/controllers/home_analytics_timer_controller.dart';
import 'package:lello/feature/home/presentation/controllers/home_navigation_tabs_resolver.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_bloc.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/bloc/home_dialogs_state.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/comfort_dialog/comfort_to_your_condo_dialog.dart';
import 'package:lello/feature/home/presentation/widget/home_dialogs/switch_role_alert_dialog/switch_role_alert_dialog_widget.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';
import 'package:lello/feature/payment/presentation/main_page/payment_main_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';
import 'package:lello/feature/space/presentation/page/space_menu_page.dart';
import 'package:lello/lello_app.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/enum/circuit_breaker_situation_enum.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/ghost_notification/data/model/ghost_notification_model.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class HomePageArgs {
  final SharedApplicationRedirectRoute? redirectRoute;
  HomePageArgs({this.redirectRoute});
}

class HomePage extends StatefulWidget {
  final bool isGeneric;
  final Function(ThemeData)? changeTheme;
  const HomePage({
    super.key,
    this.isGeneric = false,
    this.changeTheme,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  static const double _navHorizontalMargin = 24.0;
  static const double _navMaxBarWidth = 520.0;
  static const double _navBarHeight = 68.0;
  static const double _navIndicatorHeight = 4.0;
  static const double _navIconBottomSpacing = 3.0;
  static const double _navIconSize = 30.0;
  static const Color _navBackgroundColor = Color(0xFFF3F3F3);

  int currentPage = 0;
  final bloc = ApplicationContainer.instance().resolve<HomeBloc>();
  NotificationController notificationController =
      ApplicationContainer.instance().resolve<NotificationController>();
  SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  final CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve<CircuitBreakerController>();
  HomeAnalyticsTimerController homeAnalyticsTimerController =
      ApplicationContainer.instance().resolve();
  ConsultantController consultantController =
      ApplicationContainer.instance().resolve();
  late HomeNavigationTabsResolver tabsResolver;

  late HomeDialogBloc dialogBloc;
  late AnimationController _controller;
  late MeController meController;
  late GetToken getToken;
  late String reference;
  final AuthenticationStore loginStore =
      ApplicationContainer.instance().resolve();
  StreamSubscription? _subscription;

  PackageInfo? packageInfo;
  late AnalyticsTimer homeStartAnalyticsTimer;

  late GhostNotificationUsecase ghostNotificationUsecase;

  @override
  void initState() {
    //bloc.registerFcmToken();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration.zero);
    meController = ApplicationContainer.instance().resolve<MeController>();
    ghostNotificationUsecase =
        ApplicationContainer.instance().resolve<GhostNotificationUsecase>();
    getToken = ApplicationContainer.instance().resolve<GetToken>();

    reference =
        sessionBloc.state.session?.selectedCondominium?.reference.toString() ??
            "";
    consultantController.getConsultant(forceUpdate: false);
    dialogBloc = ApplicationContainer.instance().resolve<HomeDialogBloc>();
    tabsResolver = HomeNavigationTabsResolver(
      sessionBloc: sessionBloc,
      circuitBreakController: circuitBreakController,
    );
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _subscription = sessionBloc.stream.listen(_onSessionChanged);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _subscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        verifyLogoutGhostNotification();
        _subscription = sessionBloc.stream.listen(_onSessionChanged);
        notificationController.getNotificationList();
        homeAnalyticsTimerController.sindicoHomeTimerStart(5);
        break;
      case AppLifecycleState.paused:
        homeAnalyticsTimerController.sindicoHomeTimerStop();
        break;
      case AppLifecycleState.detached:
        homeAnalyticsTimerController.sindicoHomeTimerStop();
        break;
      default:
        break;
    }
  }

  void _onSessionChanged(SessionState sessionState) {
    if (!mounted) return;
    if (sessionState is SessionLoadedState) {
      homeAnalyticsTimerController.sindicoHomeTimerStart(4);
      if (redirectRote?.didRedirect == false &&
          sessionState.session?.selectedCondominium?.notificationContext ==
              redirectRote?.context &&
          mounted) {
        switchRedirect(redirectRote!);
      }
    }
  }

  SharedApplicationRedirectRoute? redirectRote;

  bool _isFirst = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    HomePageArgs? arguments =
        ModalRoute.of(context)?.settings.arguments as HomePageArgs?;

    /// Check if the session is loaded and the theme is generic
    if (sessionBloc.state is SessionLoadedState &&
        widget.isGeneric &&
        _isFirst) {
      _isFirst = false;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        changeTheme(sessionBloc.state as SessionLoadedState);
      });
    }

    print(
        'FCM: home - build - arguments?.redirectRoute?.inApp: ${arguments?.redirectRoute?.inApp}');
    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          bloc: sessionBloc,
          listener: (context, state) async {
            if (!mounted) return;
            if (state is SessionFailedState) {
              await _redirectExpireSession(state, context);
            } else if (state is SessionLoadedState) {
              if (state.switchFailed == true) {
                Flushbar(
                  duration: const Duration(seconds: 5),
                  message: getString(context, "error_switch_role"),
                ).show(context);
              } else {
                if (loginStore.bloc.state is AuthenticatedState) {
                  bloc.registerFcmToken();
                }
                changeTheme(state);
                notificationController.getNotificationList();
              }
            }
          },
        ),
        BlocListener<HomeDialogBloc, HomeDialogState>(
          bloc: dialogBloc,
          listener: (context, state) async {
            if (!mounted) return;
            if (state is NotificationPermissionState) {
              await Navigator.pushNamed(
                  context, ApplicationRoute.permissionNotification,
                  arguments: PermissionNotificationPageArgs(
                      isGeneric: widget.isGeneric));
              dialogBloc.initialState();
            } else if (state is ToYourCondoNewsState) {
              await ComfortToYourCondoDialog.show(
                context: context,
              );
              dialogBloc.initialState();
            } else if (state is AlertSwitchRoleState) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (dialogContext) => SwitchRoleAlertDialogWidget(
                        onPressed: () async {
                          Navigator.pop(dialogContext, true);
                          sessionBloc.selectCondominium(
                              state.switchCondominium, context);
                        },
                      ));
            }
          },
        ),
        // BlocListener<LelloHubBloc, LelloHubState>(
        //   bloc: lelloHubBloc,
        //   listener: (context, state) {},
        // ),
      ],
      child: PushMessageHandler.MessageHandler(
        notificationController: notificationController,
        appWidget: BlocBuilder<SessionBloc, SessionState>(
          bloc: sessionBloc,
          builder: (context, state) {
            if (state is SessionEmptyState) {
              print('FCM: home - build - SessionEmptyState');
              return _buildLoading(theme);
            } else if (state is SessionLoadedState) {
              print('FCM: home - build - SessionLoadedState');
              if (arguments != null) {
                checkNotificationArgs(arguments, context, state);
              }
              return _buildBody(theme, state);
            } else if (state is SessionLoadingState) {
              print('FCM: home - build - SessionLoadingState');
              return _buildLoading(theme);
            } else if (state is SessionFailedState) {
              print('FCM: home - build - SessionFailedState');
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                _redirectExpireSession(state, context);
              });
              return Material(child: Container());
            } else {
              return Material(child: Container());
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoading(ThemeData theme) {
    return Material(
      child: Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CircularProgressIndicator(),
              SizedBox(height: Dimens.spacingLarge),
              Text(getString(context, "home_page_fetching_profile"),
                  style: LelloTextStyles.title(theme)),
              SizedBox(height: Dimens.spacingSmall),
              Text(getString(context, "please_wait"),
                  style: LelloTextStyles.subBody(theme)),
            ],
          ))),
    );
  }

  Widget _buildBody(ThemeData theme, SessionLoadedState loadedState) {
    final itens = _buildVisibleNavigationTabs(loadedState);
    _syncCurrentPage(itens);
    final safePage = _safeCurrentPage(itens);
    final currentTab = _tabForIndex(safePage, itens);
    return Theme(
      data: theme,
      child: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) {
            if (state.showCondominumSelector) {
              _controller.forward();
            } else {
              _controller.reverse();
            }
          },
          builder: (context, state) => PopScope(
            canPop: _canSystemPop(itens, state),
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop) {
                _onSystemBackPressed(itens, state);
              }
            },
            child: Stack(
              children: [
                Scaffold(
                  bottomNavigationBar: _buildFloatingBottomBar(theme, itens),
                  body: currentTab?.body(
                        widget.isGeneric,
                        context,
                        sessionBloc,
                        notificationController,
                        redirectRote,
                      ) ??
                      const SizedBox.shrink(),
                ),
                _buildOverlay(state, sessionBloc, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ──── Floating pill-shaped Bottom Bar (matches Morar pattern) ────

  Widget _buildFloatingBottomBar(
      ThemeData theme, List<HomeNavigationItemEnum> itens) {
    if (itens.isEmpty) return const SizedBox.shrink();

    final pallete = LelloTheme.palleteOf(theme);

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
                  snakeViewColor: _navBackgroundColor,
                  selectedItemColor: pallete.primary(),
                  unselectedItemColor: pallete.hubText(),
                  backgroundColor: _navBackgroundColor,
                  showUnselectedLabels: false,
                  showSelectedLabels: false,
                  currentIndex: currentPage,
                  elevation: 0,
                  onTap: (index) {
                    if (currentPage != index) {
                      if (currentPage == 0) {
                        homeAnalyticsTimerController.sindicoHomeTimerStop();
                      }
                      if (index == 0) {
                        homeAnalyticsTimerController.sindicoHomeTimerStart(6);
                      }
                      setState(() {
                        currentPage = index;
                      });
                    }
                  },
                  items: itens
                      .map((e) => _buildBottomBarItem(
                            item: e,
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
    required HomeNavigationItemEnum item,
    required Color primaryColor,
  }) {
    return BottomNavigationBarItem(
      icon: _buildBottomBarIcon(
        icon: item.icon(notificationController.bloc),
        selected: false,
        primaryColor: primaryColor,
      ),
      activeIcon: _buildBottomBarIcon(
        icon: item.activeIcon(notificationController.bloc, primaryColor),
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

  Widget _buildOverlay(
      HomeState state, SessionBloc sessionBloc, ThemeData theme) {
    if (state.showCondominumSelector == false) {
      return const SizedBox.shrink();
    }
    return Positioned.fill(
      child: BlocBuilder<SessionBloc, SessionState>(
        bloc: sessionBloc,
        builder: (context, state) {
          final session = state.session;
          return UnitSelectionOverlay(
            condominiums: session?.me?.condominiums ?? [],
            sessionState: state,
            onCondominiumSelected: (condo) {
              sessionBloc.selectCondominium(condo, context);
              bloc.collapseCondominiumSelector();
            },
            onClose: () {
              bloc.collapseCondominiumSelector();
            },
          );
        },
      ),
    );
  }

  List<HomeNavigationItemEnum> _buildAvailableNavigationTabs(
      SessionLoadedState loadedState) {
    final itens =
        loadedState.itens?.whereType<HomeNavigationItemEnum>().toList() ??
            [
              HomeNavigationItemEnum.home,
              HomeNavigationItemEnum.condominium,
              HomeNavigationItemEnum.lello,
            ];

    if (_canRedirect(
          applicationRbac: ApplicationRbac.sindicoComodidades,
          sessionBloc: sessionBloc,
        ) &&
        !itens.contains(HomeNavigationItemEnum.comfort)) {
      itens.add(HomeNavigationItemEnum.comfort);
    }

    return itens;
  }

  List<HomeNavigationItemEnum> _buildVisibleNavigationTabs(
      SessionLoadedState loadedState) {
    final availableTabs = _buildAvailableNavigationTabs(loadedState);
    return tabsResolver.resolveVisibleTabs(availableTabs: availableTabs);
  }

  int _safeCurrentPage(List<HomeNavigationItemEnum> visibleTabs) {
    if (visibleTabs.isEmpty) {
      return 0;
    }

    return currentPage.clamp(0, visibleTabs.length - 1).toInt();
  }

  void _syncCurrentPage(List<HomeNavigationItemEnum> visibleTabs) {
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

  HomeNavigationItemEnum? _tabForIndex(
    int index,
    List<HomeNavigationItemEnum> visibleTabs,
  ) {
    if (visibleTabs.isEmpty || index < 0 || index >= visibleTabs.length) {
      return null;
    }

    return visibleTabs[index];
  }

  int _homeTabIndex(List<HomeNavigationItemEnum> visibleTabs) {
    final index =
        visibleTabs.indexWhere((tab) => tab == HomeNavigationItemEnum.home);
    if (index >= 0) {
      return index;
    }

    return _safeCurrentPage(visibleTabs);
  }

  void _changeCurrentPage(
    int index, {
    required List<HomeNavigationItemEnum> visibleTabs,
  }) {
    if (visibleTabs.isEmpty || currentPage == index) {
      return;
    }

    final previousTab = _tabForIndex(currentPage, visibleTabs);
    final nextTab = _tabForIndex(index, visibleTabs);

    if (previousTab == HomeNavigationItemEnum.home) {
      homeAnalyticsTimerController.sindicoHomeTimerStop();
    }

    if (nextTab == HomeNavigationItemEnum.home) {
      homeAnalyticsTimerController.sindicoHomeTimerStart(6);
    }

    setState(() {
      currentPage = index;
    });

    if (visibleTabs.isNotEmpty &&
        visibleTabs.first == HomeNavigationItemEnum.home) {
      ManagerAnalyticsLogEvents.logEvent(
        event: AnalyticsEventsManager.clickNotificacao(),
        referenceValue:
            sessionBloc.state.session?.selectedCondominium?.reference ?? '',
      );
    }
  }

  void _jumpToTab(
    HomeNavigationItemEnum tab, {
    required List<HomeNavigationItemEnum> visibleTabs,
  }) {
    final index = visibleTabs.indexWhere((visibleTab) => visibleTab == tab);
    if (index < 0) {
      return;
    }

    _changeCurrentPage(index, visibleTabs: visibleTabs);
  }

  bool _canSystemPop(
    List<HomeNavigationItemEnum> visibleTabs,
    HomeState state,
  ) {
    if (state.showCondominumSelector) {
      return false;
    }

    if (visibleTabs.isEmpty) {
      return true;
    }

    return _safeCurrentPage(visibleTabs) == _homeTabIndex(visibleTabs);
  }

  bool _onSystemBackPressed(
    List<HomeNavigationItemEnum> visibleTabs,
    HomeState state,
  ) {
    if (state.showCondominumSelector) {
      bloc.collapseCondominiumSelector();
      return false;
    }

    final safeCurrentPage = _safeCurrentPage(visibleTabs);
    final homeIndex = _homeTabIndex(visibleTabs);

    if (visibleTabs.isNotEmpty && safeCurrentPage != homeIndex) {
      _jumpToTab(HomeNavigationItemEnum.home, visibleTabs: visibleTabs);
      return false;
    }

    return true;
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

  void switchRedirect(SharedApplicationRedirectRoute redirectRousdte) {
    //identifica e redireciona rota
    if (kDebugMode) {
      print(redirectRousdte);
    }
    String? newRote;
    Object arguments = [];
    FeaturesRoutesEnum? routesEnum =
        stringToEnum(FeaturesRoutesEnum.values, redirectRousdte.rote);

    switch (routesEnum) {
      //Acordos
      case FeaturesRoutesEnum.ACORDO_APROVADO_AUTOMATICAMENTE:
      case FeaturesRoutesEnum.ACORDO_PROPOSTA:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoAcordos,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.agreements;
          arguments = AgreementsPageArgs(
              agreementsNotificationContext: redirectRousdte.objectId,
              route: routesEnum);
          break;
        }
        break;

      //Ocorrencia
      case FeaturesRoutesEnum.OCORRENCIA_RESPOSTA:
      case FeaturesRoutesEnum.OCORRENCIA_NOVA:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoOcorrencias,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.reportsBook;
          arguments = ReportsPageArgs(
              reportsNotificationContext: redirectRousdte.objectId);
          break;
        }
        break;
      //Despesas
      case FeaturesRoutesEnum.DESPESAS_APROVACAO:
      case FeaturesRoutesEnum.DESPESAS_PAGAMENTO_NOVO:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoDespesas,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.payment;
          arguments = PaymentMainPageArgs(
              paymentNotificationContext: redirectRousdte.objectId,
              route: routesEnum);
          break;
        }
        break;

      //PPC
      case FeaturesRoutesEnum.PPC_DISPONIVEL:
      case FeaturesRoutesEnum.PPC_MES_FECHADO:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoPpc,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.accountability;
          arguments = AccountabilityPageArgs(
              accountabilityNotificationContext: redirectRousdte.objectId);
          break;
        }
        break;
      //Reservas
      case FeaturesRoutesEnum.RESERVA_AREA:
      case FeaturesRoutesEnum.RESERVA_MUDANCAS:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoReservas,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.space;
          arguments = SpaceMenuPageArgs(
              reserveNotificationContext: redirectRousdte.objectId);
          break;
        }
        break;

      //Gestao tecnica operacional
      case FeaturesRoutesEnum.GESTAO_TECNICA:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoGestaoDeManutencao,
            sessionBloc: sessionBloc)) {
          newRote = ApplicationRoute.maintenanceManagement;
          break;
        }
        break;

      //Comodidades
      case FeaturesRoutesEnum.COMODIDADES:
      case FeaturesRoutesEnum.COMODIDADES_CATEGORIA:
      case FeaturesRoutesEnum.COMODIDADES_PARCEIRO:
        if (_canRedirect(
            applicationRbac: ApplicationRbac.sindicoComodidades,
            sessionBloc: sessionBloc)) {
          newRote = SharedApplicationRoute.comfort;
          arguments = ComfortPageArgs(
            appOriginEnum: AppOriginEnum.manager,
            reference: reference,
            route: routesEnum,
            accessRouteOrigin: ComfortPageOriginEnum.inAppNotification,
            comfortNotificationContext: redirectRousdte.objectId,
            checkFavorites: (_canRedirect(
                applicationRbac: ApplicationRbac.sindicoComodidadesFavoritos,
                sessionBloc: sessionBloc)),
            checkOffers: (_canRedirect(
                applicationRbac: ApplicationRbac.sindicoComodidadesOfertas,
                sessionBloc: sessionBloc)),
            checkRequest: (_canRedirect(
                applicationRbac: ApplicationRbac.sindicoComodidadesSolicitacoes,
                sessionBloc: sessionBloc)),
            checkYourCondo: (_canRedirect(
                applicationRbac:
                    ApplicationRbac.sindicoComodidadesSeuCondominio,
                sessionBloc: sessionBloc)),
          );
          break;
        }
        break;

      //GDP

      case FeaturesRoutesEnum.ALERTA_FALTAS:
      case FeaturesRoutesEnum.ALERTA_HORAS_EXTRAS:
      case FeaturesRoutesEnum.ALERTA_HORAS_ATRASO:
      case FeaturesRoutesEnum.ALERTA_ASSINATURA_SINDICO:
      case FeaturesRoutesEnum.ALERTA_ASSINATURA_FUNCIONARIO:
        newRote = SharedApplicationRoute.gdp;
        arguments = GdpPageArgs(
          route: routesEnum!,
          gdpNotificationContext: redirectRousdte.objectId!,
        );
      //InApp
      case FeaturesRoutesEnum.NOTIFICACOES_NAO_LIDAS:
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          if (mounted) {
            _navigateToNotifications();
            notificationController.setRedirectNotification(
              redirectRousdte.notificationId,
              redirectRousdte.uuidGroup,
            );
          }
        });
        break;
      case FeaturesRoutesEnum.PORTARIA_BLOQUEADA:
      case FeaturesRoutesEnum.PORTARIA_LIBERADA:
        break;
      default:
        if (LelloApp.routes.keys
            .any((element) => element == redirectRousdte.rote)) {
          newRote = redirectRousdte.rote;
        }
    }
    if (newRote != null) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted) {
          log("Redirecting to $newRote");
          Navigator.pushNamed(context, newRote!, arguments: arguments);
        }
      });
    }
    //apaga rote antigo
    redirectRote?.didRedirect = true;
  }

  void checkNotificationArgs(
      HomePageArgs arguments, BuildContext context, SessionLoadedState state) {
    print('FCM: checkNotificationArgs - arguments: ${arguments.redirectRoute}');
    if (arguments.redirectRoute != null && //se tem
        arguments.redirectRoute?.uuid.toString() != //se mão foi usado
            redirectRote?.uuid.toString()) {
      redirectRote = arguments.redirectRoute;
      //se inApp ou se não tem context (referencia/unidade) ir para inApp que tem todas as infos
      if (arguments.redirectRoute?.inApp == true ||
          arguments.redirectRoute?.context == null) {
        switchRedirect(SharedApplicationRedirectRoute(
          rote: "NOTIFICACOES_NAO_LIDAS",
          context: arguments.redirectRoute?.context ?? "",
          objectId: arguments.redirectRoute?.objectId ?? "",
          inApp: false,
          notificationId: arguments.redirectRoute?.notificationId ?? "",
          uuidGroup: arguments.redirectRoute?.uuidGroup ?? "",
        ));
      } else if (state.session?.selectedCondominium?.notificationContext !=
          redirectRote?.context) {
        Condominium? switchCondominium = state.session?.me?.condominiums!
            .cast<Condominium?>()
            .firstWhere(
                (element) =>
                    element?.notificationContext == redirectRote?.context,
                orElse: () => null);

        if (switchCondominium != null) {
          dialogBloc.switchRolesNeeded(switchCondominium);
        } else {
          switchRedirect(redirectRote!);
        }
      } else {
        if (mounted) {
          switchRedirect(redirectRote!);
        }
      }
    }
  }

  changeTheme(SessionLoadedState state) {
    if (widget.isGeneric) {
      if (state.session?.selectedCondominium?.layout != null) {
        var layout = state.session!.selectedCondominium!.layout;
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

  bool _canRedirect(
      {required String applicationRbac, required SessionBloc sessionBloc}) {
    CircuitBreakerController circuitBreakController =
        ApplicationContainer.instance().resolve();
    var itemRule = circuitBreakController.getRule(
        applicationRbac: applicationRbac,
        reference:
            sessionBloc.state.session?.selectedCondominium?.reference ?? "");
    if (itemRule?.situation == CircuitBreakerSituationEnum.hide ||
        !sessionBloc.checkRback(applicationRbac)) return false;
    return true;
  }

  void _navigateToNotifications() {
    ManagerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsManager.clickNotificacao(),
      referenceValue:
          sessionBloc.state.session?.selectedCondominium?.reference ?? "",
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NotificationListPage(
          dialogBloc: dialogBloc,
          homeBloc: bloc,
          onConfigurationTap: sessionBloc
                  .checkRback(ApplicationRbac.sindicoPreferenciasNotificacoes)
              ? () {
                  NotificationsPreferencesPage.show(context);
                }
              : null,
          closeOverlay: () => Navigator.of(context).pop(),
          sessionBloc: sessionBloc,
          appOriginEnum: AppOriginEnum.manager,
          HomeNavigationPage: const HomePage(),
          applicationContainer: ApplicationContainer.instance(),
          scopeLabelBuilder: (notification) => buildNotificationScopeLabel(
              notification, sessionBloc.state.session?.me),
          onTap: (notification) {
            HomeNavigationItemExtension(HomeNavigationItemEnum.home)
                .notificationDetailRedirect(
                    notification, sessionBloc, context, redirectRote);
          },
          notificationController: notificationController,
        ),
      ),
    );
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
}
