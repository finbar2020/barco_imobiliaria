import 'package:essentials/app_localization.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/info_tooltip_widget.dart';

import 'task_summary_model.dart';
import 'bloc/task_summary_bloc.dart';
import 'bloc/task_summary_event.dart';
import 'bloc/task_summary_state.dart';
import '../../../../domain/entity/efficiency_entity.dart';

class TaskSummaryCard extends StatefulWidget {
  final String dtStart;
  final String untilDate;

  const TaskSummaryCard({
    super.key,
    required this.dtStart,
    required this.untilDate,
  });

  @override
  State<TaskSummaryCard> createState() => _TaskSummaryCardState();
}

class _TaskSummaryCardState extends State<TaskSummaryCard> {
  late TaskSummaryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<TaskSummaryBloc>();
    _loadTaskSummary();
  }

  @override
  void didUpdateWidget(TaskSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Só recarrega se as datas mudaram (mudança de semana)
    if (oldWidget.dtStart != widget.dtStart ||
        oldWidget.untilDate != widget.untilDate) {
      _loadTaskSummary();
    }
  }

  @override
  void dispose() {
    // Não fechamos o BLoC pois ele é um singleton reutilizado
    super.dispose();
  }

  void _loadTaskSummary() {
    _bloc.add(LoadTaskSummaryEvent(
      dtStart: widget.dtStart,
      untilDate: widget.untilDate,
    ));
  }

  TaskSummaryData _convertToTaskSummaryData(TaskSummaryEntity entity) {
    return TaskSummaryData(
      totalTasks: entity.total,
      statuses: [
        TaskStatus(
          status: TaskStatusType.pending,
          count: entity.notStarted,
        ),
        TaskStatus(
          status: TaskStatusType.inProgress,
          count: entity.draft,
        ),
        TaskStatus(
          status: TaskStatusType.completed,
          count: entity.done,
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, TaskSummaryData data) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: pallete.background(),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5), // changes position of shadow
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          getString(context, "task_summary_week_total"),
                          style: LelloTextStyles.captionBold(theme)
                              ?.copyWith(color: pallete.grey()),
                        ),
                        Text(
                          '${data.totalTasks} ${getString(context, "task_summary_tasks")}',
                          style: LelloTextStyles.titleBold(theme),
                        ),
                        const SizedBox(height: 0),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          getString(context, "task_summary_by_status"),
                          style: LelloTextStyles.captionBold(theme)
                              ?.copyWith(color: pallete.grey()),
                        ),
                        const SizedBox(height: 8),
                        ...data.statuses.map((item) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              children: [
                                Text(
                                  '${item.count}',
                                  style: LelloTextStyles.bodyBold(theme)
                                      ?.copyWith(
                                          color: item.status.color(theme)),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  item.status.name(context),
                                  style: LelloTextStyles.bodyBold(theme),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const InfoTooltip(
                message:
                    "As tarefas são inicialmente atribuídas a um grupo e passam para um responsável quando iniciadas.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskSummaryBloc, TaskSummaryState>(
      bloc: _bloc,
      listener: (context, state) {
        // Quando o estado volta para inicial (após limpar cache), recarrega
        if (state is TaskSummaryInitialState) {
          _loadTaskSummary();
        }
      },
      builder: (context, state) {
        if (state is TaskSummaryLoadingState) {
          return _buildLoadingCard(context);
        } else if (state is TaskSummaryLoadedState) {
          final data = _convertToTaskSummaryData(state.taskSummary);
          return _buildCard(context, data);
        } else if (state is TaskSummaryErrorState) {
          return _buildErrorCard(context, state.message);
        } else {
          return _buildLoadingCard(context);
        }
      },
    );
  }

  Widget _buildLoadingCard(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: pallete.background(),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade50,
            child: Row(
              children: [
                // Lado esquerdo - Total de tarefas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 120,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 80,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
                // Lado direito - Status das tarefas
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 100,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Simula os 3 status
                      ...List.generate(
                          3,
                          (index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 20,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 60,
                                      height: 14,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorCard(BuildContext context, String message) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Card(
      elevation: 5,
      child: Container(
        decoration: BoxDecoration(
          color: pallete.background(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          child: Center(
            child: Text(
              message,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: pallete.error(),
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
