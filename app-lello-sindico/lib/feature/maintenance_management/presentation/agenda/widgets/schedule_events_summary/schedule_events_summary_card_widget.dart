import 'package:essentials/app_localization.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/app_theme.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';

import 'schedule_events_summary_model.dart';
import '../../bloc/schedule_events_bloc.dart';
import '../../bloc/schedule_events_state.dart';
import '../../../../domain/entity/efficiency_entity.dart';

class ScheduleEventsSummaryCard extends StatefulWidget {
  final DateTime selectedDate;

  const ScheduleEventsSummaryCard({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ScheduleEventsSummaryCard> createState() =>
      _ScheduleEventsSummaryCardState();
}

class _ScheduleEventsSummaryCardState extends State<ScheduleEventsSummaryCard> {
  @override
  void initState() {
    super.initState();
    // Não precisamos mais de inicialização específica já que estamos
    // ouvindo diretamente o ScheduleEventsBloc
  }

  @override
  void didUpdateWidget(ScheduleEventsSummaryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Não precisa fazer nada pois o BlocBuilder vai reagir automaticamente
    // às mudanças no ScheduleEventsBloc
  }

  @override
  void dispose() {
    super.dispose();
  }

  ScheduleEventsSummaryData _convertToScheduleEventsSummaryData(
      TaskSummaryEntity entity) {
    return ScheduleEventsSummaryData(
      totalEvents: entity.total,
      statuses: [
        ScheduleEventStatus(
          status: ScheduleEventStatusType.notStarted,
          count: entity.notStarted,
        ),
        ScheduleEventStatus(
          status: ScheduleEventStatusType.draft,
          count: entity.draft,
        ),
        ScheduleEventStatus(
          status: ScheduleEventStatusType.done,
          count: entity.done,
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, ScheduleEventsSummaryData data) {
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
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getString(context, "schedule_events_day_total"),
                      style: LelloTextStyles.captionBold(theme)
                          ?.copyWith(color: pallete.grey()),
                    ),
                    Text(
                      '${data.totalEvents} ${getString(context, "schedule_events_events")}',
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
                                  ?.copyWith(color: item.status.color(theme)),
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleEventsBloc, ScheduleEventsState>(
      builder: (context, scheduleState) {
        if (scheduleState is ScheduleEventsLoadingState) {
          return _buildLoadingCard(context);
        } else if (scheduleState is ScheduleEventsLoadedState) {
          if (_isSameDate(scheduleState.selectedDate, widget.selectedDate)) {
            final tasks = scheduleState.events;
            int done = tasks
                .where((task) => task.status.toUpperCase() == 'DONE')
                .length;
            int notStarted = tasks
                .where((task) => task.status.toUpperCase() == 'NOT_STARTED')
                .length;
            int draft = tasks
                .where((task) => task.status.toUpperCase() == 'DRAFT')
                .length;

            final taskSummary = TaskSummaryEntity(
              total: tasks.length,
              done: done,
              notStarted: notStarted,
              draft: draft,
              pending: 0,
            );

            final data = _convertToScheduleEventsSummaryData(taskSummary);
            return _buildCard(context, data);
          } else {
            return _buildLoadingCard(context);
          }
        } else if (scheduleState is ScheduleEventsEmptyState) {
          if (_isSameDate(scheduleState.selectedDate, widget.selectedDate)) {
            final emptySummary = TaskSummaryEntity(
              total: 0,
              done: 0,
              notStarted: 0,
              draft: 0,
              pending: 0,
            );
            final data = _convertToScheduleEventsSummaryData(emptySummary);
            return _buildCard(context, data);
          } else {
            return _buildLoadingCard(context);
          }
        } else if (scheduleState is ScheduleEventsErrorState) {
          return _buildErrorCard(context, scheduleState.message);
        } else {
          return _buildLoadingCard(context);
        }
      },
    );
  }

  bool _isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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
