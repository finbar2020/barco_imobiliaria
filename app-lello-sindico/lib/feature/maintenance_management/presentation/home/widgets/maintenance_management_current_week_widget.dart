import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_event.dart';
import 'package:lello/feature/maintenance_management/presentation/home/bloc/maintenance_management_current_week/maintenance_management_current_week_state.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_progress_bar_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_card_widget.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../../../core/navigation/application_route.dart';

class MaintenanceManagementCurrentWeekWidget extends StatefulWidget {
  final FilterOptionsEntity? appliedFilters;
  final VoidCallback? onTaskDetailsReturn;

  const MaintenanceManagementCurrentWeekWidget({
    super.key,
    this.appliedFilters,
    this.onTaskDetailsReturn,
  });

  @override
  State<MaintenanceManagementCurrentWeekWidget> createState() =>
      _MaintenanceManagementCurrentWeekWidgetState();
}

class _MaintenanceManagementCurrentWeekWidgetState
    extends State<MaintenanceManagementCurrentWeekWidget> {
  DateTime? _selectedDay;
  DateTime _focusedDay = DateTime.now();
  late MaintenanceManagementCurrentWeekBloc _bloc;

  // Paginação local
  static const int _itemsPerPage = 5;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _bloc = context.read<MaintenanceManagementCurrentWeekBloc>();
    _fetchEvents();
  }

  @override
  void didUpdateWidget(MaintenanceManagementCurrentWeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Refetch events when filters change
    if (oldWidget.appliedFilters != widget.appliedFilters) {
      setState(() {
        _currentPage = 1; // Reset pagination when filters change
      });
      _fetchEvents();
    }
  }

  void _fetchEvents() {
    final startOfWeek = _getWeekStartDateTime();
    final endOfWeek = _getWeekEndDateTime();
    final currentDay = _selectedDay ?? DateTime.now();

    // Apply filters if available
    final typeTask = widget.appliedFilters?.taskType.isNotEmpty == true
        ? _mapTaskTypesToStrings(widget.appliedFilters!.taskType)
        : ["ROTINA", "ORDEM_SERVICO"];

    final status = widget.appliedFilters?.taskStatus.isNotEmpty == true
        ? _mapTaskStatusesToStrings(widget.appliedFilters!.taskStatus)
        : [];

    _bloc.add(FetchMaintenanceTaskEventsEvent(
      dtStart: startOfWeek,
      untilDate: endOfWeek,
      typeTask: typeTask.cast<String>(),
      status: status.cast<String>(),
      dayCurrent: currentDay,
      procedureGroupLabels: [],
      displayBy: "GRUPO",
      assetIds: widget.appliedFilters?.assets.map((asset) => asset.id).toList(),
      localIds: widget.appliedFilters?.locals.map((local) => local.id).toList(),
      responsibleIds:
          widget.appliedFilters?.responsibles.map((resp) => resp.id).toList(),
      pageName: "QUICK_PLANNING",
    ));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final today = DateTime.now();
    _focusedDay = DateTime.now();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // TaskSummary sempre visível - gerencia seu próprio estado de loading
        TaskSummaryCard(
          dtStart: _getWeekStartDate(),
          untilDate: _getWeekEndDate(),
        ),
        const SizedBox(height: 16),
        TableCalendar(
          firstDay: DateTime.utc(2020, 01, 01),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: _focusedDay,
          currentDay: today,
          selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
          calendarFormat: CalendarFormat.week,
          startingDayOfWeek: StartingDayOfWeek.sunday,
          headerVisible: false,
          availableGestures: AvailableGestures.none,
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            isTodayHighlighted: true,
            selectedDecoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              shape: BoxShape.circle,
            ),
            weekendTextStyle: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            defaultTextStyle: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
            outsideDaysVisible: false,
          ),
          calendarBuilders: CalendarBuilders(
            todayBuilder: (context, day, focusedDay) {
              final isSelected = isSameDay(day, _selectedDay);
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isSelected
                      ? null
                      : Border.all(
                          color: LelloTheme.palleteOf(theme).greyDarker(),
                          width: 1,
                        ),
                  color: isSelected
                      ? LelloTheme.palleteOf(theme).grey()
                      : Colors.white,
                ),
                child: Center(
                  child: Text(
                    '${day.day}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              if (!isSameDay(day, today)) {
                return Container(
                  margin: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }
              return null;
            },
          ),
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _currentPage = 1; // Reset pagination when day changes
            });
            _fetchEvents();
          },
        ),
        const SizedBox(height: 16),
        Flexible(
          child: BlocBuilder(
            bloc: _bloc,
            builder: (context, state) {
              if (state is MaintenanceManagementCurrentWeekLoadingState) {
                return _buildTaskCardShimmer(theme);
              } else if (state is MaintenanceManagementCurrentWeekLoadedState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TaskProgressBar(statuses: [
                      TaskStatus(
                        status: TaskStatusType.pending,
                        count: state.taskSummaryDay.notStarted,
                      ),
                      TaskStatus(
                        status: TaskStatusType.inProgress,
                        count: state.taskSummaryDay.draft,
                      ),
                      TaskStatus(
                        status: TaskStatusType.completed,
                        count: state.taskSummaryDay.done,
                      ),
                    ]),
                    const SizedBox(height: 16),
                    state.events.isEmpty
                        ? Image.asset(
                            'assets/maintenance_management_empty_tasks.png')
                        : _buildPaginatedTaskList(state, theme),
                  ],
                );
              } else if (state is MaintenanceManagementCurrentWeekErrorState) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Erro ao carregar tarefas: ${state.message}'),
                );
              } else {
                return _buildTaskCardShimmer(theme);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPaginatedTaskList(
      MaintenanceManagementCurrentWeekLoadedState state, ThemeData theme) {
    // Calcular quantos itens mostrar
    final itemsToShow =
        (_currentPage * _itemsPerPage).clamp(0, state.events.length);
    final visibleEvents = state.events.take(itemsToShow).toList();
    final hasMoreItems = state.events.length > itemsToShow;

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: visibleEvents.length,
          itemBuilder: (context, index) {
            final event = visibleEvents[index];
            final id = event.idScheduleEvent;

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: TaskCardWidget(
                title: event.title,
                start: event.timeStart,
                isAllDay: event.allDay,
                timeDescription: event.timeDescription,
                status: _mapStatus(event.status),
                onTap: () async {
                  final shouldRefresh = await Navigator.of(context).pushNamed(
                    ApplicationRoute.maintenanceManagementTaskDetails,
                    arguments: id!,
                  );

                  if (shouldRefresh == true && mounted) {
                    _fetchEvents();
                    widget.onTaskDetailsReturn?.call();
                  }
                },
                type: _mapType(event.typeTask),
                showViewTaskButton: true,
                createdAt: event.dtStart,
              ),
            );
          },
        ),
        if (hasMoreItems)
          _buildLoadMoreButton(theme, state.events.length - itemsToShow),
      ],
    );
  }

  Widget _buildLoadMoreButton(ThemeData theme, int remainingItems) {
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: TextButton(
          onPressed: () {
            setState(() {
              _currentPage++;
            });
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ver mais',
                style: LelloTextStyles.button(theme)?.copyWith(
                  color: palette.buttonSystem(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: palette.buttonSystem(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TaskStatusType _mapStatus(String status) {
    switch (status) {
      case 'DONE':
        return TaskStatusType.completed;
      case 'DRAFT':
        return TaskStatusType.inProgress;
      case 'NOT_STARTED':
      default:
        return TaskStatusType.pending;
    }
  }

  TaskType _mapType(String typeTask) {
    switch (typeTask) {
      case 'ROTINA':
        return TaskType.routine;
      case 'ORDEM_SERVICO':
        return TaskType.serviceOrder;
      default:
        return TaskType.routine;
    }
  }

  // Retorna o DateTime do primeiro dia da semana (domingo)
  DateTime _getWeekStartDateTime() {
    final now = DateTime.now();
    // weekday retorna 1 para segunda, 2 para terça, ..., 7 para domingo
    // Para obter o domingo da semana, subtraímos (weekday % 7) dias
    final daysToSubtract = now.weekday % 7;
    return now.subtract(Duration(days: daysToSubtract));
  }

  // Retorna o DateTime do último dia da semana (sábado)
  DateTime _getWeekEndDateTime() {
    final startOfWeek = _getWeekStartDateTime();
    return startOfWeek.add(const Duration(days: 6));
  }

  String _getWeekStartDate() {
    final startOfWeek = _getWeekStartDateTime();
    return "${startOfWeek.day.toString().padLeft(2, '0')}/${startOfWeek.month.toString().padLeft(2, '0')}/${startOfWeek.year}";
  }

  String _getWeekEndDate() {
    final endOfWeek = _getWeekEndDateTime();
    return "${endOfWeek.day.toString().padLeft(2, '0')}/${endOfWeek.month.toString().padLeft(2, '0')}/${endOfWeek.year}";
  }

  List<String> _mapTaskTypesToStrings(List<TaskType> taskTypes) {
    return taskTypes.map((type) {
      switch (type) {
        case TaskType.routine:
          return "ROTINA";
        case TaskType.serviceOrder:
          return "ORDEM_SERVICO";
      }
    }).toList();
  }

  List<String> _mapTaskStatusesToStrings(List<TaskStatusType> statuses) {
    return statuses.map((status) {
      switch (status) {
        case TaskStatusType.pending:
          return "NOT_STARTED";
        case TaskStatusType.inProgress:
          return "DRAFT";
        case TaskStatusType.completed:
          return "DONE";
      }
    }).toList();
  }

  Widget _buildTaskCardShimmer(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 80,
                height: 5,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Container(
                width: 80,
                height: 5,
                color: Colors.white,
              ),
              const SizedBox(width: 8),
              Container(
                width: 80,
                height: 5,
                color: Colors.white,
              ),
            ],
          ),
          const SizedBox(height: 16),
          TaskCardWidget(
            title: 'Carregando...',
            start: '',
            timeDescription: '',
            isAllDay: false,
            status: TaskStatusType.pending,
            onTap: () {},
            type: TaskType.routine,
          ),
          const SizedBox(height: 16),
          TaskCardWidget(
            title: 'Carregando...',
            start: '',
            timeDescription: '',
            isAllDay: false,
            status: TaskStatusType.inProgress,
            onTap: () {},
            type: TaskType.serviceOrder,
          ),
        ],
      ),
    );
  }
}
