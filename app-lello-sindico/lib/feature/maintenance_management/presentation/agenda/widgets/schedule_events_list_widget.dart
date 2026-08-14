import 'package:flutter/material.dart';
import 'package:essentials/essentials.dart';
import 'package:lello/core/navigation/application_route.dart';
import '../../../domain/entity/schedule_event_task_entity.dart';
import '../../home/widgets/task_card/task_card_widget.dart';
import '../../home/widgets/task_card/task_card_enum.dart';
import '../../home/widgets/task_summary/task_summary_model.dart';
import '../bloc/schedule_events_bloc.dart';
import '../bloc/schedule_events_state.dart';

/// Widget para listar eventos/tarefas agendados usando a nova API schedule-events
class ScheduleEventsListWidget extends StatefulWidget {
  final DateTime selectedDate;
  final bool useDetailedView;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  const ScheduleEventsListWidget({
    super.key,
    required this.selectedDate,
    this.useDetailedView = false,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  State<ScheduleEventsListWidget> createState() =>
      _ScheduleEventsListWidgetState();
}

class _ScheduleEventsListWidgetState extends State<ScheduleEventsListWidget> {
  // Variáveis para paginação
  static const int _itemsPerPage = 5;
  int _currentPage = 1;

  // Getter para calcular quantos itens mostrar
  int get _itemsToShow => _currentPage * _itemsPerPage;

  void _loadMoreItems() {
    setState(() {
      _currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScheduleEventsBloc, ScheduleEventsState>(
      builder: (context, state) {
        return _buildContent(state);
      },
    );
  }

  Widget _buildContent(ScheduleEventsState state) {
    if (state is ScheduleEventsInitialState) {
      return const Center(child: Text('Selecione uma data'));
    } else if (state is ScheduleEventsLoadingState) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ScheduleEventsLoadedState) {
      return _buildLoadedContent(state.events);
    } else if (state is ScheduleEventsEmptyState) {
      return const Center(
        child: Text('Nenhum evento encontrado para esta data'),
      );
    } else if (state is ScheduleEventsErrorState) {
      return Center(
        child: Text('Erro: ${state.message}'),
      );
    } else if (state is ScheduleEventsDetailLoadedState) {
      return _buildDetailLoadedState(state);
    } else if (state is ScheduleEventsDetailEmptyState) {
      return _buildDetailEmptyState();
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildLoadedContent(List<ScheduleEventTaskEntity> events) {
    if (events.isEmpty) {
      return const Center(
        child: Text('Nenhum evento encontrado para esta data'),
      );
    }

    // Calcular quantos itens mostrar
    final itemsToShow = _itemsToShow.clamp(0, events.length);
    final visibleEvents = events.take(itemsToShow).toList();
    final hasMoreItems = events.length > itemsToShow;

    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: visibleEvents.length + (hasMoreItems ? 1 : 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        // Se é o último item e há mais items, mostrar botão "Ver mais"
        if (index == visibleEvents.length && hasMoreItems) {
          return _buildLoadMoreButton(events.length - itemsToShow);
        }

        // Caso contrário, mostrar o card normal
        final event = visibleEvents[index];
        final id = event.idScheduleEvent;
        final startTime = event.timeStart;

        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: TaskCardWidget(
            title: event.name.isNotEmpty ? event.name : 'Sem título',
            start: startTime,
            timeDescription: event.timeDescription,
            type: _convertToTaskType(event.typeTask),
            status: _convertToTaskStatusType(event.status),
            isAllDay: event.allDay,
            onTap: () {
              Navigator.of(context).pushNamed(
                ApplicationRoute.maintenanceManagementTaskDetails,
                arguments: id,
              );
            },
            createdAt: _parseCreatedDate(event.dtStart),
            referenceDate: widget.selectedDate,
          ),
        );
      },
    );
  }

  Widget _buildLoadMoreButton(int remainingItems) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: TextButton(
          onPressed: _loadMoreItems,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Ver mais',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.blue,
              ),
            ],
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          ),
        ),
      ),
    );
  }

  TaskStatusType _convertToTaskStatusType(String status) {
    switch (status.toUpperCase()) {
      case 'DONE':
      case 'COMPLETED':
        return TaskStatusType.completed;
      case 'NOT_STARTED':
      case 'PENDING':
        return TaskStatusType.pending;
      case 'DRAFT':
      case 'IN_PROGRESS':
        return TaskStatusType.inProgress;
      default:
        return TaskStatusType.pending;
    }
  }

  TaskType _convertToTaskType(String typeTask) {
    switch (typeTask.toUpperCase()) {
      case 'ROTINA':
      case 'ROUTINE':
        return TaskType.routine;
      case 'OS':
      case 'ORDEM_SERVICO':
        return TaskType.serviceOrder;
      default:
        return TaskType.routine;
    }
  }

  Widget _buildDetailLoadedState(ScheduleEventsDetailLoadedState state) {
    return ListView.builder(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
      itemCount: state.detailResponse.data.taskSummaryDay.length,
      itemBuilder: (context, dayIndex) {
        final dayData = state.detailResponse.data.taskSummaryDay[dayIndex];

        // Aplicar paginação apenas aos tasks do dia
        final itemsToShow = _itemsToShow.clamp(0, dayData.taskFormulary.length);
        final visibleTasks = dayData.taskFormulary.take(itemsToShow).toList();
        final hasMoreItems = dayData.taskFormulary.length > itemsToShow;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, color: Colors.blue[700]),
                  const SizedBox(width: 12),
                  Text(
                    dayData.date,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blue[700],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${dayData.taskFormulary.length} evento(s)',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                    ),
                  ),
                ],
              ),
            ),
            // Tasks visíveis
            ...visibleTasks.map((task) {
              final startTime = task.timeStart;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TaskCardWidget(
                  title: task.name.isNotEmpty ? task.name : 'Sem título',
                  start: startTime,
                  timeDescription: task.timeDescription,
                  type: _convertToTaskType(task.typeTask),
                  status: _convertToTaskStatusType(task.status),
                  isAllDay: task.allDay,
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      ApplicationRoute.maintenanceManagementTaskDetails,
                      arguments: task.idScheduleEvent,
                    );
                  },
                  createdAt: _parseCreatedDate(task.dtStart),
                  referenceDate: widget.selectedDate,
                ),
              );
            }),
            // Botão "Ver mais" se houver mais itens
            if (hasMoreItems)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildLoadMoreButton(
                    dayData.taskFormulary.length - itemsToShow),
              ),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDetailEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_available,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum evento encontrado',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Nao ha eventos detalhados para o periodo selecionado',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Parse the dtStart string to DateTime for relative date calculation
  DateTime? _parseCreatedDate(String dtStart) {
    try {
      print('Parsing dtStart: $dtStart'); // Debug

      // Try different date formats that might come from the API
      if (dtStart.contains('T')) {
        // ISO format: 2025-11-06T10:30:00
        final parsed = DateTime.parse(dtStart);
        print('Parsed ISO date: $parsed'); // Debug
        return parsed;
      } else if (dtStart.contains('/')) {
        // Format: 06/11/2025 10:30:00 or 06/11/2025
        final parts = dtStart.split(' ');
        final datePart = parts[0];
        final dateComponents = datePart.split('/');

        if (dateComponents.length == 3) {
          final day = int.parse(dateComponents[0]);
          final month = int.parse(dateComponents[1]);
          final year = int.parse(dateComponents[2]);

          if (parts.length > 1) {
            // Has time part
            final timePart = parts[1];
            final timeComponents = timePart.split(':');
            final hour = int.parse(timeComponents[0]);
            final minute =
                timeComponents.length > 1 ? int.parse(timeComponents[1]) : 0;
            final second =
                timeComponents.length > 2 ? int.parse(timeComponents[2]) : 0;

            final parsed = DateTime(year, month, day, hour, minute, second);
            print('Parsed BR date with time: $parsed'); // Debug
            return parsed;
          } else {
            // Date only
            final parsed = DateTime(year, month, day);
            print('Parsed BR date only: $parsed'); // Debug
            return parsed;
          }
        }
      }

      // Fallback: try to parse as is
      final parsed = DateTime.parse(dtStart);
      print('Parsed fallback: $parsed'); // Debug
      return parsed;
    } catch (e) {
      print('Error parsing date $dtStart: $e');
      return null;
    }
  }
}
