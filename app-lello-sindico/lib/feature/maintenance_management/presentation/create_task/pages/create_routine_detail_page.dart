import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import '../../../domain/entity/procedure_options_entity.dart';
import '../../../domain/entity/create_task_entity.dart';
import '../bloc/create_routine_bloc.dart';
import '../widgets/scheduling_widget.dart';
import '../widgets/create_task_confirmation_modal.dart';
import '../widgets/create_task_error_modal.dart';
import '../enums/task_creation_type.dart';
import 'create_routine_success_page.dart';

enum ResponsibleType { team, employee }

enum ServiceOrderTargetType { local, asset }

enum SchedulingMode { routine, serviceOrder }

class CreateRoutineDetailPage extends StatefulWidget {
  final ProcedureOptionEntity selectedProcedure;
  final TaskCreationType taskType;
  final String optionType;
  final CreateRoutineBloc? bloc;

  const CreateRoutineDetailPage({
    super.key,
    required this.selectedProcedure,
    required this.taskType,
    required this.optionType,
    this.bloc,
  });

  @override
  State<CreateRoutineDetailPage> createState() =>
      _CreateRoutineDetailPageState();
}

class _CreateRoutineDetailPageState extends State<CreateRoutineDetailPage> {
  late CreateRoutineBloc _bloc;

  // Form state
  String? _selectedEquipment;
  String? _preSelectedResponsibleName;
  final ResponsibleType _selectedResponsibleType = ResponsibleType.team;
  SchedulingType? _selectedSchedulingType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  FrequencyType? _selectedFrequency;
  bool _isDayLong = false;
  bool _reminderEnabled = true;
  List<int> _selectedWeekDays = [];
  ServiceOrderTargetType _serviceOrderTarget = ServiceOrderTargetType.local;
  DateTime? _serviceOrderStartDate;

  bool get _isServiceOrder => widget.taskType == TaskCreationType.serviceOrder;

  String get _resolvedProcedureId {
    final procedureId = widget.selectedProcedure.procedureId?.trim();
    if (procedureId != null && procedureId.isNotEmpty) {
      return procedureId;
    }
    return widget.selectedProcedure.id.trim();
  }

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ??
        ApplicationContainer.instance().resolve<CreateRoutineBloc>();

    if (_isServiceOrder) {
      final now = DateTime.now();
      _serviceOrderStartDate = now;
    }

    if (widget.bloc == null) {
      _bloc.add(LoadFilterOptionsEvent());
    }
    _loadLookupData();

    _preSelectedResponsibleName =
        widget.selectedProcedure.firstResponsible?.name;
  }

  @override
  void dispose() {
    _bloc.add(ClearSelectionEvent());
    if (widget.bloc == null) {
      _bloc.close();
    }
    super.dispose();
  }

  bool get _isFormValid {
    if (_selectedEquipment == null) return false;

    if (_isServiceOrder) {
      if (_serviceOrderStartDate == null) {
        return false;
      }
      return true;
    }

    if (_selectedSchedulingType == null) return false;

    if (_selectedFrequency == null) return false;

    if (!_isDayLong && _selectedTime == null) return false;

    if (_selectedSchedulingType == SchedulingType.scheduleStart) {
      if (_selectedDate == null) return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<CreateRoutineBloc, CreateRoutineState>(
        listener: (context, state) {
          if (state is CreateRoutineTaskCreatedState) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => CreateRoutineSuccessPage(
                  routineTitle: widget.selectedProcedure.title,
                  taskType: widget.taskType,
                  idSchedule: state.response.idSchedule,
                  idScheduleEvents: state.response.idScheduleEvents,
                ),
              ),
              ModalRoute.withName(ApplicationRoute.maintenanceManagement),
            );
          } else if (state is CreateRoutineTaskCreationErrorState) {
            // Mostrar modal de erro
            CreateTaskErrorModal.show(
              context: context,
              theme: theme,
              palette: palette,
              onTryAgain: () {
                Navigator.of(context).pop(); // Fecha o modal
                // O usuário pode tentar novamente clicando em "Criar tarefa"
              },
            );
          }
        },
        child: Scaffold(
          appBar: PrimaryAppBar(
            title: _isServiceOrder ? "Criar ordem de serviço" : "Criar rotina",
            theme: theme,
            onBackArrowPressed: () => _showExitConfirmationDialog(context),
          ),
          body: BlocBuilder<CreateRoutineBloc, CreateRoutineState>(
            builder: (context, state) {
              if (state is CreateRoutineCreatingTaskState) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      SizedBox(height: Dimens.spacingLarge),
                      const Text('Criando tarefa...'),
                    ],
                  ),
                );
              } else if (state is CreateRoutineLoadedState) {
                return _buildContent(context, state);
              } else if (state is CreateRoutineLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else {
                return const Center(child: Text('Erro ao carregar dados'));
              }
            },
          ),
          bottomNavigationBar:
              BlocBuilder<CreateRoutineBloc, CreateRoutineState>(
            builder: (context, state) {
              if (state is CreateRoutineLoadedState) {
                return _buildBottomButtons(context, theme, palette);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildServiceOrderTargetSelector(
      ThemeData theme, ColorPallete palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Escolha onde a ordem de serviço será feita',
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: [
                Expanded(
                  child: _buildServiceOrderTargetButton(
                    theme: theme,
                    palette: palette,
                    label: 'Ambiente',
                    isSelected:
                        _serviceOrderTarget == ServiceOrderTargetType.local,
                    onTap: () {
                      _onServiceOrderTargetChanged(
                          ServiceOrderTargetType.local);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildServiceOrderTargetButton(
                    theme: theme,
                    palette: palette,
                    label: 'Equipamento',
                    isSelected:
                        _serviceOrderTarget == ServiceOrderTargetType.asset,
                    onTap: () {
                      _onServiceOrderTargetChanged(
                          ServiceOrderTargetType.asset);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceOrderTargetButton({
    required ThemeData theme,
    required ColorPallete palette,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: palette.text(),
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  void _onServiceOrderTargetChanged(ServiceOrderTargetType target) {
    if (_serviceOrderTarget == target) {
      return;
    }
    setState(() {
      _serviceOrderTarget = target;
      _selectedEquipment = null;
    });
    _loadLookupData();
  }

  Widget _buildServiceOrderSchedulingSection(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Agendamento',
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          _buildDatePickerField(
            context: context,
            theme: theme,
            palette: palette,
            label: 'Data de início',
            selectedDate: _serviceOrderStartDate,
            onDateSelected: (date) {
              setState(() {
                _serviceOrderStartDate = date;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required ThemeData theme,
    required ColorPallete palette,
    required String label,
    required ValueChanged<DateTime> onDateSelected,
    DateTime? selectedDate,
    DateTime? firstDate,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
              fontSize: 14,
            ),
          ),
        ),
        SizedBox(width: Dimens.spacingXSmall),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: firstDate ?? DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 365)),
                builder: (context, child) {
                  return Theme(
                    data: theme.copyWith(
                      colorScheme: theme.colorScheme.copyWith(
                        primary: palette.primary(),
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              if (picked != null) {
                onDateSelected(picked);
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border.all(color: palette.separator()),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: palette.textLight(),
                    size: 20,
                  ),
                  SizedBox(width: Dimens.spacingXSmall),
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? _formatDate(selectedDate)
                          : 'Selecione',
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: selectedDate != null
                            ? palette.text()
                            : palette.textLight(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context, CreateRoutineLoadedState state) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProcedureHeader(theme, palette),
          SizedBox(height: Dimens.spacingLarge),

          if (_isServiceOrder) ...[
            _buildServiceOrderTargetSelector(theme, palette),
            SizedBox(height: Dimens.spacingLarge),
          ],

          // Seção de locais - sempre visível (usando dados específicos do procedimento)
          _buildLocationOrAssetSection(state, theme, palette),

          // Seção de responsável - só aparece após selecionar local
          if (_selectedEquipment != null) ...[
            SizedBox(height: Dimens.spacingLarge),
            _buildResponsibleSection(theme, palette),
          ],

          // Seção de agendamento - só aparece após selecionar local (responsável já vem pré-selecionado)
          if (_selectedEquipment != null) ...[
            SizedBox(height: Dimens.spacingLarge),
            _isServiceOrder
                ? _buildServiceOrderSchedulingSection(context, theme, palette)
                : _buildSchedulingSection(theme, palette),
          ],

          SizedBox(height: Dimens.spacingLarge), // Space for bottom buttons
        ],
      ),
    );
  }

  // Método removido pois responsável agora vem pré-selecionado

  Widget _buildProcedureHeader(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Illustration
        Center(
          child: Container(
            height: 200,
            width: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.selectedProcedure.urlImage,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: palette.primary().withValues(alpha: 0.1),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: palette.grey(),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        SizedBox(height: Dimens.spacingLarge),

        // Title and description
        Text(
          widget.selectedProcedure.title,
          style: LelloTextStyles.headline(theme)?.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: palette.text(),
          ),
        ),

        SizedBox(height: Dimens.spacingXSmall),

        Text(
          widget.selectedProcedure.description ?? "",
          style: LelloTextStyles.body(theme)?.copyWith(
            color: palette.textLight(),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationOrAssetSection(
      CreateRoutineLoadedState state, ThemeData theme, ColorPallete palette) {
    final labelText = _shouldUseAssets
        ? (_isServiceOrder
            ? 'Especifique o equipamento da ordem de serviço'
            : 'Especifique o equipamento')
        : (_isServiceOrder
            ? 'Especifique o ambiente da ordem de serviço'
            : 'Especifique o ambiente');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: Dimens.spacingXSmall),
          _buildSelectionDropdown(state, theme, palette),
        ],
      ),
    );
  }

  Widget _buildSelectionDropdown(
      CreateRoutineLoadedState state, ThemeData theme, ColorPallete palette) {
    if (_shouldUseAssets) {
      final assets = state.assetsLookup?.assets ?? [];
      final hasReceivedResponse = state.assetsLookup != null;

      return _buildSearchableDropdown(
        theme: theme,
        palette: palette,
        items: assets.map((asset) {
          final label = asset.nameWithHierarchyLocals?.isNotEmpty == true
              ? asset.nameWithHierarchyLocals ?? ''
              : asset.name;
          return DropdownMenuItem<String>(
            value: asset.id,
            child: Text(
              label,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.text(),
              ),
            ),
          );
        }).toList(),
        placeholder: 'Selecione',
        isLoading: !hasReceivedResponse,
        emptyMessage: 'Nenhum equipamento encontrado',
      );
    }

    final locals = state.localsLookup?.locals ?? [];
    final hasReceivedResponse = state.localsLookup != null;

    return _buildSearchableLocalDropdown(
      theme: theme,
      palette: palette,
      items: locals
          .map((local) => DropdownMenuItem<String>(
                value: local.id,
                child: Text(
                  local.name,
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: palette.text(),
                  ),
                ),
              ))
          .toList(),
      placeholder: 'Selecione',
      isLoading: !hasReceivedResponse,
      emptyMessage: 'Nenhum ambiente encontrado',
    );
  }

  Widget _buildSearchableLocalDropdown({
    required ThemeData theme,
    required ColorPallete palette,
    required List<DropdownMenuItem<String>> items,
    required String placeholder,
    bool isLoading = false,
    String emptyMessage = 'Nenhum resultado encontrado',
  }) {
    final TextEditingController searchController = TextEditingController();

    // Mostrar carregando se ainda está buscando dados
    if (isLoading) {
      searchController.text = 'Carregando...';
    } else {
      // Encontrar o item selecionado
      String selectedText = '';
      if (_selectedEquipment != null) {
        final selectedItem =
            items.firstWhereOrNull((item) => item.value == _selectedEquipment);
        if (selectedItem != null) {
          selectedText = (selectedItem.child as Text).data ?? '';
          searchController.text = selectedText;
        }
      }
    }

    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              final result = await _showLocalSelectionBottomSheet(
                context: context,
                items: items,
                theme: theme,
                palette: palette,
                emptyMessage: emptyMessage,
              );

              if (result != null) {
                setState(() {
                  _selectedEquipment = result;
                  final selectedItem =
                      items.firstWhere((item) => item.value == result);
                  searchController.text =
                      (selectedItem.child as Text).data ?? '';
                });
              }
            },
      child: Opacity(
        opacity: isLoading ? 0.6 : 1.0,
        child: AbsorbPointer(
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: placeholder,
              suffixIcon:
                  Icon(Icons.arrow_drop_down_sharp, color: palette.textLight()),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.primary()),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchableDropdown({
    required ThemeData theme,
    required ColorPallete palette,
    required List<DropdownMenuItem<String>> items,
    required String placeholder,
    bool isLoading = false,
    String emptyMessage = 'Nenhum resultado encontrado',
  }) {
    final TextEditingController searchController = TextEditingController();

    // Mostrar carregando se ainda está buscando dados
    if (isLoading) {
      searchController.text = 'Carregando...';
    } else {
      // Encontrar o item selecionado
      String selectedText = '';
      if (_selectedEquipment != null) {
        final selectedItem =
            items.firstWhereOrNull((item) => item.value == _selectedEquipment);
        if (selectedItem != null) {
          selectedText = (selectedItem.child as Text).data ?? '';
          searchController.text = selectedText;
        }
      }
    }

    return GestureDetector(
      onTap: isLoading
          ? null
          : () async {
              final result = await _showEquipmentSelectionBottomSheet(
                context: context,
                items: items,
                theme: theme,
                palette: palette,
                emptyMessage: emptyMessage,
              );

              if (result != null) {
                setState(() {
                  _selectedEquipment = result;
                  final selectedItem =
                      items.firstWhere((item) => item.value == result);
                  searchController.text =
                      (selectedItem.child as Text).data ?? '';
                });
              }
            },
      child: Opacity(
        opacity: isLoading ? 0.6 : 1.0,
        child: AbsorbPointer(
          child: TextFormField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: placeholder,
              suffixIcon:
                  Icon(Icons.arrow_drop_down_sharp, color: palette.textLight()),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.primary()),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResponsibleSection(ThemeData theme, ColorPallete palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Responsável pela tarefa',
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),

          // Botões de seleção de tipo de responsável
          Row(
            children: [
              _buildResponsibleTypeButton(
                'Equipe',
                _selectedResponsibleType == ResponsibleType.team,
                null, // Não selecionável
                theme,
                palette,
              ),
              SizedBox(width: Dimens.spacingXSmall),
              _buildResponsibleTypeButton(
                'Funcionário',
                false, // Sempre não selecionado
                null, // Não selecionável
                theme,
                palette,
              ),
            ],
          ),
          SizedBox(height: Dimens.spacingMedium),

          // Campo de seleção baseado no tipo escolhido
          if (_selectedResponsibleType == ResponsibleType.team)
            _buildTeamSelectionField(theme, palette)
          else if (_selectedResponsibleType == ResponsibleType.employee)
            _buildEmployeeSelectionField(theme, palette),
        ],
      ),
    );
  }

  Widget _buildResponsibleTypeButton(
    String text,
    bool isSelected,
    VoidCallback? onTap,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.grey.shade400 : Colors.transparent,
        border: isSelected ? null : Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: LelloTextStyles.bodyBold(theme)?.copyWith(
          color: isSelected ? Colors.white : Colors.grey.shade400,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildTeamSelectionField(ThemeData theme, ColorPallete palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _preSelectedResponsibleName ?? 'Manutencistas',
        style: LelloTextStyles.body(theme)?.copyWith(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildEmployeeSelectionField(ThemeData theme, ColorPallete palette) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Selecionar funcionário',
        style: LelloTextStyles.body(theme)?.copyWith(
          color: Colors.grey.shade500,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildSchedulingSection(ThemeData theme, ColorPallete palette) {
    return SchedulingWidget(
      schedulingType: _selectedSchedulingType,
      selectedDate: _selectedDate,
      selectedTime: _selectedTime,
      selectedFrequency: _selectedFrequency,
      isDayLong: _isDayLong,
      reminderEnabled: _reminderEnabled,
      selectedWeekDays: _selectedWeekDays,
      onSchedulingTypeChanged: (type) {
        setState(() {
          _selectedSchedulingType = type;
        });
      },
      onDateChanged: (date) {
        setState(() {
          _selectedDate = date;
        });
      },
      onTimeChanged: (time) {
        setState(() {
          _selectedTime = time;
        });
      },
      onFrequencyChanged: (frequency) {
        setState(() {
          _selectedFrequency = frequency;
          // Clear week days when changing frequency
          if (frequency != FrequencyType.weekly) {
            _selectedWeekDays = [];
          }
        });
      },
      onDayLongChanged: (value) {
        setState(() {
          _isDayLong = value;
          if (value) {
            _selectedTime = null;
          }
        });
      },
      onReminderChanged: (value) {
        setState(() {
          _reminderEnabled = value;
        });
      },
      onWeekDaysChanged: (days) {
        setState(() {
          _selectedWeekDays = days;
        });
      },
      theme: theme,
      palette: palette,
    );
  }

  Widget _buildBottomButtons(
      BuildContext context, ThemeData theme, ColorPallete palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: palette.background(),
      child: Row(
        children: [
          // Voltar button
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                // Limpar seleção antes de voltar para garantir que a tela anterior funcione corretamente
                // _bloc.add(ClearSelectionEvent());
                Navigator.pop(context);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: palette.text()),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: Text(
                "Voltar",
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: palette.text(),
                  fontSize: 14,
                ),
              ),
            ),
          ),

          SizedBox(width: Dimens.spacingMedium),

          // Criar tarefa button
          Expanded(
            child: ElevatedButton(
              onPressed: _isFormValid
                  ? () => _showCreateTaskConfirmation(context)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _isFormValid ? palette.primary() : palette.grey(),
                foregroundColor:
                    _isFormValid ? Colors.white : palette.textLight(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: Text(
                "Criar tarefa",
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: _isFormValid ? Colors.white : palette.textLight(),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showExitConfirmationDialog(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sair da criação de tarefa?',
          style: LelloTextStyles.title(theme),
        ),
        content: Text(
          'Ao continuar, todas as alterações serão perdidas.',
          style: LelloTextStyles.body(theme),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: LelloTextStyles.button(theme)?.copyWith(
                color: palette.textLight(),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Limpar seleção antes de fechar a página
              // _bloc.add(ClearSelectionEvent());
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to previous screen
            },
            child: Text(
              'Sair',
              style: LelloTextStyles.button(theme)?.copyWith(
                color: palette.primary(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showCreateTaskConfirmation(BuildContext context) async {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    final confirmationLabel =
        _isServiceOrder ? 'ordem de serviço' : 'rotina preventiva';
    final summaryLabel =
        _isServiceOrder ? 'Ordem de serviço' : 'Tarefa de rotina preventiva';

    final confirmed = await CreateTaskConfirmationModal.show(
      context: context,
      taskTitle: widget.selectedProcedure.title,
      equipmentName: _getSelectedEquipmentName(),
      responsibleTeam: _getSelectedResponsibleName(),
      startDate: _isServiceOrder ? _serviceOrderStartDate : _getStartDate(),
      endDate: null,
      startTime: _isServiceOrder ? null : _getStartTime(),
      isDayLong: _isServiceOrder ? true : _isDayLong,
      frequency: _isServiceOrder ? null : _selectedFrequency,
      selectedWeekDays: _isServiceOrder ? null : _selectedWeekDays,
      description: null,
      confirmationLabel: confirmationLabel,
      summaryLabel: summaryLabel,
      theme: theme,
      palette: palette,
    );

    if (confirmed == true && mounted) {
      _createTask();
    }
  }

  String? _getSelectedEquipmentName() {
    // Buscar o nome do local selecionado na lista de locais
    final state = _bloc.state;
    if (state is CreateRoutineLoadedState && _selectedEquipment != null) {
      try {
        if (_shouldUseAssets) {
          final selectedAsset = state.assetsLookup?.assets.firstWhere(
            (asset) => asset.id == _selectedEquipment,
          );
          if (selectedAsset == null) {
            return 'Equipamento não encontrado';
          }
          return selectedAsset.nameWithHierarchyLocals?.isNotEmpty == true
              ? selectedAsset.nameWithHierarchyLocals ?? ''
              : selectedAsset.name;
        } else {
          final selectedLocal = state.localsLookup?.locals.firstWhere(
            (local) => local.id == _selectedEquipment,
          );
          return selectedLocal?.name ?? 'Local não encontrado';
        }
      } catch (e) {
        return _shouldUseAssets
            ? 'Equipamento não encontrado'
            : 'Local não encontrado';
      }
    }
    return null;
  }

  String? _getSelectedResponsibleName() {
    return _preSelectedResponsibleName;
  }

  DateTime? _getStartDate() {
    if (_selectedSchedulingType == SchedulingType.fromToday) {
      return DateTime.now();
    } else if (_selectedSchedulingType == SchedulingType.scheduleStart &&
        _selectedDate != null) {
      return _selectedDate;
    }
    return null;
  }

  TimeOfDay? _getStartTime() {
    if (!_isDayLong && _selectedTime != null) {
      return _selectedTime;
    }
    return null;
  }

  void _createTask() {
    if (!_isFormValid) return;

    final selectedEquipmentId = _selectedEquipment!;
    final procedureId = _resolvedProcedureId;

    // Criar a entidade de request
    final dtStartFormatted = _isServiceOrder
        ? _formatDate(_serviceOrderStartDate!)
        : _formatDate(_getStartDate()!);

    final request = CreateTaskRequestEntity(
      procedureGroupId: widget.selectedProcedure.procedureGroupId ?? '',
      procedureId: procedureId,
      localId: _shouldUseAssets ? null : selectedEquipmentId,
      assetId: _shouldUseAssets ? selectedEquipmentId : null,
      allDay: _isServiceOrder ? true : _isDayLong,
      dtStart: dtStartFormatted,
      timeStart: _isServiceOrder
          ? null
          : (!_isDayLong && _selectedTime != null
              ? _formatTime(_selectedTime!)
              : null),
      // repeat = true quando for ROTINA e tiver frequência selecionada
      repeat: !_isServiceOrder && _selectedFrequency != null,
      rrule: _isServiceOrder || _selectedFrequency == null
          ? null
          : RruleEntity(
              frequency: _getFrequencyString(_selectedFrequency!),
              byDays: _selectedFrequency == FrequencyType.weekly
                  ? _getWeekDaysStrings(_selectedWeekDays)
                  : null,
            ),
    );

    // Disparar evento no BLoC
    _bloc.add(CreateTaskEvent(request));
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  TimeOfDay _addHours(TimeOfDay time, int hours) {
    final totalMinutes = time.hour * 60 + time.minute + (hours * 60);
    final newHour = (totalMinutes ~/ 60) % 24;
    final newMinute = totalMinutes % 60;
    return TimeOfDay(hour: newHour, minute: newMinute);
  }

  String _getFrequencyString(FrequencyType frequency) {
    switch (frequency) {
      case FrequencyType.daily:
        return 'DAILY';
      case FrequencyType.weekly:
        return 'WEEKLY';
      case FrequencyType.monthly:
        return 'MONTHLY';
      case FrequencyType.yearly:
        return 'YEARLY';
    }
  }

  List<String>? _getWeekDaysStrings(List<int> weekDays) {
    if (weekDays.isEmpty) return null;

    const dayMap = {
      1: 'MO',
      2: 'TU',
      3: 'WE',
      4: 'TH',
      5: 'FR',
      6: 'SA',
      7: 'SU',
    };

    return weekDays.map((day) => dayMap[day]!).toList();
  }

  bool get _shouldUseAssets {
    if (_isServiceOrder) {
      return _serviceOrderTarget == ServiceOrderTargetType.asset;
    }
    return widget.optionType.toUpperCase() == 'VISTORIA_PREVENCAO';
  }

  void _loadLookupData() {
    final procedureId = _resolvedProcedureId;

    if (_shouldUseAssets) {
      _bloc.add(LoadAssetsLookupEvent(procedureId));
    } else {
      _bloc.add(LoadLocalsLookupEvent(procedureId));
    }
  }

  Future<String?> _showEquipmentSelectionBottomSheet({
    required BuildContext context,
    required List<DropdownMenuItem<String>> items,
    required ThemeData theme,
    required ColorPallete palette,
    String emptyMessage = 'Nenhum resultado encontrado',
  }) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        String searchQuery = ''; // Mover para fora do StatefulBuilder

        return StatefulBuilder(
          builder: (context, setState) {
            // Filtrar itens baseado na busca
            final filteredItems = items.where((item) {
              final text = (item.child as Text).data ?? '';
              return text.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Título
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Por Equipamento',
                            style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: palette.text(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: palette.textLight()),
                        ),
                      ],
                    ),
                  ),

                  // Campo de busca
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Pesquise por um equipamento',
                        prefixIcon:
                            Icon(Icons.search, color: palette.textLight()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: palette.primary()),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: palette.text(),
                      ),
                    ),
                  ),

                  // Lista de equipamentos
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: palette.textLight(),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  items.isEmpty
                                      ? emptyMessage
                                      : 'Nenhum equipamento encontrado para a busca',
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: palette.textLight(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final text = (item.child as Text).data ?? '';

                              return ListTile(
                                title: Text(
                                  text,
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: palette.text(),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop(item.value);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String?> _showLocalSelectionBottomSheet({
    required BuildContext context,
    required List<DropdownMenuItem<String>> items,
    required ThemeData theme,
    required ColorPallete palette,
    String emptyMessage = 'Nenhum resultado encontrado',
  }) async {
    return await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        String searchQuery = '';

        return StatefulBuilder(
          builder: (context, setState) {
            // Filtrar itens baseado na busca
            final filteredItems = items.where((item) {
              final text = (item.child as Text).data ?? '';
              return text.toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  // Handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),

                  // Título
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Por Ambiente',
                            style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: palette.text(),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close, color: palette.textLight()),
                        ),
                      ],
                    ),
                  ),

                  // Campo de busca
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Pesquise por um ambiente',
                        prefixIcon:
                            Icon(Icons.search, color: palette.textLight()),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: palette.primary()),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: palette.text(),
                      ),
                    ),
                  ),

                  // Lista de ambientes
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: palette.textLight(),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  items.isEmpty
                                      ? emptyMessage
                                      : (searchQuery.isEmpty
                                          ? 'Digite para buscar ambientes'
                                          : 'Nenhum ambiente encontrado para a busca'),
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: palette.textLight(),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: filteredItems.length,
                            itemBuilder: (context, index) {
                              final item = filteredItems[index];
                              final text = (item.child as Text).data ?? '';

                              return ListTile(
                                title: Text(
                                  text,
                                  style: LelloTextStyles.body(theme)?.copyWith(
                                    color: palette.text(),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop(item.value);
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

enum SchedulingType { fromToday, scheduleStart }

enum FrequencyType { daily, weekly, monthly, yearly }
