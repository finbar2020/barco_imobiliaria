import 'package:essentials/essentials.dart' hide Image, Switch;
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/task/pages/task_edit_success_page.dart';

import '../../../../../core/dependency/application_container.dart';
import '../../../domain/entity/task_details_entity.dart';
import '../../shared/widgets/info_box_widget.dart';
import '../../shared/widgets/week_day_selector_widget.dart';
import '../bloc/task_edit/task_edit_bloc.dart';
import '../bloc/task_edit/task_edit_event.dart';
import '../bloc/task_edit/task_edit_state.dart';

class TaskEditPage extends StatefulWidget {
  final TaskDetailsEntity task;

  const TaskEditPage({super.key, required this.task});

  @override
  State<TaskEditPage> createState() => _TaskEditPageState();
}

class _TaskEditPageState extends State<TaskEditPage> {
  late final TaskEditBloc _bloc;
  late final TextEditingController _orientationController;

  static const _checkInOptions = <String>[
    '06:00',
    '07:00',
    '08:00',
    '09:00',
    '10:00',
    '11:00',
    '12:00',
    '13:00',
    '14:00',
    '15:00',
    '16:00',
    '17:00',
    '18:00',
  ];

  final _weekDayOrder = const <TaskWeekDay>[
    TaskWeekDay.sunday,
    TaskWeekDay.monday,
    TaskWeekDay.tuesday,
    TaskWeekDay.wednesday,
    TaskWeekDay.thursday,
    TaskWeekDay.friday,
    TaskWeekDay.saturday,
  ];

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<TaskEditBloc>();
    _orientationController = TextEditingController();
    _bloc.initialize(widget.task);
  }

  @override
  void dispose() {
    _orientationController.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocProvider<TaskEditBloc>.value(
      value: _bloc,
      child: BlocConsumer<TaskEditBloc, TaskEditState>(
        listener: (context, state) async {
          if (_orientationController.text != state.orientation) {
            _orientationController
              ..text = state.orientation
              ..selection = TextSelection.fromPosition(
                TextPosition(offset: _orientationController.text.length),
              );
          }

          if (state.outcome != null && mounted) {
            if (state.outcome == TaskEditStatus.error) {
              // Mostrar snackbar de erro com mensagem específica
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ??
                        'Erro ao salvar as alterações. Tente novamente.',
                  ),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 4),
                ),
              );
              _bloc.add(const TaskEditStatusClearedEvent());
            } else if (state.outcome == TaskEditStatus.savedSingle) {
              // Mostrar tela de sucesso para edição de evento único
              final isServiceOrder = widget.task.typeTask == 'ORDEM_SERVICO';
              final shouldReload = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => TaskEditSuccessPage(
                    title: 'Tarefa editada com sucesso!',
                    description: isServiceOrder
                        ? null
                        : 'A tarefa selecionada foi editada da rotina. Nenhuma outra tarefa foi alterada.',
                    taskId: state.editedTaskId ??
                        widget.task.id, // Usa ID retornado pela API
                    isServiceOrder: isServiceOrder,
                  ),
                ),
              );
              _bloc.add(const TaskEditStatusClearedEvent());
              // Se retornou null (usuário foi para home), fecha a tela de edição também
              if (shouldReload == null && mounted) {
                Navigator.of(context).pop();
              }
              // Fecha a tela de edição e retorna o outcome apenas se usuário clicou em "Abrir tarefa"
              else if (shouldReload == true && mounted) {
                Navigator.of(context).pop(TaskEditStatus.savedSingle);
              }
            } else if (state.outcome == TaskEditStatus.savedFuture) {
              // Mostrar tela de sucesso para edição de eventos futuros
              final shouldReload = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (context) => TaskEditSuccessPage(
                    title: 'Todas as tarefas editadas com sucesso!',
                    description:
                        'Todas as tarefas a partir desta foram editadas da rotina. Esssa ação não afeta registros anteriores.',
                    taskId: state.editedTaskId ??
                        widget.task.id, // Usa ID retornado pela API
                    isServiceOrder: false,
                  ),
                ),
              );
              _bloc.add(const TaskEditStatusClearedEvent());
              // Se retornou null (usuário foi para home), fecha a tela de edição também
              if (shouldReload == null && mounted) {
                Navigator.of(context).pop();
              }
              // Fecha a tela de edição e retorna o outcome apenas se usuário clicou em "Abrir tarefa"
              else if (shouldReload == true && mounted) {
                Navigator.of(context).pop(TaskEditStatus.savedFuture);
              }
            } else {
              Navigator.of(context).pop(state.outcome);
            }
          }
        },
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) return;
              _handleBackPressed(state);
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: PrimaryAppBar(
                title: 'Editar tarefa',
                theme: theme,
                onBackArrowPressed: () => _handleBackPressed(state),
              ),
              body: SafeArea(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 24,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (widget.task.typeTask !=
                                    'ORDEM_SERVICO') ...[
                                  _buildTaskTitle(state, theme, palette),
                                  const SizedBox(height: 24),
                                  // Botões de seleção de scope (THIS vs NEXT)
                                  _buildScopeSelectionButtons(state, palette),
                                  // Info box explicativo (aparece após selecionar)
                                  if (state.pendingScope != null) ...[
                                    const SizedBox(height: 24),
                                    _buildScopeInfoBox(state, palette),
                                  ],
                                  const SizedBox(height: 24),
                                ],
                                // Card de agendamento (só aparece se scope foi selecionado)
                                if (state.pendingScope != null ||
                                    widget.task.typeTask == 'ORDEM_SERVICO')
                                  _buildScheduleCard(state, theme, palette),
                              ],
                            ),
                          ),
                        ),
                        _buildFooter(state, theme, palette),
                      ],
                    ),
                    if (state.dialog != TaskEditDialogType.none)
                      _buildDialogOverlay(state, theme, palette),
                    if (state.isSaving) const _TaskEditSavingOverlay(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleBackPressed(TaskEditState state) {
    if (_hasUnsavedChanges(state)) {
      _bloc.add(const TaskEditDiscardPressedEvent());
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _hasUnsavedChanges(TaskEditState state) {
    // Verifica se há alterações não salvas comparando com o estado inicial
    final task = widget.task;
    final schedule = task.schedule;
    final isServiceOrder = task.typeTask == 'ORDEM_SERVICO';

    // Para ordem de serviço, verifica mudanças na data de início
    if (isServiceOrder) {
      final originalStartDate = task.dtStart;

      if (state.startDate != null && state.startDate != originalStartDate) {
        return true;
      }

      return false;
    }

    // Para rotinas, verifica mudanças no agendamento

    // Se scope for THIS (current), verifica apenas mudança na data
    if (state.pendingScope == TaskEditScope.current) {
      final originalStartDate = task.dtStart;
      if (state.startDate != null && state.startDate != originalStartDate) {
        return true;
      }
      return false;
    }

    // Valor original do "Dia inteiro" (mesma lógica do BLoC)
    final originalIsAllDay = schedule?.allDay ?? task.allDay;

    // Verifica mudanças no switch "Dia inteiro"
    if (state.isAllDay != originalIsAllDay) return true;

    // Valor original do horário de check-in
    final originalCheckInTime = schedule?.timeStart ?? task.timeStart;

    // Verifica mudanças no horário de check-in
    if (!state.isAllDay && state.checkInTime != originalCheckInTime)
      return true;

    // Verifica mudanças na frequência (mode)
    final originalMode = _getOriginalMode(task);
    if (state.mode != originalMode) return true;

    // Verifica mudanças nos dias da semana
    if (state.mode == TaskScheduleMode.weekly) {
      final originalDays = task.rRule?.byDays?.toSet() ?? {};
      final currentDays =
          state.selectedWeekDays.map((d) => _weekDayToString(d)).toSet();
      if (!_setsEqual(originalDays, currentDays)) return true;
    }

    // Verifica mudanças no lembrete
    if (state.reminder != '1 dia antes') return true;

    return false;
  }

  bool _setsEqual<T>(Set<T> set1, Set<T> set2) {
    if (set1.length != set2.length) return false;
    return set1.containsAll(set2);
  }

  TaskScheduleMode _getOriginalMode(TaskDetailsEntity task) {
    final frequency = task.rRule?.frequency;
    if (frequency == null) return TaskScheduleMode.daily;

    switch (frequency.toUpperCase()) {
      case 'DAILY':
        return TaskScheduleMode.daily;
      case 'WEEKLY':
        return TaskScheduleMode.weekly;
      case 'MONTHLY':
        return TaskScheduleMode.monthly;
      case 'YEARLY':
        return TaskScheduleMode.yearly;
      default:
        return TaskScheduleMode.daily;
    }
  }

  String _weekDayToString(TaskWeekDay day) {
    switch (day) {
      case TaskWeekDay.sunday:
        return 'SU';
      case TaskWeekDay.monday:
        return 'MO';
      case TaskWeekDay.tuesday:
        return 'TU';
      case TaskWeekDay.wednesday:
        return 'WE';
      case TaskWeekDay.thursday:
        return 'TH';
      case TaskWeekDay.friday:
        return 'FR';
      case TaskWeekDay.saturday:
        return 'SA';
    }
  }

  Widget _buildScheduleCard(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final isServiceOrder = widget.task.typeTask == 'ORDEM_SERVICO';

    if (isServiceOrder) {
      return _buildServiceOrderScheduleCard(state, theme, palette);
    }

    // Se scope for THIS (current), mostra apenas campo de data
    if (state.pendingScope == TaskEditScope.current) {
      return _buildCurrentTaskEditCard(state, theme, palette);
    }

    // Se scope for NEXT (fromThis), mostra campos completos de agendamento
    final checkInValue =
        _checkInOptions.contains(state.checkInTime) ? state.checkInTime : null;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getScheduleCardTitle(state),
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          _buildAllDaySwitch(state, theme, palette),
          const SizedBox(height: 16),
          Divider(color: palette.separator(), height: 1),
          const SizedBox(height: 16),
          if (!state.isAllDay) ...[
            _buildCheckInDropdown(state, theme, palette, checkInValue),
            const SizedBox(height: 16),
          ],
          // Campo de frequência (sempre visível para rotinas)
          _buildFrequencyDisplay(state, theme, palette),
          if (state.mode == TaskScheduleMode.weekly) ...[
            const SizedBox(height: 16),
            _buildWeekDaySelector(state, theme, palette),
            const SizedBox(height: 16),
            Divider(color: palette.separator(), height: 1),
            const SizedBox(height: 16),
          ],
          if (state.mode == TaskScheduleMode.monthly) ...[
            const SizedBox(height: 16),
            _buildFrequencyInfoMessage(_getMonthlyMessage(state), palette),
            const SizedBox(height: 16),
            Divider(color: palette.separator(), height: 1),
            const SizedBox(height: 16),
          ],
          if (state.mode == TaskScheduleMode.yearly) ...[
            const SizedBox(height: 16),
            _buildFrequencyInfoMessage(_getYearlyMessage(state), palette),
          ],
        ],
      ),
    );
  }

  Widget _buildCurrentTaskEditCard(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: palette.greyCard(),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Editar tarefa atual',
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Color(0xFFE0E0E0), height: 1),
          const SizedBox(height: 24),
          _buildDateField(
            label: 'Data',
            value: state.startDate ?? state.task.dtStart ?? '21/10/2025',
            theme: theme,
            palette: palette,
            isStartDate: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOrderScheduleCard(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'Agendamento',
              style: LelloTextStyles.body(theme)?.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildDateField(
            label: 'Data de ínicio',
            value: state.startDate ?? state.task.dtStart ?? '02/08/2024',
            theme: theme,
            palette: palette,
            isStartDate: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required String value,
    required ThemeData theme,
    required ColorPallete palette,
    required bool isStartDate,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: LelloTextStyles.body(theme)?.copyWith(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        GestureDetector(
          onTap: () async {
            // Garante que initialDate não seja anterior a firstDate
            final parsedDate = _parseDate(value);
            final now = DateTime.now();
            final initialDate = (parsedDate != null && parsedDate.isAfter(now))
                ? parsedDate
                : now;

            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: now, // Bloqueia seleção de datas passadas
              lastDate: DateTime(2030),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: palette.primary(),
                      onPrimary: Colors.white,
                      onSurface: palette.text(),
                    ),
                  ),
                  child: child!,
                );
              },
            );

            if (picked != null) {
              final formattedDate = _formatDate(picked);
              if (isStartDate) {
                _bloc.add(TaskEditStartDateChangedEvent(formattedDate));
              }
            }
          },
          child: Container(
            width: 202,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: palette.textOpaque(),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: palette.text(),
                ),
                const SizedBox(width: 10),
                Text(
                  value,
                  style: LelloTextStyles.body(theme)?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: palette.text(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  DateTime? _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        return DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Widget _buildTaskTitle(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        state.task.name.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: palette.text(),
        ),
      ),
    );
  }

  Widget _buildScopeSelectionButtons(
    TaskEditState state,
    ColorPallete palette,
  ) {
    return Row(
      children: [
        Expanded(
          child: _buildScopeButton(
            TaskEditScope.current,
            state.pendingScope == TaskEditScope.current,
            palette,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildScopeButton(
            TaskEditScope.fromThis,
            state.pendingScope == TaskEditScope.fromThis,
            palette,
          ),
        ),
      ],
    );
  }

  Widget _buildScopeButton(
    TaskEditScope scope,
    bool isSelected,
    ColorPallete palette,
  ) {
    return InkWell(
      onTap: () => _bloc.add(TaskEditScopeSelectedEvent(scope)),
      child: Container(
        height: 35,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isSelected ? palette.primary() : Colors.white,
          border: Border.all(
            color: isSelected ? palette.primary() : palette.separator(),
          ),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Center(
          child: Text(
            scope.displayTitle,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : palette.text(),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildScopeInfoBox(
    TaskEditState state,
    ColorPallete palette,
  ) {
    final scope = state.pendingScope!;
    final description = scope == TaskEditScope.current
        ? 'Edite apenas a tarefa atual, sem mudar a frequência da rotina.'
        : 'Edite o agendamento desta rotina a partir da data desta tarefa.';

    return InfoBoxWidget(message: description);
  }

  String _getScheduleCardTitle(TaskEditState state) {
    if (state.pendingScope == null) {
      return 'Edite o agendamento';
    }

    return state.pendingScope == TaskEditScope.current
        ? 'Editar tarefa atual'
        : 'Edite o agendamento a partir desta tarefa';
  }

  Widget _buildAllDaySwitch(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dia inteiro',
          style: LelloTextStyles.body(theme)?.copyWith(
            color: palette.text(),
            fontSize: 16,
          ),
        ),
        Switch(
          value: state.isAllDay,
          onChanged: (value) => _bloc.add(TaskEditToggleAllDayEvent(value)),
          activeColor: palette.primary(),
        ),
      ],
    );
  }

  Widget _buildCheckInDropdown(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
    String? checkInValue,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Horário do check-in',
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DropdownButtonFormField<String>(
            value: checkInValue,
            icon: const SizedBox.shrink(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.primary()),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.access_time,
                color: palette.textLight(),
                size: 15,
              ),
            ),
            hint: Text(
              'Selecione',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.textLight(),
              ),
            ),
            items: _checkInOptions
                .map((time) => DropdownMenuItem<String>(
                      value: time,
                      child: Text(
                        time,
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: palette.text(),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (value) => _bloc.add(TaskEditCheckInChangedEvent(value)),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyDisplay(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Frequência',
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DropdownButtonFormField<TaskScheduleMode>(
            value: state.mode,
            icon: const SizedBox.shrink(),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.primary()),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.repeat,
                color: palette.textLight(),
                size: 20,
              ),
            ),
            items: TaskScheduleMode.values
                .map((mode) => DropdownMenuItem<TaskScheduleMode>(
                      value: mode,
                      child: Text(
                        _getFrequencyLabel(mode),
                        style: LelloTextStyles.body(theme)?.copyWith(
                          color: palette.text(),
                        ),
                      ),
                    ))
                .toList(),
            onChanged: (TaskScheduleMode? newMode) {
              if (newMode != null) {
                _bloc.add(TaskEditModeChangedEvent(newMode));
              }
            },
          ),
        ),
      ],
    );
  }

  String _getFrequencyLabel(TaskScheduleMode mode) {
    switch (mode) {
      case TaskScheduleMode.daily:
        return 'Diária';
      case TaskScheduleMode.weekly:
        return 'Semanal';
      case TaskScheduleMode.monthly:
        return 'Mensal';
      case TaskScheduleMode.yearly:
        return 'Anual';
    }
  }

  String _getMonthlyMessage(TaskEditState state) {
    // Usa a data de início da tarefa se disponível, senão usa data atual
    final dateStr = state.startDate ?? state.task.dtStart;
    if (dateStr != null) {
      try {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          if (day != null) {
            return 'Esta rotina será programada todo dia $day.';
          }
        }
      } catch (_) {}
    }
    final now = DateTime.now();
    return 'Esta rotina será programada todo dia ${now.day}.';
  }

  String _getYearlyMessage(TaskEditState state) {
    final months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];

    // Usa a data de início da tarefa se disponível, senão usa data atual
    final dateStr = state.startDate ?? state.task.dtStart;
    if (dateStr != null) {
      try {
        final parts = dateStr.split('/');
        if (parts.length == 3) {
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          if (day != null && month != null && month >= 1 && month <= 12) {
            final monthName = months[month - 1];
            return 'Esta rotina será programada todo dia $day do mês de $monthName.';
          }
        }
      } catch (_) {}
    }

    final now = DateTime.now();
    final monthName = months[now.month - 1];
    return 'Esta rotina será programada todo dia ${now.day} do mês de $monthName.';
  }

  Widget _buildFrequencyInfoMessage(String message, ColorPallete palette) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info,
            color: Colors.red.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: palette.grey(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekDaySelector(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    // Converte TaskWeekDay para índices int (0-6)
    final selectedDayIndices = state.selectedWeekDays.map((day) {
      return _weekDayOrder.indexOf(day);
    }).toList();

    return WeekDaySelectorWidget(
      selectedDays: selectedDayIndices,
      onDayToggled: (dayIndex) {
        final day = _weekDayOrder[dayIndex];
        _bloc.add(TaskEditWeekDayToggledEvent(day));
      },
      theme: theme,
      palette: palette,
      title: 'Edite os dias da semana:',
    );
  }

  Widget _buildFooter(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final canSave = _canSave(state);

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InvertedPrimaryButton(
              text: 'Descartar edição',
              onPressed: () => _bloc.add(const TaskEditDiscardPressedEvent()),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: PrimaryButton(
              text: 'Salvar',
              onPressed: canSave ? () => _handleSave(state) : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogOverlay(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Positioned.fill(
      child: Container(
        color: Colors.black45,
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 360),
          child: Material(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: state.dialog == TaskEditDialogType.scope
                  ? (widget.task.typeTask == 'ORDEM_SERVICO'
                      ? _buildServiceOrderScopeDialogContent(theme, palette)
                      : _buildScopeDialogContent(state, theme, palette))
                  : _buildDiscardDialogContent(theme, palette),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceOrderScopeDialogContent(
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Você optou por editar essa tarefa.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Anek Latin',
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: palette.text(),
            height: 1.0,
          ),
        ),
        const SizedBox(height: 19),
        Text(
          'Deseja continuar?',
          textAlign: TextAlign.center,
          style: LelloTextStyles.body(theme)?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.black,
            height: 1.22,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: PrimaryButton(
                  text: 'Sim, confirmar edição',
                  onPressed: () => _bloc.add(const TaskEditConfirmScopeEvent()),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: InvertedPrimaryButton(
                  text: 'Não, voltar para edição de rotinas',
                  onPressed: () => _bloc.add(const TaskEditDialogDismissedEvent()),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScopeDialogContent(
    TaskEditState state,
    ThemeData theme,
    ColorPallete palette,
  ) {
    final selectedScope = state.pendingScope ?? TaskEditScope.current;

    // Título principal baseado no scope
    final mainTitle = selectedScope == TaskEditScope.current
        ? 'Você optou por editar apenas a tarefa atual.'
        : 'Você optou por editar o agendamento a partir desta tarefa.';

    // Monta descrição do novo agendamento
    final scheduleDescription = _buildScheduleDescription(state);

    // Mensagem do info box baseado no scope
    final infoBoxMessage = selectedScope == TaskEditScope.current
        ? 'Essa edição só é válida para a tarefa atual.'
        : 'Use para ajustar a frequência das próximas tarefas.';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Título principal (Anek Latin Light 32px)
        Text(
          mainTitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Anek Latin',
            fontSize: 32,
            fontWeight: FontWeight.w300,
            color: palette.text(),
            height: 1.0,
          ),
        ),
        const SizedBox(height: 19),

        // Descrição do agendamento (Roboto Bold 18px)
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.black,
              height: 1.22,
            ),
            children: [
              TextSpan(text: scheduleDescription),
              const TextSpan(text: '\n'),
              const TextSpan(text: 'Deseja continuar?'),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Info box azul (aparece para ambos os scopes)
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: palette.textAccent().withOpacity(0.3),
            border: Border.all(color: palette.textAccent()),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: palette.textAccent(),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  infoBoxMessage,
                  style: TextStyle(
                    fontFamily: 'Anek Latin',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: palette.text(),
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Botões
        Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              PrimaryButton(
                text: 'Sim, confirmar edição',
                onPressed: () => _bloc.add(const TaskEditConfirmScopeEvent()),
              ),
              const SizedBox(height: 10),
              InvertedPrimaryButton(
                text: 'Não, voltar para edição',
                onPressed: () => _bloc.add(const TaskEditDialogDismissedEvent()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _buildScheduleDescription(TaskEditState state) {
    final selectedScope = state.pendingScope ?? TaskEditScope.current;

    // Para scope "current", mostra apenas a nova data
    if (selectedScope == TaskEditScope.current) {
      final dateStr = state.startDate ?? state.task.dtStart;
      if (dateStr != null && dateStr.isNotEmpty) {
        return 'Nova data: $dateStr.';
      }
      return 'Nova data da tarefa.';
    }

    // Para scope "fromThis", mostra a frequência
    final mode = state.mode;

    switch (mode) {
      case TaskScheduleMode.daily:
        return 'Novo agendamento: diariamente.';

      case TaskScheduleMode.weekly:
        if (state.selectedWeekDays.isEmpty) {
          return 'Novo agendamento: semanalmente.';
        }

        final weekDayLabels = {
          TaskWeekDay.sunday: 'dom',
          TaskWeekDay.monday: 'seg',
          TaskWeekDay.tuesday: 'ter',
          TaskWeekDay.wednesday: 'qua',
          TaskWeekDay.thursday: 'qui',
          TaskWeekDay.friday: 'sex',
          TaskWeekDay.saturday: 'sáb',
        };

        final sortedDays = state.selectedWeekDays.toList()
          ..sort((a, b) => a.index.compareTo(b.index));

        final daysText =
            sortedDays.map((day) => weekDayLabels[day] ?? '').join(', ');

        return 'Novo agendamento: semanalmente às $daysText.';

      case TaskScheduleMode.monthly:
        final dateStr = state.startDate ?? state.task.dtStart;
        if (dateStr != null) {
          try {
            final parts = dateStr.split('/');
            if (parts.length == 3) {
              final day = int.tryParse(parts[0]);
              if (day != null) {
                return 'Novo agendamento: mensalmente no dia $day.';
              }
            }
          } catch (_) {}
        }
        return 'Novo agendamento: mensalmente.';

      case TaskScheduleMode.yearly:
        final dateStr = state.startDate ?? state.task.dtStart;
        if (dateStr != null) {
          try {
            final parts = dateStr.split('/');
            if (parts.length == 3) {
              final day = int.tryParse(parts[0]);
              final month = int.tryParse(parts[1]);
              if (day != null && month != null && month >= 1 && month <= 12) {
                final months = [
                  'janeiro',
                  'fevereiro',
                  'março',
                  'abril',
                  'maio',
                  'junho',
                  'julho',
                  'agosto',
                  'setembro',
                  'outubro',
                  'novembro',
                  'dezembro'
                ];
                final monthName = months[month - 1];
                return 'Novo agendamento: anualmente no dia $day de $monthName.';
              }
            }
          } catch (_) {}
        }
        return 'Novo agendamento: anualmente.';
    }
  }

  Widget _buildDiscardDialogContent(
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Suas alterações não serão salvas.',
          textAlign: TextAlign.center,
          style: LelloTextStyles.body(theme)?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Deseja continuar?',
          textAlign: TextAlign.center,
          style: LelloTextStyles.body(theme)?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 24),
        PrimaryButton(
          text: 'Sim, descartar edições',
          onPressed: () => _bloc.add(const TaskEditConfirmDiscardEvent()),
        ),
        const SizedBox(height: 12),
        InvertedPrimaryButton(
          text: 'Não, voltar para edição de rotinas',
          onPressed: () => _bloc.add(const TaskEditDialogDismissedEvent()),
        ),
      ],
    );
  }

  void _handleSave(TaskEditState state) {
    // Dispara evento de salvar
    _bloc.add(const TaskEditSavePressedEvent());
  }

  bool _canSave(TaskEditState state) {
    final task = widget.task;
    final isServiceOrder = task.typeTask == 'ORDEM_SERVICO';

    // Para rotinas, exige seleção de scope
    if (!isServiceOrder && state.pendingScope == null) {
      return false;
    }

    // Verifica se há alterações não salvas
    if (!_hasUnsavedChanges(state)) {
      return false;
    }

    // Valida campos obrigatórios apenas se não for "Dia inteiro"
    if (!state.isAllDay &&
        (state.checkInTime == null || state.checkInTime!.isEmpty)) {
      return false;
    }

    // Valida dias da semana apenas se for modo semanal E tiver dias originalmente
    // (não bloqueia se usuário apenas mudou isAllDay)
    final hadWeekDays = task.rRule?.byDays?.isNotEmpty ?? false;
    if (state.mode == TaskScheduleMode.weekly &&
        hadWeekDays &&
        state.selectedWeekDays.isEmpty) {
      return false;
    }

    return true;
  }
}

class _TaskEditSavingOverlay extends StatelessWidget {
  const _TaskEditSavingOverlay();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black26,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
