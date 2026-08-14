import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/info_tooltip_widget.dart';
import 'efficiency_card_widget.dart';
import '../../../domain/entity/task_by_local_entity.dart';
import '../../../domain/entity/task_by_asset_entity.dart';
import '../../../domain/use_cases/get_task_by_local_use_case.dart';
import '../../../domain/use_cases/get_task_by_asset_use_case.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../home/widgets/task_progress_bar_widget.dart';
import '../../home/widgets/task_summary/task_summary_model.dart';

enum EnvironmentEquipmentTabType { environment, equipment }

class EnvironmentEquipmentAnalysisCard extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  const EnvironmentEquipmentAnalysisCard({
    super.key,
    this.startDate,
    this.endDate,
  });

  @override
  State<EnvironmentEquipmentAnalysisCard> createState() =>
      _EnvironmentEquipmentAnalysisCardState();
}

enum _LoadingState { initial, loading, loaded, error, empty }

class _EnvironmentEquipmentAnalysisCardState
    extends State<EnvironmentEquipmentAnalysisCard> {
  EnvironmentEquipmentTabType _selectedTab =
      EnvironmentEquipmentTabType.environment;

  final TextEditingController _searchController = TextEditingController();
  late final GetTaskByLocalUseCase _getTaskByLocalUseCase;
  late final GetTaskByAssetUseCase _getTaskByAssetUseCase;

  _LoadingState _loadingState = _LoadingState.initial;
  List<TaskByLocalDataEntity> _environmentData = [];
  List<TaskByAssetDataEntity> _equipmentData = [];
  List<dynamic> _filteredData = [];
  String _errorMessage = '';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    // Add listener to search field
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize use case after dependencies are available
    try {
      _getTaskByLocalUseCase =
          ApplicationContainer.instance().resolve<GetTaskByLocalUseCase>();
      _getTaskByAssetUseCase =
          ApplicationContainer.instance().resolve<GetTaskByAssetUseCase>();

      // Load initial data if dates are available
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadInitialData();
        }
      });
    } catch (e) {
      setState(() {
        _loadingState = _LoadingState.error;
        _errorMessage = 'Erro ao inicializar: ${e.toString()}';
      });
    }
  }

  @override
  void didUpdateWidget(EnvironmentEquipmentAnalysisCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Recarrega dados se as datas mudaram
    if (oldWidget.startDate != widget.startDate ||
        oldWidget.endDate != widget.endDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _loadInitialData();
        }
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialData() async {
    if (_selectedTab == EnvironmentEquipmentTabType.environment) {
      await _loadEnvironmentData();
    } else {
      await _loadEquipmentData();
    }
  }

  Future<void> _loadEnvironmentData() async {
    if (!mounted) return;

    if (widget.startDate == null || widget.endDate == null) {
      if (mounted) {
        setState(() {
          _loadingState = _LoadingState.initial;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _loadingState = _LoadingState.loading;
      });
    }

    try {
      final dtStart =
          "${widget.startDate!.day.toString().padLeft(2, '0')}/${widget.startDate!.month.toString().padLeft(2, '0')}/${widget.startDate!.year}";
      final untilDate =
          "${widget.endDate!.day.toString().padLeft(2, '0')}/${widget.endDate!.month.toString().padLeft(2, '0')}/${widget.endDate!.year}";

      final result = await _getTaskByLocalUseCase.execute(
        dtStart: dtStart,
        untilDate: untilDate,
        typeTask: ['ORDEM_SERVICO'], // Focus on service orders
      );

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _loadingState = _LoadingState.error;
              _errorMessage =
                  'Erro ao carregar dados dos ambientes: ${failure.toString()}';
            });
          }
        },
        (response) {
          if (mounted) {
            setState(() {
              _environmentData = response.data;
              _filteredData =
                  _filterDataByQuery(_environmentData, _searchQuery);
              _loadingState = _filteredData.isEmpty
                  ? _LoadingState.empty
                  : _LoadingState.loaded;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingState = _LoadingState.error;
          _errorMessage =
              'Erro inesperado ao carregar dados dos ambientes: ${e.toString()}';
        });
      }
    }
  }

  Future<void> _loadEquipmentData() async {
    if (!mounted) return;

    if (widget.startDate == null || widget.endDate == null) {
      if (mounted) {
        setState(() {
          _loadingState = _LoadingState.initial;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _loadingState = _LoadingState.loading;
      });
    }

    try {
      final dtStart =
          "${widget.startDate!.day.toString().padLeft(2, '0')}/${widget.startDate!.month.toString().padLeft(2, '0')}/${widget.startDate!.year}";
      final untilDate =
          "${widget.endDate!.day.toString().padLeft(2, '0')}/${widget.endDate!.month.toString().padLeft(2, '0')}/${widget.endDate!.year}";

      final result = await _getTaskByAssetUseCase.execute(
        dtStart: dtStart,
        untilDate: untilDate,
        typeTask: ['ORDEM_SERVICO'], // Focus on service orders
      );

      result.fold(
        (failure) {
          if (mounted) {
            setState(() {
              _loadingState = _LoadingState.error;
              _errorMessage =
                  'Erro ao carregar dados dos equipamentos: ${failure.toString()}';
            });
          }
        },
        (response) {
          if (mounted) {
            setState(() {
              _equipmentData = response.dataTaskByAssetResponse ?? [];
              _filteredData = _filterDataByQuery(_equipmentData, _searchQuery);
              _loadingState = _filteredData.isEmpty
                  ? _LoadingState.empty
                  : _LoadingState.loaded;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingState = _LoadingState.error;
          _errorMessage =
              'Erro inesperado ao carregar dados dos equipamentos: ${e.toString()}';
        });
      }
    }
  }

  void _onSearchChanged() {
    if (!mounted) return;

    final query = _searchController.text;
    setState(() {
      _searchQuery = query;
      if (_selectedTab == EnvironmentEquipmentTabType.environment) {
        _filteredData = _filterDataByQuery(_environmentData, query);
      } else {
        _filteredData = _filterDataByQuery(_equipmentData, query);
      }
      _loadingState =
          _filteredData.isEmpty ? _LoadingState.empty : _LoadingState.loaded;
    });
  }

  List<T> _filterDataByQuery<T>(List<T> data, String query) {
    if (query.isEmpty) {
      return data;
    }

    final lowercaseQuery = query.toLowerCase();
    return data.where((item) {
      String name = '';
      if (item is TaskByLocalDataEntity) {
        name = item.name;
      } else if (item is TaskByAssetDataEntity) {
        name = item.name ?? '';
      }
      return name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return EfficiencyCardWidget(
      title: "Eficiência Operacional",
      child: Column(
        children: [
          const InfoTooltip(
            message:
                "As tarefas são inicialmente atribuídas a um grupo e passam para um responsável quando iniciadas.",
          ),
          const SizedBox(height: 16),
          _buildTabsWidget(context, theme),
          const SizedBox(height: 16),
          _buildSearchField(context, theme),
          const SizedBox(height: 16),
          _buildContent(context, theme),
        ],
      ),
    );
  }

  Widget _buildTabsWidget(BuildContext context, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildTab(
            label: "Ambiente",
            selected: _selectedTab == EnvironmentEquipmentTabType.environment,
            onTap: () {
              setState(() {
                _selectedTab = EnvironmentEquipmentTabType.environment;
              });
              _loadEnvironmentData();
            },
            theme: theme,
            palette: palette,
          ),
          const SizedBox(width: 12),
          _buildTab(
            label: "Equipamento",
            selected: _selectedTab == EnvironmentEquipmentTabType.equipment,
            onTap: () {
              setState(() {
                _selectedTab = EnvironmentEquipmentTabType.equipment;
              });
              _loadEquipmentData();
            },
            theme: theme,
            palette: palette,
          ),
        ],
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? palette.background() : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: (selected
                    ? LelloTextStyles.bodyBold(theme)
                    : LelloTextStyles.body(theme))
                ?.copyWith(color: Colors.black87),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: _selectedTab == EnvironmentEquipmentTabType.environment
              ? "Pesquisar por ambiente"
              : "Pesquisar por equipamento",
          prefixIcon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          hintStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
        style: LelloTextStyles.body(theme),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ThemeData theme) {
    switch (_loadingState) {
      case _LoadingState.loading:
        return _buildLoadingWidget();
      case _LoadingState.error:
        return _buildErrorWidget(_errorMessage);
      case _LoadingState.loaded:
        return _buildDataWidget(theme);
      case _LoadingState.empty:
        return _buildEmptyWidget(_searchQuery.isEmpty
            ? 'Nenhuma informação encontrada para o período selecionado'
            : 'Nenhuma informação encontrada para "$_searchQuery"');
      case _LoadingState.initial:
        return _buildInitialWidget();
    }
  }

  Widget _buildLoadingWidget() {
    return const Padding(
      padding: EdgeInsets.all(32.0),
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            "Carregando dados dos ambientes...",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Padding(
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
            "Erro ao carregar dados",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
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
            message,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            "Tente ajustar sua pesquisa ou o período selecionado",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialWidget() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.date_range,
            size: 64,
            color: Colors.grey.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            "Selecione um período",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Escolha as datas de início e fim para visualizar os dados dos ambientes",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataWidget(ThemeData theme) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 400),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: _filteredData.length,
        itemBuilder: (context, index) {
          final item = _filteredData[index];
          final isLast = index == _filteredData.length - 1;
          return _buildEfficiencyTile(item, theme, showDivider: !isLast);
        },
      ),
    );
  }

  Widget _buildEfficiencyTile(dynamic item, ThemeData theme,
      {bool showDivider = true}) {
    final palette = LelloTheme.palleteOf(theme);

    String name = '';
    int done = 0;
    int draft = 0;
    int notStarted = 0;
    int total = 0;

    if (item is TaskByLocalDataEntity) {
      name = item.name;
      done = item.done;
      draft = item.draft;
      notStarted = item.notStarted;
      total = item.total;
    } else if (item is TaskByAssetDataEntity) {
      name = item.name ?? '';
      done = item.done ?? 0;
      draft = item.draft ?? 0;
      notStarted = item.notStarted ?? 0;
      total = item.total ?? 0;
    }

    // Individual status counts
    final completedCount = done;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Title row without avatar
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: LelloTextStyles.subtitleBold(theme)),
            const SizedBox(height: 4),
            Text(
              "$total ${total == 1 ? 'ordem de serviço' : 'ordens de serviço'}",
              style: LelloTextStyles.caption(theme)?.copyWith(
                color: palette.grey(),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Progress bar - always show statuses in order: completed, inProgress, pending
        TaskProgressBar(statuses: [
          TaskStatus(
            status: TaskStatusType.completed,
            count: completedCount,
          ),
          TaskStatus(
            status: TaskStatusType.inProgress,
            count: draft,
          ),
          TaskStatus(
            status: TaskStatusType.pending,
            count: notStarted > 0
                ? notStarted
                : (total > 0 && completedCount == 0 && draft == 0
                    ? 1
                    : notStarted),
          ),
        ]),

        const SizedBox(height: 10),

        if (showDivider) const Divider(),
      ],
    );
  }
}
