import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/maintenance_management/domain/entity/task_details_entity.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/init_step/task_init_step_bloc.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/init_step/task_init_step_event.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/init_step/task_init_step_state.dart';

import 'widgets/init_step_discard_dialog.dart';
import 'widgets/question_widget_factory.dart';
import '../../components/task_init_step_reset_confirmation_modal.dart';

class TaskInitStepPage extends StatefulWidget {
  final String taskId;
  final TaskDetailsEntity task;
  final String eventId;

  const TaskInitStepPage({
    super.key,
    required this.taskId,
    required this.task,
    required this.eventId,
  });

  @override
  State<TaskInitStepPage> createState() => _TaskInitStepPageState();
}

class _TaskInitStepPageState extends State<TaskInitStepPage>
    with WidgetsBindingObserver {
  late final TaskInitStepBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<TaskInitStepBloc>();
    _bloc.initialize(widget.eventId, widget.task, widget.taskId);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    // Se há dados preenchidos quando a tela é destruída, chama reset
    _handlePageDestroyed();

    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    // Só chama reset quando o app for realmente finalizado/morto
    if (state == AppLifecycleState.detached) {
      _handleAppClose();
    }
  }

  void _handlePageDestroyed() {
    // Sempre chama reset quando a tela é destruída porque ao abrir já inicia sessão
    // que precisa ser resetada, independente de ter dados preenchidos
    final scheduleEventId = _bloc.state.task?.id;
    if (scheduleEventId != null &&
        scheduleEventId.isNotEmpty &&
        _bloc.state.outcome == null) {
      // Chama reset sem mostrar modal (silencioso)
      _bloc.add(const TaskInitStepConfirmResetEvent());
    }
  }

  void _handleAppClose() {
    // Sempre chama reset quando app é fechado porque sessão foi iniciada
    final scheduleEventId = _bloc.state.task?.id;
    if (scheduleEventId != null && scheduleEventId.isNotEmpty) {
      // Chama reset sem mostrar modal (silencioso)
      _bloc.add(const TaskInitStepConfirmResetEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocProvider<TaskInitStepBloc>(
      create: (_) => _bloc,
      child: BlocConsumer<TaskInitStepBloc, TaskInitStepState>(
        listener: (context, state) {
          // Handle outcomes
          if (state.outcome == TaskInitStepStatus.success) {
            _bloc.add(const TaskInitStepStatusClearedEvent());
            Navigator.of(context).pop(true); // Retorna true indicando sucesso
          } else if (state.outcome == TaskInitStepStatus.discarded) {
            _bloc.add(const TaskInitStepStatusClearedEvent());
            Navigator.of(context)
                .pop(false); // Retorna false indicando descarte
          } else if (state.outcome == TaskInitStepStatus.reset) {
            _bloc.add(const TaskInitStepStatusClearedEvent());
            // Reset bem-sucedido: volta para detalhes passando sinal de refresh
            Navigator.of(context)
                .pop({'reset_success': true, 'task_id': widget.taskId});
          } else if (state.outcome == TaskInitStepStatus.error) {
            _bloc.add(const TaskInitStepStatusClearedEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'Erro ao iniciar etapa'),
                backgroundColor: palette.error(),
              ),
            );
          }

          // Handle dialogs
          if (state.dialog == TaskInitStepDialogType.discard) {
            _showDiscardDialog(context);
          } else if (state.dialog == TaskInitStepDialogType.reset) {
            _showResetDialog(context);
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: false, // Impede pop automático
            onPopInvokedWithResult: (didPop, result) {
              if (!didPop) {
                // Dispara evento de voltar no BLoC
                _bloc.add(const TaskInitStepBackPressedEvent());
              }
            },
            child: Scaffold(
              backgroundColor: palette.background(),
              appBar: AppBar(
                title: Text('ABERTURA',
                    style: LelloTextStyles.subtitleBold(theme)),
                backgroundColor: palette.background(),
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // Dispara evento de voltar no BLoC
                    _bloc.add(const TaskInitStepBackPressedEvent());
                  },
                ),
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: state.isLoading
                          ? Center(
                              child: CircularProgressIndicator(
                                color: palette.primary(),
                              ),
                            )
                          : _buildContent(context, state, theme, palette),
                    ),
                    _buildFooter(context, state, theme, palette),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, TaskInitStepState state,
      ThemeData theme, ColorPallete palette) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildTaskInfo(state, theme, palette),
          const SizedBox(height: 16),
          _buildTaskTitle(state, theme, palette),
          const SizedBox(height: 8),
          // Renderizar questions dinamicamente
          ...state.questions.map((question) {
            final currentAnswer = state.answers[question.id];
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: QuestionWidgetFactory.create(
                question: question,
                currentAnswer: currentAnswer,
                onAnswerChanged: (answer) {
                  _bloc.add(TaskInitStepAnswerChangedEvent(
                    questionId: question.id,
                    answer: answer,
                  ));
                },
              ),
            );
          }).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTaskInfo(
      TaskInitStepState state, ThemeData theme, ColorPallete palette) {
    final task = state.task;

    // Formatar datas
    String dateText = '';
    if (task?.dtStart != null) {
      dateText = task!.dtStart!;
    }

    // Obter nome do responsável
    String responsibleText = task?.currentResponsibleName ??
        task?.procedureGroup?.name ??
        'Não definido';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dateText.isNotEmpty)
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 22,
                color: const Color(0xFF666666),
              ),
              const SizedBox(width: 8),
              Text(
                dateText,
                style: LelloTextStyles.body(theme)?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF666666),
                ),
              ),
            ],
          ),
        if (dateText.isNotEmpty) const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.person_outline,
              size: 16,
              color: const Color(0xFF666666),
            ),
            const SizedBox(width: 8),
            Text(
              responsibleText,
              style: LelloTextStyles.body(theme)?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF666666),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskTitle(
      TaskInitStepState state, ThemeData theme, ColorPallete palette) {
    final taskName = state.task?.name ?? 'Carregando...';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        taskName.toUpperCase(),
        style: LelloTextStyles.body(theme)?.copyWith(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF212121),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, TaskInitStepState state,
      ThemeData theme, ColorPallete palette) {
    final isEnabled = state.isFormValid && !state.isSubmitting;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        color: palette.background(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        height: 52,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isEnabled
              ? () => _bloc.add(const TaskInitStepSubmitPressedEvent())
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnabled ? const Color(0xFFC20332) : const Color(0xFFBEBEBE),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            elevation: 0,
          ),
          child: state.isSubmitting
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  'Concluir etapa',
                  style: LelloTextStyles.body(theme)?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFFFFFE),
                  ),
                ),
        ),
      ),
    );
  }

  void _showDiscardDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => InitStepDiscardDialog(
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          _bloc.add(const TaskInitStepConfirmDiscardEvent());
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          _bloc.add(const TaskInitStepDialogDismissedEvent());
        },
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => TaskInitStepResetConfirmationModal(
        onConfirm: () {
          Navigator.of(dialogContext).pop();
          _bloc.add(const TaskInitStepConfirmResetEvent());
        },
        onCancel: () {
          Navigator.of(dialogContext).pop();
          _bloc.add(const TaskInitStepDialogDismissedEvent());
        },
      ),
    );
  }
}
