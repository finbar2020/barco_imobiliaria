import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../core/navigation/application_route.dart';
import '../../shared/utils/maintenance_reload_helper.dart';
import '../../../../../core/dependency/application_container.dart';
import '../enums/task_creation_type.dart';
import '../bloc/create_routine_bloc.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_details_entity.dart';

class CreateRoutineSuccessPage extends StatefulWidget {
  final String routineTitle;
  final TaskCreationType taskType;
  final String idSchedule;
  final List<String> idScheduleEvents;

  const CreateRoutineSuccessPage({
    super.key,
    required this.routineTitle,
    required this.taskType,
    required this.idSchedule,
    required this.idScheduleEvents,
  });

  @override
  State<CreateRoutineSuccessPage> createState() =>
      _CreateRoutineSuccessPageState();
}

class _CreateRoutineSuccessPageState extends State<CreateRoutineSuccessPage> {
  late final CreateRoutineBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<CreateRoutineBloc>();
  }

  @override
  void dispose() {
    // BLoC será gerenciado pelo ApplicationContainer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final isServiceOrder = widget.taskType == TaskCreationType.serviceOrder;

    final description = isServiceOrder
        ? 'A tarefa de ordem de serviço foi registrada. Agora complete a etapa de abertura da ordem de serviço para liberar aos funcionários.'
        : null;
    final primaryButtonLabel =
        isServiceOrder ? 'Iniciar etapa de abertura' : 'Ver detalhes da tarefa';

    return BlocProvider.value(
      value: _bloc,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) return;
          _goToHome(context);
        },
        child: Scaffold(
          backgroundColor: palette.background(),
          appBar: PrimaryAppBar(
            theme: theme,
            title: 'Criar tarefa',
            onBackArrowPressed: () => _goToHome(context),
          ),
          body: Column(
            children: [
              // Content area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Success icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: palette.success(),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Success title
                      Text(
                        'Tarefa criada com\nsucesso!',
                        style: LelloTextStyles.headline(theme)?.copyWith(
                          color: palette.text(),
                        ),
                        textAlign: TextAlign.center,
                      ),

                      if (description != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          description,
                          style: LelloTextStyles.body(theme)?.copyWith(
                            color: palette.text(),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Bottom buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Primary button (iniciar etapa para OS, abrir tarefa para rotina)
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        theme: theme,
                        onPressed: () =>
                            _handlePrimaryAction(context, isServiceOrder),
                        text: primaryButtonLabel,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Secondary button (sempre volta para home)
                    SizedBox(
                      width: double.infinity,
                      child: PrimaryButton(
                        theme: theme,
                        buttonColor: palette.secondary(),
                        onPressed: () => _goToHome(context),
                        text: 'Ir para página inicial',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePrimaryAction(BuildContext context, bool isServiceOrder) {
    if (isServiceOrder) {
      _handleStartStep(context);
    } else {
      _openTask(context);
    }
  }

  Future<void> _handleStartStep(BuildContext context) async {
    // Verifica se temos idSchedule para criar a task
    if (widget.idSchedule.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: scheduleId não encontrado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Verifica se temos idScheduleEvents
    if (widget.idScheduleEvents.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Não foi possível obter o ID da tarefa'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final scheduleEventId = widget.idScheduleEvents.first;

    // Disparar evento para criar task usando o BLoC
    _bloc.add(CreateTaskFromScheduleEvent(
      scheduleId: widget.idSchedule,
      scheduleEventId: scheduleEventId,
    ));

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

    // Aguardar a criação da task
    await for (final state in _bloc.stream) {
      if (state is CreateRoutineTaskFromScheduleCreatedState) {
        // Fechar loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }

        // Navegar para a tela de inicialização da etapa usando os dados
        // retornados pela API (taskName e currentResponsibleName)
        await _navigateToInitStep(
          context,
          state.taskId,
          state.eventId,
          state.taskName,
          state.currentResponsibleName,
        );
        break;
      } else if (state is CreateRoutineTaskFromScheduleErrorState) {
        // Fechar loading dialog
        if (context.mounted) {
          Navigator.of(context).pop();
        }

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
        break;
      }
    }
  }

  void _openTask(BuildContext context) {
    // Se idScheduleEvents não estiver vazio, usa o primeiro ID
    // Caso contrário, usa o idSchedule
    final taskId = widget.idScheduleEvents.isNotEmpty
        ? widget.idScheduleEvents.first
        : widget.idSchedule;

    if (taskId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: ID da tarefa não disponível'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.of(context).pushReplacementNamed(
      ApplicationRoute.maintenanceManagementTaskDetails,
      arguments: taskId,
    );
  }

  void _goToHome(BuildContext context) {
    // Recarrega os dados da semana atual
    MaintenanceReloadHelper.reloadCurrentWeek();

    // Volta até a MaintenanceManagementPage (home)
    Navigator.of(context).popUntil(
      (route) => route.settings.name == ApplicationRoute.maintenanceManagement,
    );
  }

  Future<void> _navigateToInitStep(
    BuildContext context,
    String taskId,
    String eventId,
    String taskName,
    String? currentResponsibleName,
  ) async {
    // Em alguns cenários a task recém-criada ainda não está disponível
    // pelo endpoint de detalhes (o backend pode demorar a propagar). Para
    // não bloquear a experiência do usuário, construímos aqui uma
    // entidade mínima `TaskDetailsEntity` usando os dados que já temos
    // (eventId, taskId, taskName e responsável da API) e navegamos direto
    // para a tela de inicialização de etapa.

    final isServiceOrder = widget.taskType == TaskCreationType.serviceOrder;

    // Construir uma TaskDetailsTaskEntity mínima com o id da task criada
    final minimalTaskEntity = TaskDetailsTaskEntity(
      id: taskId,
      currentResponsibleName: currentResponsibleName,
    );

    // Construir a TaskDetailsEntity mínima. Note: o campo `id` na
    // `TaskDetailsEntity` no app costuma representar o eventId (schedule
    // event), por isso atribuimos `eventId` a ele — isso mantém a lógica
    // usada pelo `TaskInitStepBloc` (que busca detalhes do evento).
    final minimalDetails = TaskDetailsEntity(
      id: eventId,
      name: taskName.isNotEmpty ? taskName : 'Tarefa',
      status: 'OPEN',
      typeTask: isServiceOrder ? 'ORDEM_SERVICO' : 'ROTINA',
      allDay: false,
      currentResponsibleName: currentResponsibleName,
      task: minimalTaskEntity,
    );

    if (context.mounted) {
      await Navigator.of(context).pushNamed(
        ApplicationRoute.maintenanceManagementTaskInitStep,
        arguments: {
          'taskId': taskId,
          'task': minimalDetails,
          'eventId': eventId,
        },
      );
    }
  }
}
