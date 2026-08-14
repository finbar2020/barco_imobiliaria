import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/reports_view/cubit/chart_state.dart';
import '../../enums/efficiency_scope_enum.dart';
import '../bloc/visualize_reports_bloc.dart';
import '../bloc/visualize_reports_state.dart';
import '../cubit/rotine_chart_cubit.dart';
import '../cubit/ordem_servico_chart_cubit.dart';
import '../cubit/efficiency_chart_cubit.dart';
import '../cubit/categories_chart_cubit.dart';
import '../cubit/environment_equipment_chart_cubit.dart';
import '../widgets/routine_analysis_chart.dart';
import '../widgets/service_order_analysis_chart.dart';
import '../widgets/categories_donut_chart.dart';

import '../../shared/widgets/efficiency_card_widget.dart';
import '../../shared/widgets/info_tooltip_widget.dart';
import '../../shared/widgets/efficiency_tabs_widget.dart';
import '../../shared/widgets/search_field_widget.dart';
import '../../shared/widgets/efficiency_tile_widget.dart';
import '../../shared/widgets/environment_equipment_analysis_card.dart';
import '../../home/pages/maintenance_management_filters_page.dart';
import '../../../domain/entity/filter_options_entity.dart';

class VisualizeReportsPage extends StatefulWidget {
  const VisualizeReportsPage({super.key});

  @override
  State<VisualizeReportsPage> createState() => _VisualizeReportsPageState();
}

class _VisualizeReportsPageState extends State<VisualizeReportsPage>
    with SingleTickerProviderStateMixin {
  DateTime? _startDate;
  DateTime? _endDate;
  late TabController _tabController;
  late VisualizeReportsBloc _reportsBloc;

  FilterOptionsEntity? _filterOptions;
  FilterOptionsEntity? _appliedFilters;
  bool _hasAppliedFilters = false;

  /// Converte TaskStatusType para string inglês
  String _mapTaskStatusTypeToEnglish(String statusName) {
    switch (statusName) {
      case 'completed':
        return 'DONE';
      case 'pending':
        return 'NOT_STARTED';
      case 'inProgress':
        return 'DRAFT';
      default:
        return statusName;
    }
  }

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
    _startDate = DateTime.now().subtract(const Duration(days: 30));
    _tabController = TabController(length: 2, vsync: this);
    _reportsBloc = context.read<VisualizeReportsBloc>();

    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadReports(); // Carrega dados baseado na aba atual (inicialmente aba 0 - Rotina)
      _loadFilterOptions();
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    // Prevenir chamadas duplicadas durante a animação de mudança de aba
    if (_tabController.indexIsChanging) {
      // Ainda está animando, ignorar este callback
      return;
    }

    // Força rebuild para atualizar as cores das abas
    setState(() {});

    // Não usar loading manual - deixar os BlocBuilders gerenciarem o estado
    // Os Cubits já emitem ChartLoadingState automaticamente

    if (_tabController.index == 0) {
      _loadRoutineReports();
    } else if (_tabController.index == 1) {
      _loadServiceOrderReports();
    }
  }

  void _loadRoutineReports() {
    if (_hasAppliedFilters && _appliedFilters != null) {
      _loadRoutineReportsWithFilters();
      return;
    }

    if (_startDate != null && _endDate != null) {
      // Usar RoutineChartCubit para carregar dados do gráfico
      final routineCubit = context.read<RoutineChartCubit>();
      routineCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        status: [],
      );

      // Usar EfficiencyChartCubit para carregar dados de eficiência
      final efficiencyCubit = context.read<EfficiencyChartCubit>();
      efficiencyCubit.setReportsBloc(_reportsBloc);
      efficiencyCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        typeTask: ["ROTINA"],
        status: [],
      );
    }
  }

  void _loadServiceOrderReports() {
    if (_hasAppliedFilters && _appliedFilters != null) {
      _loadServiceOrderReportsWithFilters();
      return;
    }

    if (_startDate != null && _endDate != null) {
      // Usar os Cubits específicos para carregar dados
      final serviceOrderCubit = context.read<ServiceOrderChartCubit>();
      final categoriesCubit = context.read<CategoriesChartCubit>();
      final environmentCubit = context.read<EnvironmentEquipmentChartCubit>();

      serviceOrderCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        status: [],
      );

      categoriesCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        status: [],
      );

      environmentCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        status: [],
      );

      // Não carregar dados duplicados - Cubits já fazem o carregamento
      // BLoC principal não é necessário para ordem de serviço pois usamos Cubits independentes
    } else {}
  }

  void _loadReports() {
    if (_tabController.index == 0) {
      _loadRoutineReports();
    } else {
      _loadServiceOrderReports();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: PrimaryAppBar(
        title: getString(context, "reports"),
        theme: theme,
      ),
      body: _buildBody(context, theme),
    );
  }

  Widget _buildContentWithLoading(BuildContext context, ThemeData theme) {
    // Verificar se algum dos cubits está em estado de loading baseado na aba atual
    if (_tabController.index == 0) {
      // Aba de Rotina - verificar RoutineChartCubit e EfficiencyChartCubit
      return BlocBuilder<RoutineChartCubit, ChartState>(
        builder: (context, routineState) {
          return BlocBuilder<EfficiencyChartCubit, ChartState>(
            builder: (context, efficiencyState) {
              if (routineState is ChartLoadingState ||
                  efficiencyState is ChartLoadingState) {
                return _buildFullScreenLoading(context, theme);
              }
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildRoutineContent(),
                  _buildServiceOrderContent(),
                ],
              );
            },
          );
        },
      );
    } else {
      // Aba de Ordem de Serviço - verificar ServiceOrderChartCubit, CategoriesChartCubit e EnvironmentEquipmentChartCubit
      return BlocBuilder<ServiceOrderChartCubit, ChartState>(
        builder: (context, serviceOrderState) {
          return BlocBuilder<CategoriesChartCubit, ChartState>(
            builder: (context, categoriesState) {
              return BlocBuilder<EnvironmentEquipmentChartCubit, ChartState>(
                builder: (context, environmentState) {
                  if (serviceOrderState is ChartLoadingState ||
                      categoriesState is ChartLoadingState ||
                      environmentState is ChartLoadingState) {
                    return _buildFullScreenLoading(context, theme);
                  }
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildRoutineContent(),
                      _buildServiceOrderContent(),
                    ],
                  );
                },
              );
            },
          );
        },
      );
    }
  }

  Widget _buildFullScreenLoading(BuildContext context, ThemeData theme) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(),
            SizedBox(height: Dimens.spacingLarge),
            Text(
              'Carregando relatórios...',
              style: LelloTextStyles.title(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, "please_wait"),
              style: LelloTextStyles.subBody(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTabSection(context, theme),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Relatório",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildFilterRow(context, theme),
          const SizedBox(height: 24),
          Expanded(
            child: _buildContentWithLoading(context, theme),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(BuildContext context, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1.0,
          ),
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
              width: 4.0,
              color: _tabController.index == 0
                  ? palette.buttonSystem() // Azul para Rotina (índice 0)
                  : Color(
                      0xFFC20332) // Vermelho para Ordem de serviço (índice 1)
              ),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: _tabController.index == 0
            ? palette.buttonSystem() // Azul para Rotina (índice 0)
            : Color(0xFFC20332), // Vermelho para Ordem de serviço (índice 1)
        unselectedLabelColor: Colors.grey[600],
        labelStyle: LelloTextStyles.bodyBold(theme),
        unselectedLabelStyle: LelloTextStyles.body(theme),
        tabs: const [
          Tab(text: "Rotina"),
          Tab(text: "Ordem de serviço"),
        ],
      ),
    );
  }

  Widget _buildRoutineContent() {
    return SingleChildScrollView(
      key: const ValueKey('routine_scroll'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Gráfico de rotina - usando RoutineChartCubit com loading individual
          BlocBuilder<RoutineChartCubit, ChartState>(
            builder: (context, chartState) {
              return _buildRoutineChart(chartState);
            },
          ),
          const SizedBox(height: 24),
          // Card de eficiência - usando EfficiencyChartCubit com loading individual
          BlocBuilder<EfficiencyChartCubit, ChartState>(
            builder: (context, chartState) {
              return _buildEfficiencyChart(chartState);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOrderContent() {
    return SingleChildScrollView(
      key: const ValueKey('service_order_scroll'),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Gráfico de análise mensal - usando ServiceOrderChartCubit
          BlocBuilder<ServiceOrderChartCubit, ChartState>(
            builder: (context, chartState) {
              return _buildServiceOrderChart(chartState);
            },
          ),
          const SizedBox(height: 16),
          // Gráfico de donut por categorias - usando CategoriesChartCubit
          BlocBuilder<CategoriesChartCubit, ChartState>(
            builder: (context, chartState) {
              return _buildCategoriesChart(chartState);
            },
          ),
          const SizedBox(height: 24),
          // Card de análise por ambiente e equipamentos - usando EnvironmentEquipmentChartCubit
          BlocBuilder<EnvironmentEquipmentChartCubit, ChartState>(
            builder: (context, chartState) {
              return _buildEnvironmentEquipmentChart(chartState);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOrderChart(ChartState chartState) {
    if (chartState is ChartErrorState) {
      return _buildEmptyChart("Erro ao carregar dados: ${chartState.message}");
    } else if (chartState is ChartLoadedState) {
      return ServiceOrderAnalysisChart(
        taskByMonthData: chartState.data,
      );
    } else if (chartState is ChartEmptyState) {
      return _buildEmptyChart(chartState.message);
    } else {
      // Estado inicial ou loading - mostrar placeholder sem skeleton
      return _buildEmptyChart(
          "Selecione um período para visualizar as ordens de serviço");
    }
  }

  Widget _buildCategoriesChart(ChartState chartState) {
    if (chartState is ChartErrorState) {
      return _buildEmptyDonutChart(
          "Erro ao carregar categorias: ${chartState.message}");
    } else if (chartState is ChartLoadedState) {
      return CategoriesDonutChart(
        taskBySectorData: chartState.data.data,
      );
    } else if (chartState is ChartEmptyState) {
      return _buildEmptyDonutChart(chartState.message);
    } else {
      // Estado inicial ou loading - mostrar placeholder sem skeleton
      return _buildEmptyDonutChart(
          "Selecione um período para visualizar as categorias");
    }
  }

  Widget _buildEnvironmentEquipmentChart(ChartState chartState) {
    // Para este widget, sempre mostrar o card padrão que gerencia seu próprio estado interno
    // O loading já é tratado pelo loading de tela inteira
    return EnvironmentEquipmentAnalysisCard(
      key: const ValueKey('environment_equipment_analysis'),
      startDate: _startDate,
      endDate: _endDate,
    );
  }

  Widget _buildEmptyChart(String message) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Quantidade mensal de ordens de serviço",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.bar_chart_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyDonutChart(String message) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Categorias de ordens de serviço",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.donut_small_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        message,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoutineChart(ChartState? chartState) {
    if (chartState is ChartErrorState) {
      return _buildEmptyChart(
          "Erro ao carregar análise de rotina: ${chartState.message}");
    } else if (chartState is ChartLoadedState) {
      return RoutineAnalysisChart(formularyData: chartState.data);
    } else if (chartState is ChartEmptyState) {
      return _buildEmptyChart(chartState.message);
    } else {
      // Estado inicial ou loading - mostrar placeholder sem skeleton
      return _buildEmptyChart(
          "Selecione um período para visualizar a análise de rotina");
    }
  }

  Widget _buildEfficiencyChart(ChartState chartState) {
    if (chartState is ChartErrorState) {
      return EfficiencyCardWidget(
        title: getString(
            context, 'maintenance_management_efficiency_last_week_title'),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                "Erro ao carregar dados de eficiência",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                chartState.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else if (chartState is ChartLoadedState) {
      // Aqui vamos integrar com o VisualizeReportsBloc para mostrar a UI de eficiência
      return BlocBuilder<VisualizeReportsBloc, VisualizeReportsState>(
        bloc: _reportsBloc,
        builder: (context, state) {
          if (state is VisualizeReportsLoadedState) {
            return _buildEfficiencyCardContent(state, context);
          } else {
            // Estado inicial da eficiência
            return EfficiencyCardWidget(
              title: getString(
                  context, 'maintenance_management_efficiency_last_week_title'),
              child: const Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 64,
                      color: Colors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Dados carregados com sucesso",
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      );
    } else if (chartState is ChartEmptyState) {
      return EfficiencyCardWidget(
        title: getString(
            context, 'maintenance_management_efficiency_last_week_title'),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: Colors.grey.withOpacity(0.5),
              ),
              const SizedBox(height: 16),
              Text(
                chartState.message,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    } else {
      // Estado inicial - mostrar placeholder
      return EfficiencyCardWidget(
        title: getString(
            context, 'maintenance_management_efficiency_last_week_title'),
        child: const Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 64,
                color: Colors.grey,
              ),
              SizedBox(height: 16),
              Text(
                "Selecione um período para visualizar a eficiência",
                style: TextStyle(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Nenhum resultado encontrado",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Tente ajustar sua pesquisa",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // Estado local para controlar loading da mudança de aba de eficiência
  bool _isEfficiencyScopeLoading = false;

  Widget _buildEfficiencyCardContent(
      VisualizeReportsLoadedState state, BuildContext context) {
    final theme = Theme.of(context);
    final currentList = state.currentScope == EfficiencyScope.responsibles
        ? state.responsibles
        : state.groups;

    final filteredList = state.searchQuery.trim().isEmpty
        ? currentList
        : currentList
            .where((item) =>
                item.title
                    .toLowerCase()
                    .contains(state.searchQuery.toLowerCase()) ||
                (item.subtitle
                        ?.toLowerCase()
                        .contains(state.searchQuery.toLowerCase()) ??
                    false))
            .toList();

    return EfficiencyCardWidget(
      title: getString(
          context, 'maintenance_management_efficiency_last_week_title'),
      child: Column(
        children: [
          const InfoTooltip(
            message:
                "As tarefas são inicialmente atribuídas a um grupo e passam para um responsável quando iniciadas.",
          ),
          const SizedBox(height: 16),
          EfficiencyTabsWidget(
            selectedTab: state.currentScope == EfficiencyScope.responsibles
                ? EfficiencyTabType.responsibles
                : EfficiencyTabType.groups,
            onTabChanged: (tabType) {
              final scope = tabType == EfficiencyTabType.responsibles
                  ? EfficiencyScope.responsibles
                  : EfficiencyScope.groups;

              // Se já está no mesmo escopo, não fazer nada
              if (scope == state.currentScope) return;

              // Ativar loading local
              setState(() {
                _isEfficiencyScopeLoading = true;
              });

              // Simular um pequeno delay para mostrar o loading
              Future.delayed(const Duration(milliseconds: 300), () {
                _reportsBloc.changeScope(scope);
                // Desativar loading após a mudança
                if (mounted) {
                  setState(() {
                    _isEfficiencyScopeLoading = false;
                  });
                }
              });
            },
            responsiblesLabel:
                getString(context, 'maintenance_management_responsibles'),
            groupsLabel:
                getString(context, 'maintenance_management_employee_groups'),
          ),
          const SizedBox(height: 16),
          SearchFieldWidget(
            hintText:
                getString(context, 'maintenance_management_search_employee'),
            onChanged: (text) {
              setState(() {});
              _reportsBloc.searchEfficiency(text);
            },
          ),
          const SizedBox(height: 16),
          // Mostrar loading se está mudando de aba
          if (_isEfficiencyScopeLoading)
            _buildEfficiencyTabsLoading(theme)
          else if (filteredList.isEmpty)
            _buildEmptyState(context, theme)
          else
            ...filteredList.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return EfficiencyTileWidget(
                item: item,
                showDivider: index < filteredList.length - 1,
              );
            }),
        ],
      ),
    );
  }

  Widget _buildEfficiencyTabsLoading(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Carregando dados...',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, ThemeData theme) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final textScaler = MediaQuery.of(context).textScaler;
        final availableWidth = constraints.maxWidth;

        final useVerticalLayout =
            textScaler.scale(1.0) > 1.3 || availableWidth < 300;

        if (!useVerticalLayout) {
          return Row(
            children: [
              Expanded(
                flex: 3,
                child: _buildDateRangeButton(context, theme),
              ),
              SizedBox(width: Dimens.spacingSmall),
              Flexible(
                flex: 2,
                child: _buildFiltersButton(context, theme),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDateRangeButton(context, theme),
              SizedBox(height: Dimens.spacingSmall),
              _buildFiltersButton(context, theme),
            ],
          );
        }
      },
    );
  }

  Widget _buildDateRangeButton(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () {
          _showDateRangePicker(context);
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  "assets/ic_calendar.svg",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _getDateRangeText(),
                      style: LelloTextStyles.body(theme),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersButton(BuildContext context, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);
    final hasFilters = _hasAppliedFilters;

    return Container(
      decoration: BoxDecoration(
        color: hasFilters ? palette.primary().withOpacity(0.1) : Colors.white,
        border: Border.all(
          color: hasFilters ? palette.primary() : Colors.grey.shade300,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: InkWell(
        onTap: () {
          _showFilters(context);
        },
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.filter_list,
                  size: 20,
                  color: hasFilters ? palette.primary() : Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      hasFilters
                          ? "Filtros (${_getAppliedFiltersCount()})"
                          : "Filtros",
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: hasFilters
                            ? palette.primary()
                            : Colors.grey.shade600,
                        fontWeight:
                            hasFilters ? FontWeight.w600 : FontWeight.normal,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: hasFilters ? palette.primary() : Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    DateTime? startDate = await showDatePicker(
      context: context,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDate:
          _startDate ?? DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 2)),
      lastDate: DateTime.now(),
      helpText: 'Selecione a data inicial',
    );

    if (startDate != null) {
      // Calcular a data máxima permitida (90 dias após a data inicial)
      final maxEndDate = startDate.add(const Duration(days: 90));

      DateTime? endDate = await showDatePicker(
        context: context,
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: _endDate != null &&
                _endDate!.isAfter(startDate) &&
                _endDate!.isBefore(maxEndDate.add(const Duration(days: 1)))
            ? _endDate!
            : (maxEndDate.isBefore(DateTime.now())
                ? maxEndDate
                : DateTime.now()),
        firstDate: startDate,
        lastDate:
            maxEndDate.isBefore(DateTime.now()) ? maxEndDate : DateTime.now(),
        helpText: 'Selecione a data final (máx. 90 dias)',
        selectableDayPredicate: (DateTime day) {
          // Permitir desde a data inicial até 90 dias depois (incluindo ambos os dias)
          final daysDifference = day.difference(startDate).inDays;
          return daysDifference >= 0 && daysDifference <= 90;
        },
      );

      if (endDate != null) {
        setState(() {
          _startDate = startDate;
          _endDate = endDate;
        });
        _loadReports();
      }
    }
  }

  String _getDateRangeText() {
    if (_startDate == null || _endDate == null) {
      return "Selecione o período";
    }

    final normalFormat =
        "${_startDate!.day.toString().padLeft(2, '0')}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.year} - ${_endDate!.day.toString().padLeft(2, '0')}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.year}";

    if (normalFormat.length > 25) {
      return "${_startDate!.day.toString().padLeft(2, '0')}/${_startDate!.month.toString().padLeft(2, '0')}/${_startDate!.year.toString().substring(2)} - ${_endDate!.day.toString().padLeft(2, '0')}/${_endDate!.month.toString().padLeft(2, '0')}/${_endDate!.year.toString().substring(2)}";
    }

    return normalFormat;
  }

  void _loadFilterOptions() async {
    try {
      final response = await _reportsBloc.loadFilterOptions();
      if (response != null && mounted) {
        setState(() {
          _filterOptions = response;
        });
      }
    } catch (e) {}
  }

  void _showFilters(BuildContext context) async {
    if (_filterOptions == null) {
      return;
    }

    final result = await Navigator.of(context).push<FilterOptionsEntity>(
      MaterialPageRoute(
        builder: (context) => MaintenanceManagementFiltersPage(
          filterOptions: _filterOptions,
          appliedFilters: _appliedFilters,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _appliedFilters = result;
        _hasAppliedFilters = _isFilterApplied(result);
      });
      _loadReportsWithFilters();
    }
  }

  int _getAppliedFiltersCount() {
    if (_appliedFilters == null) return 0;

    int count = 0;
    if (_appliedFilters!.locals.isNotEmpty) count++;
    if (_appliedFilters!.assets.isNotEmpty) count++;
    if (_appliedFilters!.responsibles.isNotEmpty) count++;
    if (_appliedFilters!.employeeGroup.isNotEmpty) count++;
    if (_appliedFilters!.taskType.isNotEmpty) count++;
    if (_appliedFilters!.taskStatus.isNotEmpty) count++;

    return count;
  }

  bool _isFilterApplied(FilterOptionsEntity filters) {
    return filters.locals.isNotEmpty ||
        filters.assets.isNotEmpty ||
        filters.responsibles.isNotEmpty ||
        filters.employeeGroup.isNotEmpty ||
        filters.taskType.isNotEmpty ||
        filters.taskStatus.isNotEmpty;
  }

  void _loadRoutineReportsWithFilters() {
    if (_appliedFilters != null && _startDate != null && _endDate != null) {
      List<String> taskTypes =
          _appliedFilters!.taskType.map((e) => e.name).toList();
      if (taskTypes.isEmpty) {
        taskTypes = ["ROTINA"];
      } else {
        taskTypes = taskTypes.where((type) => type == "ROTINA").toList();
        if (taskTypes.isEmpty) taskTypes = ["ROTINA"];
      }

      List<String> statuses = _appliedFilters!.taskStatus
          .map((e) => _mapTaskStatusTypeToEnglish(e.toString().split('.').last))
          .toList();

      // Usar RoutineChartCubit para carregar dados do gráfico
      final routineCubit = context.read<RoutineChartCubit>();
      routineCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        responsibleIds: _appliedFilters!.responsibles.map((e) => e.id).toList(),
        assetIds: _appliedFilters!.assets.map((e) => e.id).toList(),
        localIds: _appliedFilters!.locals.map((e) => e.id).toList(),
        status: statuses,
      );

      // Usar EfficiencyChartCubit para carregar dados de eficiência com filtros
      final efficiencyCubit = context.read<EfficiencyChartCubit>();
      efficiencyCubit.setReportsBloc(_reportsBloc);
      efficiencyCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        responsibleIds: _appliedFilters!.responsibles.map((e) => e.id).toList(),
        assetIds: _appliedFilters!.assets.map((e) => e.id).toList(),
        localIds: _appliedFilters!.locals.map((e) => e.id).toList(),
        typeTask: taskTypes,
        status: statuses,
      );

      // Removido chamadas duplicadas:
      // RoutineChartCubit já faz loadTaskByMonth e loadTaskBySector internamente
    } else {
      _loadRoutineReports();
    }
  }

  void _loadServiceOrderReportsWithFilters() {
    if (_appliedFilters != null && _startDate != null && _endDate != null) {
      List<String> taskTypes =
          _appliedFilters!.taskType.map((e) => e.name).toList();
      if (taskTypes.isEmpty) {
        taskTypes = ["ORDEM_SERVICO"];
      } else {
        taskTypes = taskTypes.where((type) => type == "ORDEM_SERVICO").toList();
        if (taskTypes.isEmpty) taskTypes = ["ORDEM_SERVICO"];
      }

      List<String> statuses = _appliedFilters!.taskStatus
          .map((e) => _mapTaskStatusTypeToEnglish(e.toString().split('.').last))
          .toList();

      // Usar os Cubits específicos para carregar dados com filtros
      final serviceOrderCubit = context.read<ServiceOrderChartCubit>();
      final categoriesCubit = context.read<CategoriesChartCubit>();
      final environmentCubit = context.read<EnvironmentEquipmentChartCubit>();

      serviceOrderCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        responsibleIds: _appliedFilters!.responsibles.map((e) => e.id).toList(),
        assetIds: _appliedFilters!.assets.map((e) => e.id).toList(),
        localIds: _appliedFilters!.locals.map((e) => e.id).toList(),
        status: statuses,
      );

      categoriesCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        responsibleIds: _appliedFilters!.responsibles.map((e) => e.id).toList(),
        assetIds: _appliedFilters!.assets.map((e) => e.id).toList(),
        localIds: _appliedFilters!.locals.map((e) => e.id).toList(),
        status: statuses,
      );

      environmentCubit.loadData(
        startDate: _startDate!,
        endDate: _endDate!,
        responsibleIds: _appliedFilters!.responsibles.map((e) => e.id).toList(),
        assetIds: _appliedFilters!.assets.map((e) => e.id).toList(),
        localIds: _appliedFilters!.locals.map((e) => e.id).toList(),
        status: statuses,
        typeTask: taskTypes,
      );

      // Removido chamadas duplicadas do _reportsBloc
      // ServiceOrderChartCubit, CategoriesChartCubit e EnvironmentEquipmentChartCubit
      // já fazem todas as requisições necessárias (task-by-month, taskBySector, taskByLocal)
    } else {
      _loadServiceOrderReports();
    }
  }

  void _loadReportsWithFilters() {
    // Carrega os dados com filtros baseado na aba atual
    if (_tabController.index == 0) {
      _loadRoutineReportsWithFilters();
    } else {
      _loadServiceOrderReportsWithFilters();
    }
  }
}
