import 'dart:ui' as ui;

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lottie/lottie.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/condominium/domain/entity/condominium.dart';
import 'package:lello/feature/maintenance_management/domain/enum/tracking_trade_status.dart';
import 'package:lello/feature/maintenance_management/domain/entity/filter_options_entity.dart';
import 'package:lello/feature/maintenance_management/domain/entity/maintenance_management_entity.dart';
import '../../../../home/presentation/bloc/home_bloc.dart';
import '../../../../home/presentation/bloc/home_state.dart';
import '../../../../session/presentation/bloc/session_bloc.dart';
import '../../../../session/presentation/bloc/session_state.dart';
import '../bloc/maintenance_management_bloc.dart';
import '../bloc/maintenance_management_current_week/maintenance_management_current_week_bloc.dart';
import '../bloc/maintenance_management_current_week/maintenance_management_current_week_event.dart';
import '../bloc/maintenance_management_last_week/maintenance_management_last_week_bloc.dart';
import '../bloc/maintenance_management_last_week/maintenance_management_last_week_event.dart';
import '../bloc/maintenance_management_state.dart';

import '../model/maintancen_management_option_model.dart';
import '../widgets/maintenance_management_current_week_widget.dart';
import '../widgets/maintenance_management_last_week_widget.dart';
import '../widgets/condominium_info_grid.dart';
import 'maintenance_management_filters_page.dart';

class MaintenanceManagementPage extends StatefulWidget {
  const MaintenanceManagementPage({super.key});

  @override
  State<MaintenanceManagementPage> createState() =>
      _MaintenanceManagementPageState();
}

class _MaintenanceManagementPageState extends State<MaintenanceManagementPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final bloc =
      ApplicationContainer.instance().resolve<MaintenanceManagementBloc>();
  final homeBloc = ApplicationContainer.instance().resolve<HomeBloc>();
  final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
  final currentWeekBloc = ApplicationContainer.instance()
      .resolve<MaintenanceManagementCurrentWeekBloc>();
  final lastWeekBloc = ApplicationContainer.instance()
      .resolve<MaintenanceManagementLastWeekBloc>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  late final TabController tabController;
  static const double kPadding = 16.0;
  static const double kRadius = 8.0;
  static const double kSpacing = 8.0;

  int _selectedTabIndex = 0;
  String? _lastLoadedCondominiumId;
  String? _pendingSwitchCondominiumId;
  bool _isSwitchingCondominium = false;

  static const _scheduleOption = MaintenanceManagementOptionModel(
    title: 'maintenance_management_schedule',
    iconAssets: 'assets/ic_calendar.svg',
    routeName: '/agenda',
  );

  static const _legalEntitlementsOption = MaintenanceManagementOptionModel(
    title: 'maintenance_management_legal_entitlements',
    iconAssets: 'assets/icon_shield_check.svg',
    routeName: ApplicationRoute.maintenanceManagementLegalObligation,
  );

  static const _fullOptions = [
    MaintenanceManagementOptionModel(
      title: 'maintenance_management_create_task',
      iconAssets: 'assets/ic_add_mark.svg',
      routeName: ApplicationRoute.maintenanceManagementCreateTask,
    ),
    MaintenanceManagementOptionModel(
      title: 'maintenance_management_view_reports',
      iconAssets: 'assets/ic_chart.svg',
      routeName: ApplicationRoute.maintenanceManagementReports,
    ),
    _scheduleOption,
    MaintenanceManagementOptionModel(
      title: 'maintenance_management_conversations',
      iconAssets: 'assets/ic_hub_chat.svg',
      routeName: ApplicationRoute.maintenanceManagementChatConversations,
    ),
    _legalEntitlementsOption,
  ];

  static const _limitedOptions = [
    _scheduleOption,
    _legalEntitlementsOption,
  ];

  static const _serviceUnavailableBlockedRoutes = <String>{
    ApplicationRoute.maintenanceManagementCreateTask,
    ApplicationRoute.maintenanceManagementReports,
    ApplicationRoute.maintenanceManagementChatConversations,
  };

  List<MaintenanceManagementOptionModel> _optionsFor(
    CondominiumInfoEntity data,
  ) {
    if (_isServiceUnavailable(data)) {
      return _fullOptions;
    }
    return data.isTrackingTradeActive ? _fullOptions : _limitedOptions;
  }

  bool _isServiceUnavailable(CondominiumInfoEntity data) {
    return data.trackingTradeStatus == TrackingTradeStatus.serviceUnavailable;
  }

  bool _isBlockedByServiceUnavailable(String routeName) {
    return _serviceUnavailableBlockedRoutes.contains(routeName);
  }

  Object? _buildRouteArguments(
    MaintenanceManagementOptionModel option,
    CondominiumInfoEntity data,
    bool isTrackingTradeServiceUnavailable,
  ) {
    if (option.routeName ==
        ApplicationRoute.maintenanceManagementLegalObligation) {
      return {
        'hasEmployee': data.hasEmployee,
        'hasTechnicalInspection': data.hasTechnicalInspection,
      };
    }

    if (option.routeName == ApplicationRoute.agenda) {
      return {
        'isTrackingTradeServiceUnavailable': isTrackingTradeServiceUnavailable,
        'trackingTradeStatus': data.trackingTradeStatus?.apiValue,
      };
    }

    return null;
  }

  Future<void> _showServiceUnavailableBlockedModal(
    BuildContext context,
    ThemeData theme,
  ) async {
    final palette = LelloTheme.palleteOf(theme);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SvgPicture.asset(
                  'assets/ic_bella_not_available_error.svg',
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 16),
                Text(
                    getString(
                      dialogContext,
                      'maintenance_management_service_unavailable_modal_title',
                      defaultText: 'Serviço temporariamente indisponível.',
                    ),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.titleSmallBold(theme)),
                Text(
                    getString(
                      dialogContext,
                      'maintenance_management_service_unavailable_modal_description',
                      defaultText: 'Tente novamente mais tarde.',
                    ),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.titleSmallBold(theme)),
                const SizedBox(height: 20),
                PrimaryButton(
                  theme: theme,
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  text: getString(
                    dialogContext,
                    'close',
                    defaultText: 'Fechar',
                  ),
                  buttonColor: palette.primary(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      if (mounted && tabController.indexIsChanging) {
        setState(() {
          _selectedTabIndex = tabController.index;
        });
      }
    });
    bloc.fetchCondominiumInfo();
    bloc.fetchFilterOptions();
    _lastLoadedCondominiumId =
        sessionBloc.state.session?.selectedCondominium?.id;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void reloadData() {
    // Recarrega informações do condomínio
    bloc.fetchCondominiumInfo();

    // Recarrega opções de filtro
    bloc.fetchFilterOptions();

    // Recarrega dados da semana atual
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    currentWeekBloc.add(FetchMaintenanceTaskEventsEvent(
      dtStart: startOfWeek,
      untilDate: endOfWeek,
      dayCurrent: now,
      typeTask: _appliedFilters?['taskType'] ?? [],
      status: _appliedFilters?['taskStatus'] ?? [],
      assetIds: _appliedFilters?['assets'] ?? [],
      localIds: _appliedFilters?['locals'] ?? [],
      responsibleIds: _appliedFilters?['responsibles'] ?? [],
    ));

    // Recarrega dados da semana passada
    final lastWeekStart = startOfWeek.subtract(const Duration(days: 7));
    final lastWeekEnd = lastWeekStart.add(const Duration(days: 6));

    lastWeekBloc.add(FetchMaintenanceLastWeekEfficiencyEvent(
      startDate: lastWeekStart,
      endDate: lastWeekEnd,
    ));
  }

  void _handleSessionStateChange(SessionState sessionState) {
    if (!mounted) return;

    if (sessionState is SessionLoadingState) {
      if (_pendingSwitchCondominiumId != null && !_isSwitchingCondominium) {
        setState(() {
          _isSwitchingCondominium = true;
        });
      }
      return;
    }

    if (sessionState is! SessionLoadedState) {
      return;
    }

    final currentCondominiumId = sessionState.session?.selectedCondominium?.id;
    if (currentCondominiumId == null) {
      return;
    }

    _lastLoadedCondominiumId ??= currentCondominiumId;

    final hasCondominiumChanged =
        currentCondominiumId != _lastLoadedCondominiumId;
    final pendingSwitchResolved = _pendingSwitchCondominiumId != null &&
        (sessionState.switchFailed == true ||
            currentCondominiumId == _pendingSwitchCondominiumId);

    if (pendingSwitchResolved) {
      final shouldReload =
          sessionState.switchFailed != true && hasCondominiumChanged;

      setState(() {
        _isSwitchingCondominium = false;
        _pendingSwitchCondominiumId = null;
        if (shouldReload) {
          _appliedFilters = null;
        }
      });

      if (shouldReload) {
        _lastLoadedCondominiumId = currentCondominiumId;
        reloadData();
      }

      return;
    }

    if (_isSwitchingCondominium) {
      setState(() {
        _isSwitchingCondominium = false;
      });
    }

    if (hasCondominiumChanged) {
      setState(() {
        _appliedFilters = null;
      });
      _lastLoadedCondominiumId = currentCondominiumId;
      reloadData();
    }
  }

  /// Exibe modal informativo para erros específicos do startSession.
  ///
  /// Este modal é exibido quando o backend retorna códigos de erro específicos
  /// que indicam que o ambiente do usuário está sendo preparado:
  /// - CONDOMINIO_NAO_INTEGRADO
  /// - USER_PENDING_ACTIVATION
  ///
  /// Ao invés de mostrar a tela de erro padrão, exibe uma mensagem amigável
  /// informando que o usuário deve aguardar e tentar novamente mais tarde.
  void _showMaintenanceWarningModal(
      BuildContext context, CondominiumInfoEntity entity) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final theme = Theme.of(context);
        final palette = LelloTheme.palleteOf(theme);

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Texto principal
                Text(
                  'Seu ambiente está sendo preparado.',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.headline(theme)?.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                // Texto secundário em negrito
                Text(
                  'Volte novamente mais tarde.',
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.body(theme)?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: palette.text(),
                  ),
                ),
                const SizedBox(height: 32),
                // Botão OK
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    theme: theme,
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o modal
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/home', // Rota para home
                        (route) => false, // Remove todas as rotas da pilha
                      );
                    },
                    text: 'OK',
                    buttonColor: palette.primary(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider<MaintenanceManagementBloc>.value(value: bloc),
        BlocProvider<HomeBloc>.value(value: homeBloc),
        BlocProvider<SessionBloc>.value(value: sessionBloc),
        BlocProvider<MaintenanceManagementCurrentWeekBloc>.value(
          value: currentWeekBloc,
        ),
        BlocProvider<MaintenanceManagementLastWeekBloc>.value(
          value: lastWeekBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<MaintenanceManagementBloc, MaintenanceManagementState>(
            listener: (context, state) {
              // Intercepta estados de erro específicos do startSession para exibir
              // modal informativo ao invés da tela de erro padrão
              if (state is MaintenanceManagementWarningModalState) {
                _showMaintenanceWarningModal(context, state.entity);
              }
            },
          ),
          BlocListener<SessionBloc, SessionState>(
            listener: (context, sessionState) {
              _handleSessionStateChange(sessionState);
            },
          ),
        ],
        child:
            BlocBuilder<MaintenanceManagementBloc, MaintenanceManagementState>(
          buildWhen: (previous, current) {
            // Não rebuilda quando for o estado de modal de aviso
            if (current is MaintenanceManagementWarningModalState) {
              return false;
            }
            if (previous is MaintenanceManagementLoadedState &&
                current is MaintenanceManagementLoadedState) {
              return previous.data != current.data;
            }
            return previous != current;
          },
          builder: (context, state) => Scaffold(
            appBar: PrimaryAppBar(
              title: getString(
                context,
                "maintenance_management",
                defaultText: "Maintenance Management",
              ),
              theme: theme,
              actions: [
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    reloadData();
                  },
                  tooltip: 'Recarregar',
                ),
              ],
            ),
            body: _isSwitchingCondominium
                ? _buildLoading(context, theme)
                : state is MaintenanceManagementLoadedState
                    ? BlocProvider.value(
                        value: homeBloc,
                        child: BlocConsumer<HomeBloc, HomeState>(
                            builder: (context, _) {
                              final isTrackingTradeServiceUnavailable =
                                  _isServiceUnavailable(state.data);
                              final visibleOptions = _optionsFor(state.data);
                              final showQuickPlanning =
                                  state.data.isTrackingTradeActive &&
                                      !isTrackingTradeServiceUnavailable;

                              return CustomScrollView(
                                slivers: [
                                  SliverToBoxAdapter(
                                    child: _buildHeaderSection(
                                      context,
                                      theme,
                                      state.data,
                                    ),
                                  ),
                                  const SliverToBoxAdapter(
                                      child: SizedBox(height: 32)),

                                  // Se��o "O que deseja fazer?"
                                  SliverToBoxAdapter(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kPadding),
                                      child: Text(
                                        getString(
                                          context,
                                          'maintenance_management_what_do_you_want',
                                          defaultText:
                                              'What do you want to do?',
                                        ),
                                        textAlign: TextAlign.start,
                                        style: LelloTextStyles.titleSmallBold(
                                            theme),
                                      ),
                                    ),
                                  ),

                                  // Grid de op��es (vari�vel conforme tokens)
                                  SliverPadding(
                                    padding: const EdgeInsets.all(8),
                                    sliver: SliverGrid(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        mainAxisSpacing: 8,
                                        crossAxisSpacing: 8,
                                        childAspectRatio: 1.5,
                                      ),
                                      delegate: SliverChildBuilderDelegate(
                                        (context, index) => _buildOptionCard(
                                          context,
                                          theme,
                                          visibleOptions,
                                          index,
                                          state.data,
                                          isTrackingTradeServiceUnavailable,
                                        ),
                                        childCount: visibleOptions.length,
                                      ),
                                    ),
                                  ),

                                  if (isTrackingTradeServiceUnavailable)
                                    SliverToBoxAdapter(
                                      child: _buildServiceUnavailableSection(
                                        context,
                                        theme,
                                      ),
                                    ),

                                  if (showQuickPlanning) ...[
                                    const SliverToBoxAdapter(
                                        child: SizedBox(height: 20)),
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: kPadding),
                                        child: Text(
                                          getString(
                                            context,
                                            'maintenance_management_quick_planning',
                                            defaultText: 'Quick planning',
                                          ),
                                          textAlign: TextAlign.start,
                                          style: LelloTextStyles.titleSmallBold(
                                              theme),
                                        ),
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: Padding(
                                        padding: const EdgeInsets.all(kPadding),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedTabIndex = 0;
                                                          tabController
                                                              .animateTo(0);
                                                          _appliedFilters =
                                                              null;
                                                        });
                                                      },
                                                      child: _buildTabButton(
                                                          getString(
                                                            context,
                                                            'maintenance_management_current_week',
                                                            defaultText:
                                                                'Current week',
                                                          ),
                                                          0,
                                                          theme),
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          _selectedTabIndex = 1;
                                                          tabController
                                                              .animateTo(1);
                                                          _appliedFilters =
                                                              null;
                                                        });
                                                      },
                                                      child: _buildTabButton(
                                                          getString(
                                                            context,
                                                            'maintenance_management_last_week',
                                                            defaultText:
                                                                'Last week',
                                                          ),
                                                          1,
                                                          theme),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _buildFilterButton(theme),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SliverToBoxAdapter(
                                      child: _selectedTabIndex == 0
                                          ? Padding(
                                              padding: const EdgeInsets.all(16),
                                              child:
                                                  MaintenanceManagementCurrentWeekWidget(
                                                appliedFilters:
                                                    _getAppliedFiltersEntity(),
                                                onTaskDetailsReturn: () {
                                                  lastWeekBloc
                                                      .fetchEfficiencyData();
                                                },
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.all(16),
                                              child:
                                                  MaintenanceManagementLastWeekWidget(),
                                            ),
                                    ),
                                  ],
                                ],
                              );
                            },
                            listener: (context, state) {}),
                      )
                    : state is MaintenanceManagementLoadingState
                        ? _buildLoading(context, theme)
                        : Padding(
                            padding: EdgeInsets.all(Dimens.spacingMedium),
                            child: ErrorHandlingWidget(
                              reTryFunction: () {
                                bloc.fetchCondominiumInfo();
                              },
                              backFunction: () => Navigator.pop(context, true),
                              isProduction: env.isProduction,
                              textReturnButton: "back_to_the_previous_page",
                              message: state is MaintenanceManagementErrorState
                                  ? state.message.replaceAll('Exception: ', '')
                                  : null,
                            ),
                          ),
          ), // Fecha BlocBuilder
        ), // Fecha MultiBlocListener
      ), // Fecha MultiBlocProvider
    );
  }

  Widget _buildTabButton(String text, int index, ThemeData theme) {
    final bool isSelected = _selectedTabIndex == index;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      height: 60,
      decoration: BoxDecoration(
        color:
            isSelected ? LelloTheme.palleteOf(theme).primary() : Colors.white,
        borderRadius: BorderRadius.circular(kRadius),
        border: isSelected
            ? null
            : Border.all(color: Colors.grey.shade400, width: 1.5),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: LelloTheme.palleteOf(theme).primary().withAlpha(30),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                )
              ]
            : [],
      ),
      child: Center(
        child: AutoSizeText(
          text,
          textAlign: TextAlign.center,
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color:
                isSelected ? Colors.white : LelloTheme.palleteOf(theme).text(),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    ThemeData theme,
    List<MaintenanceManagementOptionModel> options,
    int index,
    CondominiumInfoEntity data,
    bool isTrackingTradeServiceUnavailable,
  ) {
    final option = options[index];
    final bool isPrimary = index == 0 && options.length > 2;
    return InkWell(
      onTap: () async {
        if (isTrackingTradeServiceUnavailable &&
            _isBlockedByServiceUnavailable(option.routeName)) {
          await _showServiceUnavailableBlockedModal(context, theme);
          return;
        }

        final routeArguments = _buildRouteArguments(
          option,
          data,
          isTrackingTradeServiceUnavailable,
        );

        await Navigator.of(context).pushNamed(
          option.routeName,
          arguments: routeArguments,
        );
        reloadData();
      },
      splashColor: Colors.transparent,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadius),
          side: BorderSide(
            color: isPrimary
                ? Colors.transparent
                : LelloTheme.palleteOf(theme).grey(),
          ),
        ),
        color: isPrimary ? LelloTheme.palleteOf(theme).raffle() : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                option.iconAssets,
                height: 16,
                width: 16,
                colorFilter: ColorFilter.mode(
                  isPrimary ? Colors.white : LelloTheme.palleteOf(theme).grey(),
                  ui.BlendMode.srcIn,
                ),
              ),
              Flexible(
                child: AutoSizeText(
                  getString(
                    context,
                    option.title,
                    defaultText: _optionTitleFallback(option.title),
                  ),
                  style: LelloTextStyles.subtitle(theme)?.copyWith(
                    color: isPrimary
                        ? Colors.white
                        : LelloTheme.palleteOf(theme).grey(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(
    BuildContext context,
    ThemeData theme,
    CondominiumInfoEntity data,
  ) {
    return Container(
      padding: const EdgeInsets.all(kPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(kRadius * 2),
          bottomRight: Radius.circular(kRadius * 2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: kSpacing),
          Text(
            getString(
              context,
              "maintenance_management_hello_manager",
              defaultText: "Olá, Síndico!",
            ),
            style: LelloTextStyles.headline(theme),
          ),
          const SizedBox(height: kSpacing),
          Text(
            getString(context, "maintenance_management_your_condominium"),
            style: LelloTextStyles.subtitleBold(theme),
          ),
          _buildDropdown(context, theme, data.references),
          const SizedBox(height: kSpacing),
          CondominiumInfoGrid(
            items: [
              (
                getString(context, 'maintenance_management_employees'),
                data.workflowUsers,
              ),
              (
                getString(context, 'maintenance_management_blocks'),
                data.blocksCount,
              ),
              (
                getString(context, 'maintenance_management_floors'),
                data.floor,
              ),
              (
                getString(context, 'maintenance_management_units'),
                data.unitsCount,
              ),
              if (data.isTrackingTradeActive) ...[
                (
                  getString(context, 'maintenance_management_environments'),
                  data.localsCount,
                ),
                (
                  getString(context, 'maintenance_management_equipment'),
                  data.assets,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(ThemeData theme) {
    final hasFilters = _hasActiveFilters;
    final counter = hasFilters ? _getActiveFilterCount(_appliedFilters!) : 0;

    return Stack(
      children: [
        TextButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MaintenanceManagementFiltersPage(
                  filterOptions: bloc.filterOptions,
                  appliedFilters: _getAppliedFiltersEntity(),
                ),
              ),
            );

            if (result != null) {
              _handleFiltersResult(result);
            }
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.tune,
                color: Colors.black,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                getString(
                  context,
                  "maintenance_management_filters",
                  defaultText: "Filters",
                ),
                style: LelloTextStyles.button(theme)?.copyWith(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
        ),
        if (hasFilters)
          Positioned(
            right: 6,
            top: 4,
            child: Container(
              width: 15,
              height: 15,
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: AutoSizeText(
                  counter.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  String _optionTitleFallback(String key) {
    switch (key) {
      case 'maintenance_management_create_task':
        return 'Create task';
      case 'maintenance_management_view_reports':
        return 'View reports';
      case 'maintenance_management_schedule':
        return 'Schedule';
      case 'maintenance_management_conversations':
        return 'Conversations';
      case 'maintenance_management_legal_entitlements':
        return 'Legal obligations';
      default:
        return key;
    }
  }

  Widget _buildDropdown(
    BuildContext context,
    ThemeData theme,
    List<int> referencesFilter,
  ) {
    return BlocProvider.value(
      value: sessionBloc,
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, sessionState) {
          final session = sessionState.session;
          final allCondominiums = session?.me?.condominiums ?? [];
          final condominiums = referencesFilter.isEmpty
              ? allCondominiums
              : allCondominiums.where((condo) {
                  final reference = int.tryParse(condo.reference);
                  return reference != null &&
                      referencesFilter.contains(reference);
                }).toList();

          if (condominiums.isEmpty) {
            return const SizedBox.shrink();
          }

          Condominium? selectedCondominium = session?.selectedCondominium;
          final hasSelection = selectedCondominium != null &&
              condominiums.any((condo) => condo.id == selectedCondominium!.id);
          if (!hasSelection) {
            selectedCondominium = condominiums.first;
          }

          final palette = LelloTheme.palleteOf(theme);
          final selectedLabel =
              '${selectedCondominium.reference} - ${selectedCondominium.name ?? ''}';

          if (condominiums.length == 1) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  selectedLabel,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: palette.primary(),
                  ),
                ),
              ),
            );
          }

          return DropdownButtonHideUnderline(
            child: DropdownButton2<Condominium>(
              isExpanded: true,
              barrierColor: Colors.transparent,
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.zero,
              ),
              dropdownStyleData: DropdownStyleData(
                maxHeight: 340,
                elevation: 0,
                offset: const Offset(0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      spreadRadius: -2,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                height: 72,
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              value: selectedCondominium,
              iconStyleData: IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: palette.text(),
                  size: 20,
                ),
              ),
              style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                color: palette.primary(),
              ),
              selectedItemBuilder: (context) {
                return condominiums
                    .map(
                      (condo) => Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${condo.reference} - ${condo.name ?? ''}',
                          overflow: TextOverflow.ellipsis,
                          style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                            color: palette.primary(),
                          ),
                        ),
                      ),
                    )
                    .toList();
              },
              items: condominiums.map((condo) {
                final address = [
                  if ((condo.address ?? '').isNotEmpty) condo.address!,
                  if ((condo.number ?? '').isNotEmpty) condo.number!,
                ].join(' - ');
                final isSelected = condo.id == selectedCondominium?.id;
                return DropdownMenuItem<Condominium>(
                  value: condo,
                  child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${condo.reference} ${(condo.name ?? '').toUpperCase()}',
                                overflow: TextOverflow.ellipsis,
                                style: LelloTextStyles.subtitleBold(theme)
                                    ?.copyWith(
                                  color: palette.text(),
                                  fontSize: 14,
                                ),
                              ),
                              if (address.isNotEmpty)
                                Text(
                                  address.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      LelloTextStyles.caption(theme)?.copyWith(
                                    color: palette.text().withAlpha(170),
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                isSelected ? palette.primary() : Colors.white,
                            border: Border.all(
                              color: palette.primary(),
                              width: 2,
                            ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                )
                              : null,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (condo) {
                if (condo == null) return;
                if (condo.id == selectedCondominium?.id) return;

                setState(() {
                  _pendingSwitchCondominiumId = condo.id;
                  _isSwitchingCondominium = true;
                });
                sessionBloc.selectCondominium(condo, context);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoading(BuildContext context, ThemeData theme) {
    return Material(
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: 200,
                child: Lottie.asset(
                  'assets/processing_documents_animation.json',
                  fit: BoxFit.scaleDown,
                  delegates: LottieDelegates(values: [
                    ValueDelegate.colorFilter(
                      ['casa', '**'],
                      value: ColorFilter.mode(
                        theme.primaryColor,
                        ui.BlendMode.src,
                      ),
                    ),
                  ]),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, 'maintenance_management_loading'),
                style: LelloTextStyles.title(theme),
              ),
              SizedBox(height: Dimens.spacingSmall),
              Text(getString(context, "please_wait"),
                  style: LelloTextStyles.subBody(theme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceUnavailableSection(
      BuildContext context, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Padding(
      padding: const EdgeInsets.fromLTRB(kPadding, 0, kPadding, 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kRadius),
        ),
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/ic_bella_not_available_error.svg',
              width: 140,
              height: 140,
            ),
            const SizedBox(height: 16),
            Text(
              getString(
                context,
                'maintenance_management_service_unavailable_title',
                defaultText: 'Serviço temporariamente\nindisponível',
              ),
              textAlign: TextAlign.center,
              style: LelloTextStyles.title(theme)?.copyWith(
                color: palette.textLight(),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              getString(
                context,
                'maintenance_management_service_unavailable_description',
                defaultText:
                    'O sistema que fornece estes dados está fora do ar no momento. '
                    'Já estamos cientes e trabalhando para que tudo volte ao normal logo.\n'
                    'Tente atualizar a página daqui a pouco.',
              ),
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.textLight(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                theme: theme,
                onPressed: () {
                  bloc.fetchCondominiumInfo();
                  bloc.fetchFilterOptions();
                },
                text: getString(
                  context,
                  'maintenance_management_service_unavailable_retry_button',
                  defaultText: 'Tentar novamente',
                ),
                buttonColor: palette.primary(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Filter state management
  Map<String, dynamic>? _appliedFilters;
  bool get _hasActiveFilters =>
      _appliedFilters != null &&
      _appliedFilters!.values.any((value) {
        if (value is List) return value.isNotEmpty;
        return value != null;
      });

  void _handleFiltersResult(FilterOptionsEntity filters) {
    // Check if all filters are empty (filters were cleared)
    final bool filtersCleared = filters.taskType.isEmpty &&
        filters.taskStatus.isEmpty &&
        filters.locals.isEmpty &&
        filters.assets.isEmpty &&
        filters.responsibles.isEmpty &&
        filters.employeeGroup.isEmpty;

    // Store applied filters state for UI and pass to child widgets
    setState(() {
      if (filtersCleared) {
        // If filters were cleared, set to null to indicate no filters
        _appliedFilters = null;
      } else {
        _appliedFilters = {
          'taskType': filters.taskType,
          'taskStatus': filters.taskStatus,
          'locals': filters.locals,
          'assets': filters.assets,
          'responsibles': filters.responsibles,
          'employeeGroup': filters.employeeGroup,
        };
      }
    });

    // The widgets will automatically refresh when appliedFilters change
    // due to didUpdateWidget implementation in the child widgets
  }

  int _getActiveFilterCount(Map<String, dynamic> filters) {
    int count = 0;

    filters.forEach((key, value) {
      if (value is List && value.isNotEmpty) {
        count++;
      }
    });

    return count;
  }

  FilterOptionsEntity? _getAppliedFiltersEntity() {
    if (_appliedFilters == null) return null;

    return FilterOptionsEntity(
      taskType: _appliedFilters!['taskType'] ?? [],
      taskStatus: _appliedFilters!['taskStatus'] ?? [],
      locals: _appliedFilters!['locals'] ?? [],
      assets: _appliedFilters!['assets'] ?? [],
      responsibles: _appliedFilters!['responsibles'] ?? [],
      employeeGroup: _appliedFilters!['employeeGroup'] ?? [],
    );
  }
}
