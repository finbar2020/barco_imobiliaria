import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../../../domain/entity/maintenance_management_entity.dart';
import '../../shared/widgets/info_tooltip_widget.dart';
import '../../../extension/date_time_extension.dart';

class AgendaTaskListWidget extends StatefulWidget {
  final DateTime selectedDate;
  final FilterOptionsEntity? appliedFilters;

  const AgendaTaskListWidget({
    super.key,
    required this.selectedDate,
    this.appliedFilters,
  });

  @override
  State<AgendaTaskListWidget> createState() => _AgendaTaskListWidgetState();
}

class _AgendaTaskListWidgetState extends State<AgendaTaskListWidget> {
  List<TaskEntity> _tasks = [];
  bool _isLoading = true;
  bool _hasMoreTasks = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(AgendaTaskListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate ||
        oldWidget.appliedFilters != widget.appliedFilters) {
      _resetAndLoadTasks();
    }
  }

  void _resetAndLoadTasks() {
    setState(() {
      _tasks.clear();
      _currentPage = 1;
      _isLoading = true;
    });
  }

  List<TaskEntity> _getSortedTasks() {
    final tasks = List<TaskEntity>.from(_tasks);

    tasks.sort((a, b) {
      if (a.type != b.type) {
        if (a.type == TaskType.routine) return -1;
        if (b.type == TaskType.routine) return 1;
      }

      final aHasTime = a.startTime != null;
      final bHasTime = b.startTime != null;

      if (aHasTime != bHasTime) {
        if (aHasTime) return -1;
        if (bHasTime) return 1;
      }

      if (aHasTime && bHasTime) {
        return (a.startTime ?? '').compareTo(b.startTime ?? '');
      }

      return 0;
    });

    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sortedTasks = _getSortedTasks();

    if (_isLoading && _tasks.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (sortedTasks.isEmpty && !_isLoading) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                getString(context, "maintenance_management_no_tasks_for_day"),
                style: LelloTextStyles.titleSmall(theme)?.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sortedTasks.length + (_hasMoreTasks ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == sortedTasks.length) {
                return _buildLoadMoreButton(theme);
              }

              final task = sortedTasks[index];
              return _buildTaskCard(context, task, theme);
            },
          ),
        ),
        if (_isLoading && _tasks.isNotEmpty)
          const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }

  Widget _buildTaskCard(
      BuildContext context, TaskEntity task, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);
    final isRoutine = task.type == TaskType.routine;
    final taskColor = isRoutine ? Colors.blue : Colors.red;

    return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: taskColor.withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isRoutine ? 'Rotina' : 'Ordem de Serviço',
                      style: LelloTextStyles.caption(theme)?.copyWith(
                        color: taskColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(task.status).withAlpha(30),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _getStatusText(context, task.status),
                      style: LelloTextStyles.caption(theme)?.copyWith(
                        color: _getStatusColor(task.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (isRoutine) ...[
                    // Para rotinas, mostra horário de check-in ou dia todo
                    if (task.startTime != null)
                      Text(
                        task.startTime!,
                        style: LelloTextStyles.bodyBold(theme)?.copyWith(
                          color: palette.text(),
                        ),
                      )
                    else
                      Text(
                        'Dia todo',
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                  ] else ...[
                    // Para ordem de serviço, mostra "Criada há X dias"
                    Text(
                      task.createdAt?.createdRelativeText ?? 'Criada recentemente',
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ]
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task.name,
                style: LelloTextStyles.titleSmall(theme),
              ),
              // Adicionar InfoTooltip para ordens de serviço
              if (!isRoutine) ...[
                const SizedBox(height: 8),
                const InfoTooltip(
                  message:
                      "Esta ordem de serviço permanecerá visível até conclusão.",
                  margin: EdgeInsets.zero,
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    task.location,
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.grey[600],
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      task.responsible,
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    foregroundColor: palette.primary(),
                  ),
                  child: Text(
                    getString(context, "maintenance_management_view_task"),
                    style: LelloTextStyles.button(theme)?.copyWith(
                      color: palette.primary(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildLoadMoreButton(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: ElevatedButton(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() {
                    _currentPage++;
                  });
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: LelloTheme.palleteOf(theme).primary(),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text(
            getString(context, "maintenance_management_load_more"),
            style: LelloTextStyles.button(theme)?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return Colors.orange;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(BuildContext context, TaskStatus status) {
    switch (status) {
      case TaskStatus.pending:
        return getString(context, "maintenance_management_status_pending");
      case TaskStatus.inProgress:
        return getString(context, "maintenance_management_status_in_progress");
      case TaskStatus.completed:
        return getString(context, "maintenance_management_status_completed");
      case TaskStatus.cancelled:
        return getString(context, "maintenance_management_status_cancelled");
    }
  }
}

class TaskEntity {
  final String id;
  final String name;
  final TaskType type;
  final TaskStatus status;
  final String? startTime;
  final String location;
  final String responsible;
  final DateTime? createdAt;

  TaskEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    this.startTime,
    required this.location,
    required this.responsible,
    this.createdAt,
  });
}

enum TaskType { routine, serviceOrder }

enum TaskStatus { pending, inProgress, completed, cancelled }
