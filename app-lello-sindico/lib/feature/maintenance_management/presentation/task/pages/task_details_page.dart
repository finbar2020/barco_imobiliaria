import 'package:essentials/essentials.dart' hide Image;
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../bloc/task_details_bloc.dart';
import '../bloc/task_details_event.dart';
import '../bloc/task_details_state.dart';
import '../bloc/task_edit/task_edit_state.dart';
import '../../shared/widgets/task_tabs_widget.dart';
import '../../../domain/entity/task_details_entity.dart';
import '../../../domain/entity/task_formularies_entity.dart';
import '../../../domain/entity/task_files_entity.dart';
import '../../../domain/use_cases/delete_schedule_event_use_case.dart';
import '../../../domain/entity/delete_schedule_event_entity.dart';
import '../../../domain/use_cases/chat/create_chat_channel_use_case.dart';
import '../../../domain/entity/chat/chat_channel_entity.dart';
import '../../../../../core/dependency/application_container.dart';
import '../../../../../core/navigation/application_route.dart';
import 'file_preview_page.dart';
import 'task_edit_page.dart';
import 'task_delete_confirmation_modal.dart';
import 'task_delete_success_page.dart';
import 'task_start_step_confirmation_modal.dart';
import 'task_report_page.dart';
import '../../chat/widgets/index.dart';

class TaskDetailsPage extends StatefulWidget {
  final String taskId;

  const TaskDetailsPage({
    super.key,
    required this.taskId,
  });

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late final TaskDetailsBloc _bloc;
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<TaskDetailsBloc>();
    _bloc.loadTaskDetails(widget.taskId);
  }

  String _mapTaskTypeLabel(String typeTask) {
    switch (typeTask.toUpperCase()) {
      case 'ORDEM_SERVICO':
        return 'ORDEM DE SERVIÇO';
      default:
        return 'ROTINA';
    }
  }

  Color _mapTaskTypeColor(String typeTask, ColorPallete palette) {
    switch (typeTask.toUpperCase()) {
      case 'ORDEM_SERVICO':
        return palette.crimsonRed();
      default:
        return palette.routineBlue();
    }
  }

  bool _isServiceOrder(String typeTask) {
    return typeTask.toUpperCase() == 'ORDEM_SERVICO';
  }

  String _formatDate(String? isoString) {
    if (isoString == null || isoString.isEmpty) {
      return '-';
    }

    try {
      // Tenta parse direto se já estiver no formato dd/MM/yyyy
      if (isoString.contains('/')) {
        final parts = isoString.split('/');
        if (parts.length == 3) {
          return isoString; // Já está formatado
        }
      }

      final date = DateTime.parse(isoString);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (_) {
      return '-';
    }
  }

  String _formatFrequency(TaskDetailsEntity task) {
    final rrule = task.rRule;

    if (rrule == null) {
      return '-';
    }

    if (rrule.isDaily) {
      return 'Todos os dias';
    }

    if (rrule.isWeekly) {
      final byDays = rrule.byDays;
      if (byDays != null && byDays.length == 7) {
        return 'Todos os dias';
      }

      if (byDays != null && byDays.isNotEmpty) {
        final mappedDays = byDays
            .map((day) => _weekdayLabel(day.trim()))
            .where((label) => label.isNotEmpty)
            .toList();

        if (mappedDays.isNotEmpty) {
          return mappedDays.join(', ');
        }
      }

      return 'Semanal';
    }

    switch (rrule.frequency.toUpperCase()) {
      case 'MONTHLY':
        return 'Todo mês';
      case 'YEARLY':
        return 'Todo ano';
      default:
        return 'Recorrência';
    }
  }

  String _weekdayLabel(String code) {
    switch (code.toUpperCase()) {
      case 'SU':
        return 'Dom';
      case 'MO':
        return 'Seg';
      case 'TU':
        return 'Ter';
      case 'WE':
        return 'Qua';
      case 'TH':
        return 'Qui';
      case 'FR':
        return 'Sex';
      case 'SA':
        return 'Sáb';
      default:
        return '';
    }
  }

  String _formatDuration(TaskDetailsEntity task) {
    // Para ambos os tipos (ORDEM_SERVICO e ROTINA): exibir a data formatada (dd/MM/yyyy) na tela de detalhes

    // Primeiro tentar usar createdAt (preferível)
    if (task.createdAt != null) {
      try {
        final createdDate = DateTime.parse(task.createdAt!);
        final result = DateFormat('dd/MM/yyyy').format(createdDate);
        return result;
      } catch (e) {
        // Se falhar, continua para próxima opção
      }
    }

    // Fallback: tentar usar dtStart se createdAt não estiver disponível
    if (task.dtStart != null) {
      try {
        // Tentar diferentes formatos
        DateTime startDate;
        if (task.dtStart!.contains('T')) {
          // ISO format
          startDate = DateTime.parse(task.dtStart!);
        } else if (task.dtStart!.contains('/')) {
          // Format: 06/11/2025 10:30:00 or 06/11/2025
          final parts = task.dtStart!.split(' ');
          final datePart = parts[0];
          final dateComponents = datePart.split('/');

          if (dateComponents.length == 3) {
            final day = int.parse(dateComponents[0]);
            final month = int.parse(dateComponents[1]);
            final year = int.parse(dateComponents[2]);
            startDate = DateTime(year, month, day);
          } else {
            throw FormatException('Invalid date format');
          }
        } else {
          startDate = DateTime.parse(task.dtStart!);
        }

        final result = DateFormat('dd/MM/yyyy').format(startDate);
        return result;
      } catch (e) {
        // Se falhar, continua para próxima opção
      }
    }

    // Fallback para rotinas: mostrar horário se não conseguir parsear data
    if (!_isServiceOrder(task.typeTask)) {
      final isAllDay = task.allDay;
      if (isAllDay) {
        return 'Dia inteiro';
      }

      final start = task.timeStart;
      if (start != null) {
        return start;
      }
    }

    return '-';
  }

  String _formatTime(TaskDetailsEntity task) {
    // Para o ícone de relógio: mostra hora de início/criação
    final isAllDay = task.allDay;
    if (isAllDay) {
      return 'Dia inteiro';
    }

    final start = task.timeStart;
    if (start != null && start.isNotEmpty) {
      return start;
    }

    return '-';
  }

  String _formatResponsible(TaskDetailsEntity task) {
    // Prioridade: first_responsible > currentResponsibleName > currentUser
    return task.procedure?.firstResponsible?.name ??
        task.currentResponsibleName ??
        task.task?.currentResponsibleName ??
        task.responsibleUserName ??
        '-';
  }

  Color _getStatusColorByCode(String status, ColorPallete palette) {
    switch (status.toUpperCase()) {
      case 'DONE':
        return palette.success();
      case 'DRAFT':
        return palette.raffle();
      case 'NOT_STARTED':
        return palette.warning();
      default:
        return Colors.grey;
    }
  }

  String _getStatusTextByCode(String status) {
    switch (status.toUpperCase()) {
      case 'DONE':
        return 'Concluído';
      case 'DRAFT':
        return 'Em andamento';
      case 'NOT_STARTED':
        return 'Pendente';
      default:
        return status;
    }
  }

  @override
  void dispose() {
    // BLoC será gerenciado pelo ApplicationContainer
    super.dispose();
  }

  /// Verifica se já existe channel ou cria um novo e navega para a tela de chat
  Future<void> _handleChatButtonTap(TaskDetailsEntity task) async {
    // Verificar se já existe channel
    final existingChannelId = task.task?.channel?.id;

    if (existingChannelId != null && existingChannelId.isNotEmpty) {
      // Já existe channel, converter para ChatChannelEntity e navegar
      final channelDetails = task.task!.channel!;

      // Converter TaskDetailsChannelEntity para ChatChannelEntity
      final chatChannel = ChatChannelEntity(
        id: channelDetails.id,
        typeTask: channelDetails.typeTask,
        status: task.status, // Usar status atual da tarefa, não do channel
        task: ChannelTaskEntity(
          id: task.task!.id,
          name: channelDetails.task,
        ),
      );

      if (mounted) {
        // Navegar diretamente para a tela de mensagens
        final result = await Navigator.of(context).pushNamed(
          ApplicationRoute.maintenanceManagementChatMessages,
          arguments: {
            'channel': chatChannel,
            'ttJwtToken': task.ttJwtToken,
            'taskId': task
                .task!.id, // Passar taskId para indicar que veio dos detalhes
          },
        );

        // Se retornou true, recarregar detalhes
        if (result == true && mounted) {
          _bloc.loadTaskDetails(widget.taskId);
        }
      }
      return;
    }

    // Não existe channel, criar um novo

    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final createChannelUseCase =
          ApplicationContainer.instance().resolve<CreateChatChannelUseCase>();

      // Usar o ID da task real (task.task.id), não o ID do schedule event
      final taskId = task.task?.id ?? task.taskId ?? task.id;
      print(
          '📋 Criando channel para task ID: $taskId (task.task.id: ${task.task?.id}, task.taskId: ${task.taskId}, task.id: ${task.id})');

      final request = CreateChatChannelRequest(
        taskId: taskId,
        name: task.name,
      );

      final result = await createChannelUseCase(request);

      // Fechar loading
      if (mounted) {
        Navigator.of(context).pop();
      }

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao criar conversa. Tente novamente.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        (channel) async {
          if (mounted) {
            // Recarregar detalhes da tarefa para atualizar o channel
            _bloc.loadTaskDetails(widget.taskId);

            // Atualizar o status do channel com o status atual da tarefa
            final updatedChannel = channel.copyWith(
              status: task.status,
            );

            // Navegar diretamente para a tela de mensagens do canal criado
            final result = await Navigator.of(context).pushNamed(
              ApplicationRoute.maintenanceManagementChatMessages,
              arguments: {
                'channel': updatedChannel, // Usar channel com status atualizado
                'ttJwtToken': task.ttJwtToken,
                'taskId': task.task!
                    .id, // Passar taskId para indicar que veio dos detalhes
              },
            );

            // Se retornou true, recarregar detalhes novamente
            if (result == true && mounted) {
              _bloc.loadTaskDetails(widget.taskId);
            }
          }
        },
      );
    } catch (e) {
      // Fechar loading em caso de exceção
      if (mounted) {
        Navigator.of(context).pop();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro inesperado ao criar conversa.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleDelete(
      TaskDetailsEntity task, TaskDeleteScope scope) async {
    // Mostrar loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    final useCase =
        ApplicationContainer.instance().resolve<DeleteScheduleEventUseCase>();

    final mode = scope == TaskDeleteScope.single
        ? 'THIS_SCHEDULE_EVENT'
        : 'NEXT_SCHEDULE_EVENTS';

    final request = DeleteScheduleEventRequestEntity(
      scheduleEventId: task.taskId ?? '',
      mode: mode,
    );

    try {
      final result = await useCase(request);

      // Fechar loading dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      result.fold(
        (failure) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Erro ao excluir a tarefa. Tente novamente.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 4),
              ),
            );
          }
        },
        (response) async {
          if (response.success && mounted) {
            // Navegar para tela de sucesso
            final title = scope == TaskDeleteScope.single
                ? 'Tarefa excluída com sucesso!'
                : 'Todas as tarefas excluídas com sucesso!';

            final description = scope == TaskDeleteScope.single
                ? 'A tarefa selecionada foi removida da rotina. Nenhuma outra tarefa foi alterada.'
                : 'Todas as tarefas a partir desta foram removidas da rotina. Essa ação não afeta registros anteriores.';

            // Abre a tela de sucesso
            await Navigator.of(context).push<bool>(
              MaterialPageRoute(
                builder: (context) => TaskDeleteSuccessPage(
                  title: title,
                  description: description,
                  isSingleDelete: scope == TaskDeleteScope.single,
                ),
              ),
            );

            // Sempre fecha a tela de detalhes e passa true para recarregar a home
            // independente de como o usuário saiu da tela de sucesso
            if (mounted) {
              Navigator.of(context).pop(true);
            }
          } else if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  response.message ??
                      'Erro ao excluir a tarefa. Tente novamente.',
                ),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
      );
    } catch (e) {
      // Fechar loading dialog em caso de exceção
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao excluir a tarefa. Tente novamente.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 4),
          ),
        );
      }
    }
  }

  /// Verifica se ainda existem formulários que podem ser iniciados
  bool _hasFormulariesNotDone(TaskDetailsLoadedState state) {
    return state.formularies.any((f) => f.canStart == true);
  }

  /// Verifica se é uma tarefa com duas etapas (tem formulários)
  bool _hasMultipleSteps(TaskDetailsLoadedState state) {
    return state.formularies.isNotEmpty;
  }

  Future<void> _handleStartStep(TaskDetailsEntity task) async {
    final currentState = _bloc.state;
    if (currentState is! TaskDetailsLoadedState) return;

    // Buscar o próximo formulário que pode ser iniciado (canStart = true, ordenado por position)
    TaskFormularyEntity? nextFormularyToStart;
    try {
      final formulariesToStart = currentState.formularies
          .where((f) => f.canStart == true)
          .toList()
        ..sort((a, b) => a.position.compareTo(b.position));

      if (formulariesToStart.isNotEmpty) {
        nextFormularyToStart = formulariesToStart.first;
      }
    } catch (e) {
      // Se não encontrar nenhum formulário que pode iniciar, usa valores padrão
      nextFormularyToStart = null;
    }

    // Nome da etapa: usa o nome do formulário ou "ABERTURA" como fallback
    final stepName = nextFormularyToStart?.name.toUpperCase() ?? 'ABERTURA';

    // Mostrar modal de confirmação com o nome da etapa
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => TaskStartStepConfirmationModal(
        stepName: stepName,
      ),
    );

    if (confirmed != true || !mounted) return;

    String? eventIdToUse = nextFormularyToStart?.eventId;

    // Se eventId for null, precisamos criar a task primeiro
    if (eventIdToUse == null) {
      // Verificar se temos scheduleId
      if (task.scheduleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: scheduleId não encontrado'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Disparar evento para criar task
      _bloc.add(CreateTaskFromScheduleEvent(
        scheduleId: task.scheduleId ?? '',
        scheduleEventId: widget.taskId,
      ));

      // Aguardar a criação da task
      await for (final state in _bloc.stream) {
        if (state is TaskDetailsTaskCreatedState) {
          eventIdToUse = state.eventId;
          break;
        } else if (state is TaskDetailsTaskCreationErrorState) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }
    }

    // Navegar para a tela de abertura de etapa com o eventId
    if (mounted && eventIdToUse != null) {
      final result = await Navigator.of(context).pushNamed(
        ApplicationRoute.maintenanceManagementTaskInitStep,
        arguments: {
          'taskId': widget.taskId,
          'task': task,
          'eventId': eventIdToUse,
        },
      );

      // Se a etapa foi iniciada com sucesso ou resetada, recarregar os detalhes da tarefa
      if (mounted &&
          (result == true ||
              (result is Map && result['reset_success'] == true))) {
        _bloc.add(LoadTaskDetailsEvent(widget.taskId));
      }
    }
  }

  Future<void> _handleStartStepFromFormulary(
      TaskFormularyEntity formulary) async {
    final currentState = _bloc.state;
    if (currentState is! TaskDetailsLoadedState) return;

    final task = currentState.task;

    // Mostrar modal de confirmação com o nome da etapa
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => TaskStartStepConfirmationModal(
        stepName: formulary.name.toUpperCase(),
      ),
    );

    if (confirmed != true || !mounted) return;

    String? eventIdToUse = formulary.eventId;

    // Se eventId for null, precisamos criar a task primeiro
    if (eventIdToUse == null) {
      // Verificar se temos scheduleId
      if (task.scheduleId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro: scheduleId não encontrado'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Disparar evento para criar task
      _bloc.add(CreateTaskFromScheduleEvent(
        scheduleId: task.scheduleId ?? '',
        scheduleEventId: widget.taskId,
      ));

      // Aguardar a criação da task
      await for (final state in _bloc.stream) {
        if (state is TaskDetailsTaskCreatedState) {
          eventIdToUse = state.eventId;
          break;
        } else if (state is TaskDetailsTaskCreationErrorState) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }
    }

    // Navegar para a tela de abertura de etapa com o eventId
    if (mounted && eventIdToUse != null) {
      final result = await Navigator.of(context).pushNamed(
        ApplicationRoute.maintenanceManagementTaskInitStep,
        arguments: {
          'taskId': widget.taskId,
          'task': task,
          'eventId': eventIdToUse,
        },
      );

      // Se a etapa foi iniciada com sucesso ou resetada, recarregar os detalhes da tarefa
      if (mounted &&
          (result == true ||
              (result is Map && result['reset_success'] == true))) {
        _bloc.add(LoadTaskDetailsEvent(widget.taskId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
      bloc: _bloc,
      builder: (context, state) {
        final task = state is TaskDetailsLoadedState ? state.task : null;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          appBar: _buildAppBar(theme, palette, task: task),
          body: BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
            bloc: _bloc,
            builder: (context, state) {
              if (state is TaskDetailsLoadingState) {
                return _buildLoadingState();
              }

              if (state is TaskDetailsErrorState) {
                return _buildErrorState(state.message);
              }

              if (state is TaskDetailsLoadedState) {
                return _buildLoadedState(state, theme, palette);
              }

              return _buildLoadingState(); // Estado padrão
            },
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorPallete palette,
      {TaskDetailsEntity? task}) {
    final title = task != null && _isServiceOrder(task.typeTask)
        ? 'Gestão de tarefas'
        : 'Detalhe da tarefa';

    return PrimaryAppBar(
      title: title,
      theme: theme,
      onBackArrowPressed: () => Navigator.of(context).pop(),
      actions: [
        BlocBuilder<TaskDetailsBloc, TaskDetailsState>(
          bloc: _bloc,
          builder: (context, state) {
            // Pode editar/excluir apenas se status for NOT_STARTED
            final canEdit = state is TaskDetailsLoadedState &&
                state.task.status == 'NOT_STARTED';

            return PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: palette.background(),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onSelected: (value) async {
                // Bloqueia ações de editar/excluir se não puder editar
                if ((value == 'edit' || value == 'delete') && !canEdit) {
                  return;
                }

                if (value == 'edit') {
                  final currentState = _bloc.state;
                  if (currentState is! TaskDetailsLoadedState) {
                    return;
                  }

                  final result =
                      await Navigator.of(context).push<TaskEditStatus>(
                    MaterialPageRoute(
                      builder: (_) => TaskEditPage(task: currentState.task),
                    ),
                  );

                  if (result == TaskEditStatus.savedSingle ||
                      result == TaskEditStatus.savedFuture) {
                    _bloc.loadTaskDetails(widget.taskId);
                  }
                } else if (value == 'delete') {
                  final currentState = _bloc.state;
                  if (currentState is! TaskDetailsLoadedState) {
                    return;
                  }

                  final task = currentState.task;

                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (_) => const TaskDeleteConfirmationModal(),
                  );

                  if (confirmed == true && mounted) {
                    _handleDelete(task, TaskDeleteScope.single);
                  }
                } else if (value == 'history') {
                  final currentState = _bloc.state;
                  if (currentState is! TaskDetailsLoadedState) {
                    return;
                  }

                  final task = currentState.task;

                  // Use widget.taskId which is the scheduleEventId for the history API
                  if (widget.taskId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('ID do evento inválido'),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  Navigator.of(context).pushNamed(
                    ApplicationRoute.maintenanceManagementTaskHistory,
                    arguments: {
                      'taskId': widget.taskId,
                      'taskName': task.name,
                    },
                  );
                }
              },
              itemBuilder: (BuildContext context) => [
                // Sempre mostra Editar, mas desabilitado se não puder editar
                PopupMenuItem<String>(
                  value: 'edit',
                  enabled: canEdit,
                  child: Row(
                    children: [
                      Icon(
                        Icons.edit_outlined,
                        color: canEdit ? Colors.black87 : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Editar',
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: canEdit ? Colors.black87 : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                // Sempre mostra Excluir, mas desabilitado se não puder editar
                PopupMenuItem<String>(
                  value: 'delete',
                  enabled: canEdit,
                  child: Row(
                    children: [
                      Icon(
                        Icons.delete_outline,
                        color: canEdit ? Colors.red : Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Excluir',
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: canEdit ? Colors.red : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'history',
                  child: Row(
                    children: [
                      const Icon(Icons.history_outlined, color: Colors.black87),
                      const SizedBox(width: 12),
                      Text(
                        'Histórico da tarefa',
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: palette.background(),
            padding: const EdgeInsets.all(16.0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade50,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Badge tipo e status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 20,
                        width: 80,
                        color: Colors.white,
                      ),
                      Container(
                        height: 20,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Linha azul
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 24),
                  // Informações (data, frequência, duração, responsável)
                  Row(
                    children: [
                      Container(height: 20, width: 120, color: Colors.white),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(height: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(height: 20, width: 120, color: Colors.white),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(height: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Título da tarefa
                  Container(
                    height: 24,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 16),
                  // Card Etapa única
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 16,
                                width: 100,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                height: 14,
                                width: 150,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tabs
                  Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Conteúdo das tabs (formulários shimmer)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: List.generate(
                2,
                (index) => _buildFormularyShimmer(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: ErrorHandlingWidget(
        reTryFunction: () {
          _bloc.loadTaskDetails(widget.taskId);
        },
        backFunction: () => Navigator.pop(context, true),
        isProduction: env.isProduction,
        textReturnButton: "back_to_the_previous_page",
        message: message,
      ),
    );
  }

  Widget _buildLoadedState(
    TaskDetailsLoadedState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tooltip azul para tarefas criadas a partir de rotina
          if (state.task.parentScheduleEvent != null)
            _buildParentScheduleTooltip(state.task, theme, palette),
          Container(
            color: palette.background(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTaskInfo(state.task, theme, palette),
                const SizedBox(height: 16),
                _buildTaskTitleWithChatButton(state.task, theme, palette),
                const SizedBox(height: 16),
                // Renderiza diferente baseado no tipo de tarefa
                if (_isServiceOrder(state.task.typeTask))
                  _buildServiceOrderProgressSection(state.task, theme, palette)
                else
                  _buildTaskStep(state.task, theme, palette),
                const SizedBox(height: 16),
                // Botão de chat
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // Botão de chat
                      Builder(
                        builder: (context) {
                          // Verifica se o botão deve estar habilitado
                          final hasChannel =
                              state.task.task?.channel?.id != null &&
                                  state.task.task!.channel!.id.isNotEmpty;
                          final isTaskDone = state.task.status == 'DONE';
                          final isTaskNotStarted =
                              state.task.status == 'NOT_STARTED';

                          // Desabilita se: tarefa DONE E não tem channel, OU tarefa NOT_STARTED
                          final isDisabled =
                              (isTaskDone && !hasChannel) || isTaskNotStarted;

                          return Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: !isDisabled
                                  ? palette.primary()
                                  : palette.grey(),
                              shape: BoxShape.circle,
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: !isDisabled
                                    ? () => _handleChatButtonTap(state.task)
                                    : null,
                                customBorder: const CircleBorder(),
                                child: const Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TaskTabsWidget(
                    selectedTab: state.selectedTab,
                    onTabChanged: (tab) => _bloc.changeTab(tab),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          _buildTabsContent(state, theme, palette),
        ],
      ),
    );
  }

  Widget _buildTaskInfo(
      TaskDetailsEntity task, ThemeData theme, ColorPallete palette) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Badge de tipo e status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _mapTaskTypeLabel(task.typeTask),
                style: LelloTextStyles.captionBold(theme)?.copyWith(
                  color: _mapTaskTypeColor(task.typeTask, palette),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColorByCode(task.status, palette),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _getStatusTextByCode(task.status).toLowerCase(),
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.grey(), // Texto cinza
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Linha colorida embaixo do badge
          // Azul para ROTINA, Primary (vermelho) para ORDEM DE SERVIÇO
          Container(
            height: 2,
            width: double.infinity,
            color: _isServiceOrder(task.typeTask)
                ? palette.crimsonRed()
                : palette.routineBlue(),
          ),

          const SizedBox(height: 24),

          // Informações da tarefa conforme Figma
          // Para ORDEM DE SERVIÇO: apenas período e responsável
          // Para ROTINA: data, frequência, duração e responsável
          if (_isServiceOrder(task.typeTask))
            // Layout simplificado para Ordem de Serviço
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Linha 1: Período completo
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 22, color: palette.grey()),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatDuration(task),
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: palette.grey(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Linha 2: Responsável
                Row(
                  children: [
                    Icon(Icons.person_2_outlined,
                        size: 20, color: palette.grey()),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _formatResponsible(task),
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: palette.grey(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            )
          else
            // Layout completo para Rotina (original)
            Column(
              children: [
                // Primeira linha: Data e Frequência
                Row(
                  children: [
                    // Data (coluna esquerda - 134px width)
                    SizedBox(
                      width: 134,
                      child: Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 22, color: palette.grey()),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _formatDuration(task),
                              style: LelloTextStyles.body(theme)?.copyWith(
                                color: palette.grey(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Frequência (coluna direita - flex)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.refresh, size: 14, color: palette.grey()),
                          const SizedBox(width: 8),
                          Flexible(
                              child: Text(
                            _formatFrequency(task),
                            maxLines: 2,
                            style: LelloTextStyles.body(theme)?.copyWith(
                              color: palette.grey(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Segunda linha: Duração e Responsável
                Row(
                  children: [
                    // Duração (coluna esquerda - 134px width)
                    SizedBox(
                      width: 134,
                      child: Row(
                        children: [
                          Icon(Icons.access_time,
                              size: 20, color: palette.grey()),
                          const SizedBox(width: 8),
                          Text(
                            _formatTime(task),
                            style: LelloTextStyles.body(theme)?.copyWith(
                              color: palette.grey(),
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Responsável (coluna direita - flex)
                    Expanded(
                      child: Row(
                        children: [
                          Icon(Icons.person_2_outlined,
                              size: 20, color: palette.grey()),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              _formatResponsible(task),
                              maxLines: 2,
                              style: LelloTextStyles.body(theme)?.copyWith(
                                color: palette.grey(),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTaskTitleWithChatButton(
    TaskDetailsEntity task,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        task.name,
        style: LelloTextStyles.title(theme)?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildTaskStep(
    TaskDetailsEntity task,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            if (task.status == 'DONE')
              Icon(Icons.check_circle, color: palette.success()),
            if (task.status != 'DONE')
              Container(
                width: 15,
                height: 15,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: palette.routineBlue().withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: palette.routineBlue(),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Etapa única',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Responsável: ',
                        style: LelloTextStyles.body(theme)?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        _formatResponsible(task),
                        style: LelloTextStyles.body(theme)?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: palette.grey(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceOrderProgressSection(
    TaskDetailsEntity task,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final bool isDone = task.status == 'DONE';
    final bool isPending = task.status == 'NOT_STARTED';

    final Color progressColor =
        isDone ? palette.success() : const Color(0xFF2F80ED);

    // Define qual etapa está ativa baseado no currentFormularyName
    String currentStepName = 'Abertura'; // Valor padrão
    if (task.currentFormularyName != null &&
        task.currentFormularyName!.isNotEmpty) {
      // Usa o nome do formulário diretamente como vem da API
      currentStepName = task.currentFormularyName!;
    }

    if (isDone) {
      currentStepName = 'Concluído';
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Barra de progresso vertical
            SizedBox(
              width: 63,
              child: Transform.rotate(
                angle: 1.5708, // 90 graus em radianos
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Linha preenchida (transparente se pending)
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: isPending ? Colors.transparent : progressColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Ícone/indicador
                    Transform.rotate(
                      angle: -1.5708, // Rotaciona de volta
                      child: Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: progressColor,
                          shape: BoxShape.circle,
                        ),
                        child: isDone
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 10,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 5),
                    // Linha não preenchida (cinza)
                    Expanded(
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color:
                              isDone ? progressColor : const Color(0xFFBEBEBE),
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 15),
            // Informações da etapa
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Etapa atual: ',
                          style: LelloTextStyles.body(theme)?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          currentStepName,
                          style: LelloTextStyles.body(theme)?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: palette.grey(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          'Responsável: ',
                          style: LelloTextStyles.body(theme)?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _formatResponsible(task),
                            style: LelloTextStyles.body(theme)?.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: palette.grey(),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
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

  Widget _buildTabsContent(
      TaskDetailsLoadedState state, ThemeData theme, ColorPallete palette) {
    return Column(
      children: [
        // Conteúdo baseado na aba selecionada
        if (state.selectedTab == TaskDetailsTabType.steps)
          _buildStepsContent(state.task, theme, palette)
        else
          _buildAttachmentsContent(theme, palette),
      ],
    );
  }

  Widget _buildStepsContent(
    TaskDetailsEntity task,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final currentState = _bloc.state;
    if (currentState is! TaskDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    final formularies = currentState.formularies;

    if (currentState.isLoadingFormularies) {
      return Column(
        children: List.generate(
          2,
          (index) => _buildFormularyShimmer(),
        ),
      );
    }

    if (formularies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            'Nenhuma etapa encontrada',
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.grey(),
            ),
          ),
        ),
      );
    }

    return Column(
      children: formularies.map((formulary) {
        return _buildFormularyCard(formulary, theme, palette);
      }).toList(),
    );
  }

  Widget _buildFormularyShimmer() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primeira linha com shimmer
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE2E2E2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      height: 14,
                      width: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 13,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      height: 8,
                      width: 8,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      height: 13,
                      width: 80,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Segunda seção com shimmer
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 16,
                    width: 100,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    height: 13,
                    width: 180,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFormularyCard(
    TaskFormularyEntity formulary,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final statusColor = _getStatusColorByCode(formulary.status, palette);
    final isCompleted = formulary.status.toUpperCase() == 'DONE';
    final isPending = formulary.status.toUpperCase() == 'NOT_STARTED';
    final canStart = formulary.canStart ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(9),
      ),
      child: InkWell(
        onTap: isCompleted ? () => _navigateToTaskReport(formulary) : null,
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Primeira linha: Ícone + tempo + status
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Color(0xFFE2E2E2),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Color(0xFF666666),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        formulary.finishedAt ?? '-',
                        style: LelloTextStyles.body(theme)?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF666666),
                        ),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getStatusTextByCode(formulary.status).toLowerCase(),
                      style: LelloTextStyles.body(theme)?.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF666666),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Segunda seção: Nome do formulário e responsável
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formulary.name,
                          style: LelloTextStyles.body(theme)?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF212121),
                          ),
                        ),
                        Text(
                          formulary.responsibleName ?? '-',
                          style: LelloTextStyles.body(theme)?.copyWith(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF666666),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Seta à direita (somente se completado)
                  if (isCompleted) ...[
                    const SizedBox(width: 10),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.black,
                    ),
                  ],
                ],
              ),
              // Botão Iniciar etapa (somente se NOT_STARTED)
              if (isPending) ...[
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: PrimaryButton(
                    theme: theme,
                    width: 120,
                    height: 40,
                    buttonColor: canStart ? palette.raffle() : palette.grey(),
                    onPressed: canStart
                        ? () => _handleStartStepFromFormulary(formulary)
                        : null,
                    text: 'Iniciar etapa',
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToTaskReport(TaskFormularyEntity formulary) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TaskReportPage(
          taskId: widget.taskId,
          stepId: formulary.id ?? '',
          stepName: formulary.name,
          eventId: formulary.eventId,
        ),
      ),
    );
  }

  Widget _buildAttachmentsContent(ThemeData theme, ColorPallete palette) {
    final currentState = _bloc.state;
    if (currentState is! TaskDetailsLoadedState) {
      return const SizedBox.shrink();
    }

    final files = currentState.files;

    if (currentState.isLoadingFiles) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 24,
            mainAxisSpacing: 24,
            childAspectRatio: 162 / 210, // Aumentado para acomodar o nome
          ),
          itemCount: 3,
          itemBuilder: (context, index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade50,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          },
        ),
      );
    }

    if (files.isEmpty) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Nenhum anexo encontrado',
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.grey(),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 162 / 210, // Aumentado para acomodar o nome
        ),
        itemCount: files.length,
        itemBuilder: (context, index) {
          final file = files[index];
          return _buildFileItem(file, theme, palette);
        },
      ),
    );
  }

  Widget _buildFileItem(
    TaskFileEntity file,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final isImage = _isImageFile(file.extension);
    final isPdf = file.extension.toLowerCase() == 'pdf';
    final displayName = _extractFilenameFromUrl(file.url, file.filename);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FilePreviewPage(
              url: file.url,
              filename: displayName,
              extension: file.extension,
            ),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFF5F5F5),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: isImage
                    ? Image.network(
                        file.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFileIcon(file.extension, palette);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      )
                    : isPdf
                        ? _buildPdfThumbnail(file.url, palette)
                        : _buildFileIcon(file.extension, palette),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              displayName,
              style: LelloTextStyles.body(theme)?.copyWith(
                fontSize: 12,
                color: palette.grey(),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPdfThumbnail(String url, ColorPallete palette) {
    return Stack(
      children: [
        PdfViewer.uri(
          Uri.parse(url),
          params: PdfViewerParams(
            backgroundColor: const Color(0xFFF5F5F5),
            loadingBannerBuilder: (context, bytesDownloaded, totalBytes) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBannerBuilder: (context, error, stackTrace, documentRef) {
              return _buildFileIcon('pdf', palette);
            },
          ),
        ),
        // Overlay para indicar que é PDF
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.9),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.picture_as_pdf,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  'PDF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFileIcon(String extension, ColorPallete palette) {
    IconData icon;
    Color color;

    switch (extension.toLowerCase()) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = palette.grey();
    }

    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          icon,
          size: 64,
          color: color,
        ),
      ),
    );
  }

  bool _isImageFile(String extension) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  String _extractFilenameFromUrl(String url, String fallbackFilename) {
    // Se o filename não for '-', usa ele
    if (fallbackFilename != '-' && fallbackFilename.isNotEmpty) {
      return fallbackFilename;
    }

    // Tentar extrair da URL do Firebase Storage
    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;
      
      if (pathSegments.isNotEmpty) {
        // Pega o último segmento (nome do arquivo)
        var filename = pathSegments.last;
        
        // Decodifica URL encoding (%20, etc.)
        filename = Uri.decodeComponent(filename);
        
        // Remove query parameters se houver
        if (filename.contains('?')) {
          filename = filename.split('?').first;
        }
        
        return filename;
      }
    } catch (e) {
      // Se falhar, continua para o fallback
    }

    return 'Arquivo sem nome';
  }

  Widget _buildParentScheduleTooltip(
    TaskDetailsEntity task,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: palette.routineBlue(), // Azul #0058A0
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/ic_info_white.svg',
                width: 14,
                height: 14,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Esta ordem de serviço foi criada a partir de uma rotina.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () {
                final scheduleEventId = task.parentScheduleEvent?.id;
                if (scheduleEventId != null) {
                  Navigator.pushNamed(
                    context,
                    ApplicationRoute.maintenanceManagementTaskDetails,
                    arguments: scheduleEventId,
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Ver tarefa',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatWeekDays(List<String> days) {
    final dayMap = {
      'MO': 'Seg',
      'TU': 'Ter',
      'WE': 'Qua',
      'TH': 'Qui',
      'FR': 'Sex',
      'SA': 'Sáb',
      'SU': 'Dom',
    };

    return days.map((day) => dayMap[day.toUpperCase()] ?? day).join(', ');
  }
}
