import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import '../../../domain/entity/procedure_options_entity.dart';
import 'package:lello/core/navigation/application_route.dart';
import '../bloc/create_routine_bloc.dart';
import '../enums/task_creation_type.dart';

class CreateRoutinePage extends StatefulWidget {
  final TaskCreationType taskType;

  const CreateRoutinePage({
    super.key,
    this.taskType = TaskCreationType.routine,
  });

  @override
  State<CreateRoutinePage> createState() => _CreateRoutinePageState();
}

class _CreateRoutinePageState extends State<CreateRoutinePage> {
  late CreateRoutineBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ApplicationContainer.instance().resolve<CreateRoutineBloc>();

    // Resetar o BLoC para garantir estado limpo
    _bloc.add(ResetBlocEvent());

    // Aguardar um frame para garantir que o reset foi processado
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Carregar opções baseadas no tipo de tarefa
      _bloc.add(LoadProcedureOptionsEvent(widget.taskType.apiValue));
    });
  }

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: "",
          theme: theme,
          onBackArrowPressed: () => Navigator.pop(context),
        ),
        body: BlocBuilder<CreateRoutineBloc, CreateRoutineState>(
          builder: (context, state) {
            return Column(
              children: [
                // Header com título
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.taskType.title(context),
                      style: LelloTextStyles.headline(theme)?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: palette.text(),
                      ),
                    ),
                  ),
                ),

                // Conteúdo principal
                Expanded(
                  child: _buildContent(state, palette, theme),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BlocBuilder<CreateRoutineBloc, CreateRoutineState>(
          builder: (context, state) {
            return _buildBottomButtons(state, palette, theme);
          },
        ),
      ),
    );
  }

  Widget _buildContent(
      CreateRoutineState state, ColorPallete palette, ThemeData theme) {
    if (state is CreateRoutineLoadingState) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is CreateRoutineErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: palette.grey(),
            ),
            const SizedBox(height: 16),
            Text(
              "Erro ao carregar opções",
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: palette.text(),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.message,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.grey(),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (state is CreateRoutineLoadedState) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: state.procedureOptions.procedureOptions.length,
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final option = state.procedureOptions.procedureOptions[index];
            final isSelected = state.selectedOption?.id == option.id;

            return _buildRoutineOptionCard(
              option: option,
              isSelected: isSelected,
              onTap: () => _bloc.add(SelectProcedureOptionEvent(option)),
              palette: palette,
              theme: theme,
              taskType: widget.taskType,
            );
          },
        ),
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildRoutineOptionCard({
    required ProcedureOptionEntity option,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorPallete palette,
    required ThemeData theme,
    required TaskCreationType taskType,
  }) {
    final description = option.description?.trim() ?? "";
    final hasDescription = description.isNotEmpty;
    final imageUrl = option.urlImage.trim();
    final hasImage = imageUrl.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? palette.greyDarker() : palette.grey(),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Conteúdo
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: LelloTextStyles.bodyBold(theme)?.copyWith(
                      color: taskType.primaryColor(theme),
                      fontSize: 16,
                    ),
                  ),
                  if (hasDescription) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: taskType.primaryColor(theme),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Ilustração
            if (hasImage)
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox.shrink(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButtons(
      CreateRoutineState state, ColorPallete palette, ThemeData theme) {
    final hasSelection =
        state is CreateRoutineLoadedState && state.selectedOption != null;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Botão Voltar
          Expanded(
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
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

          const SizedBox(width: 16),

          // Botão Avançar
          Expanded(
            child: ElevatedButton(
              onPressed: hasSelection ? _onAdvancePressed : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    hasSelection ? palette.primary() : palette.grey(),
                foregroundColor:
                    hasSelection ? Colors.white : palette.textLight(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                elevation: 0,
              ),
              child: Text(
                "Avançar",
                style: LelloTextStyles.bodyBold(theme)?.copyWith(
                  color: hasSelection ? Colors.white : palette.textLight(),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _onAdvancePressed() async {
    final state = _bloc.state;
    if (state is CreateRoutineLoadedState && state.selectedOption != null) {
      await Navigator.pushNamed(
        context,
        ApplicationRoute.maintenanceManagementCreateRoutineDetail,
        arguments: (
          bloc: _bloc,
          taskType: widget.taskType,
          optionType: state.selectedOption!.titleKey ?? '',
        ),
      );
    }
  }
}
