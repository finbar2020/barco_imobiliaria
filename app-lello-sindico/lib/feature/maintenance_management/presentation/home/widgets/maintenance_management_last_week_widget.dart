import 'package:essentials/essentials.dart' hide Image;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_last_week/maintenance_management_last_week_bloc.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../enums/efficiency_scope_enum.dart';
import '../../shared/widgets/efficiency_card_widget.dart';
import '../../shared/widgets/efficiency_tabs_widget.dart';
import '../../shared/widgets/search_field_widget.dart';
import '../../shared/widgets/efficiency_tile_widget.dart';
import 'task_summary/task_summary_card_widget.dart';
import '../bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';
import '../../shared/widgets/shimmer_loading_widget.dart';

class MaintenanceManagementLastWeekWidget extends StatefulWidget {
  const MaintenanceManagementLastWeekWidget({super.key});

  @override
  State<MaintenanceManagementLastWeekWidget> createState() =>
      _MaintenanceManagementLastWeekWidgetState();
}

class _MaintenanceManagementLastWeekWidgetState
    extends State<MaintenanceManagementLastWeekWidget> {
  late MaintenanceManagementLastWeekBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<MaintenanceManagementLastWeekBloc>();
    _bloc.fetchEfficiencyData();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocBuilder<MaintenanceManagementLastWeekBloc,
        MaintenanceManagementLastWeekState>(
      bloc: _bloc,
      builder: (context, state) {
        if (state is MaintenanceManagementLastWeekLoadingState) {
          return _buildMixedLoadingContent(context, theme, palette);
        } else if (state is MaintenanceManagementLastWeekLoadedState) {
          return _buildContent(context, state, theme, palette);
        } else if (state is MaintenanceManagementLastWeekErrorState) {
          return _buildError(state.message, theme);
        } else {
          return _buildMixedLoadingContent(context, theme, palette);
        }
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    MaintenanceManagementLastWeekLoadedState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
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

    return Column(
      children: [
        TaskSummaryCard(
          dtStart: _getLastWeekStartDate(),
          untilDate: _getLastWeekEndDate(),
        ),
        const SizedBox(height: 16),
        EfficiencyCardWidget(
          title: getString(
              context, 'maintenance_management_efficiency_last_week_title'),
          child: Column(
            children: [
              // Tabs
              EfficiencyTabsWidget(
                selectedTab: state.currentScope == EfficiencyScope.responsibles
                    ? EfficiencyTabType.responsibles
                    : EfficiencyTabType.groups,
                onTabChanged: (tabType) {
                  final scope = tabType == EfficiencyTabType.responsibles
                      ? EfficiencyScope.responsibles
                      : EfficiencyScope.groups;
                  _bloc.changeScope(scope);
                },
                responsiblesLabel:
                    getString(context, 'maintenance_management_responsibles'),
                groupsLabel: getString(
                    context, 'maintenance_management_employee_groups'),
              ),

              const SizedBox(height: 16),

              // Search field
              SearchFieldWidget(
                hintText: getString(
                    context, 'maintenance_management_search_employee'),
                onChanged: (text) {
                  setState(() {});
                  _bloc.searchEfficiency(text);
                },
              ),

              const SizedBox(height: 16),

              // List - mostra shimmer se isLoadingList = true
              if (state.isLoadingList)
                _buildListShimmer()
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
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, ThemeData theme) =>
      Image.asset('assets/maintenance_management_empty_tasks.png');

  Widget _buildListShimmer() {
    return Column(
      children: List.generate(
        3,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(width: 12),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Progress indicators
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 40,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message, ThemeData theme) {
    final env = ApplicationContainer.instance().resolve<Environment>();
    return ErrorHandlingWidget(
      isProduction: env.isProduction,
      errorCode: 'LAST_WEEK_ERROR',
      error: message,
      message: 'Erro ao carregar dados da semana passada',
      reTryFunction: () => _bloc.fetchEfficiencyData(),
      backFunction: () {},
    );
  }

  Widget _buildMixedLoadingContent(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return ShimmerLoadingWidget(
      showTaskSummary: true,
      showTabs: true,
      showSearchField: true,
      showList: true,
      listItemCount: 3,
      tabsTitle: getString(
          context, 'maintenance_management_efficiency_last_week_title'),
      responsiblesLabel:
          getString(context, 'maintenance_management_responsibles'),
      groupsLabel: getString(context, 'maintenance_management_employee_groups'),
      searchHint: getString(context, 'maintenance_management_search_employee'),
    );
  }

  String _getLastWeekStartDate() {
    final now = DateTime.now();
    final lastWeekStart = now.subtract(Duration(days: now.weekday + 6));
    return "${lastWeekStart.day.toString().padLeft(2, '0')}/${lastWeekStart.month.toString().padLeft(2, '0')}/${lastWeekStart.year}";
  }

  String _getLastWeekEndDate() {
    final now = DateTime.now();
    final lastWeekEnd = now.subtract(Duration(days: now.weekday));
    return "${lastWeekEnd.day.toString().padLeft(2, '0')}/${lastWeekEnd.month.toString().padLeft(2, '0')}/${lastWeekEnd.year}";
  }
}
