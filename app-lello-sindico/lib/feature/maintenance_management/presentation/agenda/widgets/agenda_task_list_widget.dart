import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/info_tooltip_widget.dart';
import '../bloc/schedule_events_bloc.dart';
import '../bloc/schedule_events_state.dart';
import '../model/agenda_task_model.dart';
import '../../../domain/entity/filter_options_entity.dart';

class AgendaTaskListWidget extends StatelessWidget {
  final String selectedOrder;
  final Function(String) onOrderChanged;
  final DateTime? selectedDate;
  final FilterOptionsEntity? appliedFilters;

  const AgendaTaskListWidget({
    super.key,
    required this.selectedOrder,
    required this.onOrderChanged,
    this.selectedDate,
    this.appliedFilters,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tarefas',
                      style: LelloTextStyles.titleSmall(theme)?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: palette.text(),
                          ) ??
                          const TextStyle(),
                    ),
                    if (selectedDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatSelectedDate(selectedDate!),
                        style: LelloTextStyles.caption(theme)?.copyWith(
                              color: palette.grey(),
                            ) ??
                            const TextStyle(),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: palette.grey().withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOrderButton(
                      context,
                      'Data',
                      'data',
                      selectedOrder == 'data',
                      () => onOrderChanged('data'),
                    ),
                    const SizedBox(width: 2),
                    _buildOrderButton(
                      context,
                      'Tipo',
                      'tipo',
                      selectedOrder == 'tipo',
                      () => onOrderChanged('tipo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocBuilder<ScheduleEventsBloc, ScheduleEventsState>(
            builder: (context, state) {
              return _buildTaskListFromScheduleEvents(context, state);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildOrderButton(
    BuildContext context,
    String label,
    String value,
    bool isSelected,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(4),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: LelloTextStyles.caption(theme)?.copyWith(
                fontWeight: FontWeight.w600,
                color: isSelected ? palette.text() : palette.grey(),
              ) ??
              const TextStyle(),
        ),
      ),
    );
  }

  Widget _buildTaskListFromScheduleEvents(
      BuildContext context, ScheduleEventsState state) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    if (state is ScheduleEventsInitialState) {
      return const Center(
        child: Text('Selecione um dia com tarefas para visualizar'),
      );
    }

    if (state is ScheduleEventsLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is ScheduleEventsErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: palette.error(),
            ),
            const SizedBox(height: 16),
            Text(
              'Erro ao carregar tarefas',
              style: LelloTextStyles.titleSmall(theme)?.copyWith(
                    color: palette.error(),
                  ) ??
                  const TextStyle(),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.message,
                style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(),
                    ) ??
                    const TextStyle(),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }

    if (state is ScheduleEventsEmptyState) {
      return const Center(
        child: Text('Nenhuma tarefa encontrada para esta data'),
      );
    }

    if (state is ScheduleEventsLoadedState) {
      final tasks = state.events
          .map((entity) => AgendaTaskModel.fromScheduleEventTaskEntity(entity))
          .toList();

      return ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final task = tasks[index];
          return _buildTaskCard(context, task, theme);
        },
      );
    }
    return const Center(
      child: Text('Selecione um dia com tarefas para visualizar'),
    );
  }

  Widget _buildTaskCard(
      BuildContext context, AgendaTaskModel task, ThemeData theme) {
    final palette = LelloTheme.palleteOf(theme);

    return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: task.getTypeColor().withOpacity(0.3),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: task.getTypeColor(),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: task.getTypeColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.localizedType,
                      style: LelloTextStyles.caption(theme)?.copyWith(
                            color: task.getTypeColor(),
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    task.timeText,
                    style: LelloTextStyles.caption(theme)?.copyWith(
                          color: palette.grey(),
                        ) ??
                        const TextStyle(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                task.title,
                style: LelloTextStyles.titleSmall(theme)?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: palette.text(),
                    ) ??
                    const TextStyle(),
              ),
              if (task.type.toUpperCase() == 'ORDEM_SERVICO') ...[
                const SizedBox(height: 8),
                const InfoTooltip(
                  message:
                      "Esta ordem de serviço permanecerá visível até conclusão.",
                ),
              ],
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: LelloTextStyles.body(theme)?.copyWith(
                        color: palette.grey(),
                      ) ??
                      const TextStyle(),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (task.location.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: palette.grey(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        task.location,
                        style: LelloTextStyles.caption(theme)?.copyWith(
                              color: palette.grey(),
                            ) ??
                            const TextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (task.responsible.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: palette.grey(),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'Responsável: ${task.responsible}',
                        style: LelloTextStyles.caption(theme)?.copyWith(
                              color: palette.grey(),
                            ) ??
                            const TextStyle(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: task.getStatusColor(theme).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.localizedStatus,
                  style: LelloTextStyles.caption(theme)?.copyWith(
                        color: task.getStatusColor(theme),
                        fontWeight: FontWeight.w600,
                      ) ??
                      const TextStyle(),
                ),
              ),
            ],
          ),
        ));
  }

  String _formatSelectedDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDay = DateTime(date.year, date.month, date.day);

    if (selectedDay == today) {
      return 'Hoje';
    } else if (selectedDay == today.add(const Duration(days: 1))) {
      return 'Amanhã';
    } else if (selectedDay == today.subtract(const Duration(days: 1))) {
      return 'Ontem';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
