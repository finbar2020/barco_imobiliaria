import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_summary/task_summary_model.dart';

import '../../../domain/entity/filter_options_entity.dart';
import '../widgets/filters/asset_bottom_sheet.dart';
import '../widgets/filters/employee_group_bottom_sheet.dart';
import '../widgets/filters/environment_bottom_sheet.dart';
import '../widgets/filters/responsible_bottom_sheet.dart';

// Helper classes for filter data
class FilterStatus {
  final String name;
  final Color color;

  const FilterStatus({required this.name, required this.color});
}

class ResponsiblePerson {
  final String name;
  final String role;
  final Color avatarColor;

  const ResponsiblePerson({
    required this.name,
    required this.role,
    required this.avatarColor,
  });
}

class MaintenanceManagementFiltersPage extends StatefulWidget {
  final FilterOptionsEntity? filterOptions;
  final FilterOptionsEntity? appliedFilters;

  const MaintenanceManagementFiltersPage({
    super.key,
    this.filterOptions,
    this.appliedFilters,
  });

  @override
  State<MaintenanceManagementFiltersPage> createState() =>
      _MaintenanceManagementFiltersPageState();
}

class _MaintenanceManagementFiltersPageState
    extends State<MaintenanceManagementFiltersPage> {
  // Filter state variables
  final Set<TaskType> selectedTaskTypes = {};
  final Set<TaskStatusType> selectedStatuses = {};
  final Set<FilterLocalEntity> selectedEnvironments = {};
  final Set<FilterAssetEntity> selectedEquipment = {};
  final Set<FilterEmployeeGroupEntity> selectedEmployeeGroups = {};
  final Set<FilterResponsibleEntity> selectedResponsible = {};

  bool _hasUnsavedChanges = false;
  bool _filtersWereCleared = false;

  bool get _hasActiveFilters {
    return selectedTaskTypes.isNotEmpty ||
        selectedStatuses.isNotEmpty ||
        selectedEnvironments.isNotEmpty ||
        selectedEquipment.isNotEmpty ||
        selectedEmployeeGroups.isNotEmpty ||
        selectedResponsible.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.appliedFilters != null) {
        _initializeFiltersFromAppliedData();
      }
    });
  }

  void _initializeFiltersFromAppliedData() {
    if (widget.appliedFilters != null) {
      final filters = widget.appliedFilters!;

      // Initialize task types
      selectedTaskTypes.addAll(filters.taskType);

      // Initialize task statuses
      selectedStatuses.addAll(filters.taskStatus);

      // Initialize environments/locals
      selectedEnvironments.addAll(filters.locals);

      // Initialize equipment/assets
      selectedEquipment.addAll(filters.assets);

      // Initialize employee groups
      selectedEmployeeGroups.addAll(filters.employeeGroup);

      // Initialize responsibles
      selectedResponsible.addAll(filters.responsibles);

      setState(() {
        _hasUnsavedChanges = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    // Filter options are now loaded from initialFilters entity

    return Scaffold(
      backgroundColor: palette.background(),
      appBar: _buildAppBar(theme, palette),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTaskTypeSection(theme, palette),
            const SizedBox(height: 24),
            _buildStatusSection(theme, palette),
            const SizedBox(height: 24),
            _buildEnvironmentSection(theme, palette),
            const SizedBox(height: 24),
            _buildEquipmentSection(theme, palette),
            const SizedBox(height: 24),
            _buildEmployeeGroupSection(theme, palette),
            const SizedBox(height: 24),
            _buildResponsibleSection(theme, palette),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButton(theme, palette),
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme, ColorPallete palette) {
    return AppBar(
      backgroundColor: palette.background(),
      elevation: 0,
      leading: IconButton(
        onPressed: () => _handleBackNavigation(),
        icon: Icon(
          Icons.arrow_back,
          color: palette.text(),
        ),
      ),
      title: Text(
        'Filtro',
        style: LelloTextStyles.title(theme)?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: _buildClearFilterButton(theme, palette),
        ),
      ],
    );
  }

  Widget _buildTaskTypeSection(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por tipo de tarefa',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskType.values.map((taskType) {
            final isSelected = selectedTaskTypes.contains(taskType);
            return _buildFilterChip(
              label: taskType.name(context),
              isSelected: isSelected,
              color: taskType == TaskType.routine
                  ? const Color(0xFF2F80ED)
                  : palette.primary(),
              onTap: () => _toggleTaskType(taskType),
              theme: theme,
              palette: palette,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildStatusSection(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por status',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TaskStatusType.values.map((status) {
            final isSelected = selectedStatuses.contains(status);
            return _buildFilterChip(
              label: status.name(context),
              isSelected: isSelected,
              color: status.color(theme),
              onTap: () => _toggleStatus(status),
              theme: theme,
              palette: palette,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildEnvironmentSection(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por ambiente',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
          ),
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          text: selectedEnvironments.isEmpty
              ? 'Selecione'
              : '${selectedEnvironments.length} selecionado(s)',
          onTap: () => _showEnvironmentBottomSheet(context),
          theme: theme,
          palette: palette,
        ),
        if (selectedEnvironments.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildChipsWithLimit<FilterLocalEntity>(
            items: selectedEnvironments.toList(),
            onRemove: _removeEnvironment,
            getLabel: (item) => item.name,
            theme: theme,
            palette: palette,
          ),
        ],
      ],
    );
  }

  Widget _buildEquipmentSection(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por equipamento',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
          ),
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          text: selectedEquipment.isEmpty
              ? 'Selecione'
              : '${selectedEquipment.length} selecionado(s)',
          onTap: () => _showEquipmentBottomSheet(context),
          theme: theme,
          palette: palette,
        ),
        if (selectedEquipment.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildChipsWithLimit<FilterAssetEntity>(
            items: selectedEquipment.toList(),
            onRemove: _removeEquipment,
            getLabel: (item) => item.name,
            theme: theme,
            palette: palette,
          ),
        ],
      ],
    );
  }

  Widget _buildEmployeeGroupSection(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por grupo de funcionários',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
          ),
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          text: selectedEmployeeGroups.isEmpty
              ? 'Selecione'
              : '${selectedEmployeeGroups.length} selecionado(s)',
          onTap: () => _showEmployeeGroupBottomSheet(context),
          theme: theme,
          palette: palette,
        ),
        if (selectedEmployeeGroups.isNotEmpty) ...[
          const SizedBox(height: 12),
          _buildChipsWithLimit<FilterEmployeeGroupEntity>(
            items: selectedEmployeeGroups.toList(),
            onRemove: _removeEmployeeGroup,
            getLabel: (item) => item.name,
            theme: theme,
            palette: palette,
          ),
        ],
      ],
    );
  }

  Widget _buildResponsibleSection(ThemeData theme, ColorPallete palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Por Responsável',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
          ),
        ),
        const SizedBox(height: 12),
        _buildDropdownField(
          text: selectedResponsible.isEmpty
              ? 'Selecione'
              : '${selectedResponsible.length} selecionado(s)',
          onTap: () => _showResponsibleBottomSheet(context),
          theme: theme,
          palette: palette,
        ),
        if (selectedResponsible.isNotEmpty) ...[
          const SizedBox(height: 12),
          Column(
            children: selectedResponsible.map((responsible) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildResponsibleCard(
                  person: responsible,
                  onRemove: () => _removeResponsible(responsible),
                  theme: theme,
                  palette: palette,
                ),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildDropdownField({
    required String text,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: palette.separator()),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: text == 'Selecione'
                      ? palette.textLight()
                      : palette.text(),
                ),
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: palette.textLight(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 6),
            Icon(
              Icons.add,
              size: 16,
              color: isSelected ? Colors.white : color,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearFilterButton(ThemeData theme, ColorPallete palette) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _hasUnsavedChanges ? palette.primary() : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _hasActiveFilters ? _clearAllFilters : null,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(
              'Limpar filtro',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: _hasActiveFilters
                    ? palette.primary()
                    : Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(ThemeData theme, ColorPallete palette) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: palette.background(),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: PrimaryButton(
          text: 'Buscar',
          onPressed: _applyFilters,
        ),
      ),
    );
  }

  // Bottom sheet methods
  Future<void> _showEnvironmentBottomSheet(BuildContext context) async {
    if (widget.filterOptions?.locals == null) return;

    final result = await showModalBottomSheet<Set<FilterLocalEntity>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => EnvironmentBottomSheet(
        options: widget.filterOptions?.locals ?? [],
        selectedItems: selectedEnvironments,
      ),
    );

    if (result != null) {
      setState(() {
        selectedEnvironments.clear();
        selectedEnvironments.addAll(result);
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _showEquipmentBottomSheet(BuildContext context) async {
    if (widget.filterOptions?.assets == null) return;

    final result = await showModalBottomSheet<Set<FilterAssetEntity>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => AssetBottomSheet(
        options: widget.filterOptions?.assets ?? [],
        selectedItems: selectedEquipment,
      ),
    );

    if (result != null) {
      setState(() {
        selectedEquipment.clear();
        selectedEquipment.addAll(result);
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _showEmployeeGroupBottomSheet(BuildContext context) async {
    if (widget.filterOptions?.employeeGroup == null) return;

    final result = await showModalBottomSheet<Set<FilterEmployeeGroupEntity>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => EmployeeGroupBottomSheet(
        options: widget.filterOptions?.employeeGroup ?? [],
        selectedItems: selectedEmployeeGroups,
      ),
    );

    if (result != null) {
      setState(() {
        selectedEmployeeGroups.clear();
        selectedEmployeeGroups.addAll(result);
        _hasUnsavedChanges = true;
      });
    }
  }

  Future<void> _showResponsibleBottomSheet(BuildContext context) async {
    if (widget.filterOptions?.responsibles == null) return;

    final result = await showModalBottomSheet<Set<FilterResponsibleEntity>>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) => ResponsibleBottomSheet(
        options: widget.filterOptions?.responsibles ?? [],
        selectedItems: selectedResponsible,
      ),
    );

    if (result != null) {
      setState(() {
        selectedResponsible.clear();
        selectedResponsible.addAll(result);
        _hasUnsavedChanges = true;
      });
    }
  }

  // Action methods
  void _toggleTaskType(TaskType taskType) {
    setState(() {
      if (selectedTaskTypes.contains(taskType)) {
        selectedTaskTypes.remove(taskType);
      } else {
        selectedTaskTypes.add(taskType);
      }
      _hasUnsavedChanges = true;
    });
  }

  void _toggleStatus(TaskStatusType status) {
    setState(() {
      if (selectedStatuses.contains(status)) {
        selectedStatuses.remove(status);
      } else {
        selectedStatuses.add(status);
      }
      _hasUnsavedChanges = true;
    });
  }

  void _clearAllFilters() {
    setState(() {
      selectedTaskTypes.clear();
      selectedStatuses.clear();
      selectedEnvironments.clear();
      selectedEquipment.clear();
      selectedEmployeeGroups.clear();
      selectedResponsible.clear();
      _hasUnsavedChanges = false; // Após limpar, não há mudanças não salvas
      _filtersWereCleared = true; // Marca que os filtros foram limpos
    });
  }

  void _handleBackNavigation() async {
    if (_hasUnsavedChanges) {
      final shouldDiscard = await _showDiscardChangesDialog();
      if (shouldDiscard == true) {
        Navigator.of(context).pop();
      }
    } else {
      // Se os filtros foram limpos, retorna filtros vazios para aplicar a limpeza
      if (_filtersWereCleared) {
        final clearedFilters = FilterOptionsEntity(
          locals: [],
          assets: [],
          responsibles: [],
          employeeGroup: [],
          taskType: [],
          taskStatus: [],
        );
        Navigator.of(context).pop(clearedFilters);
      } else {
        Navigator.of(context).pop();
      }
    }
  }

  Future<bool?> _showDiscardChangesDialog() {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Descartar alterações?',
          style: LelloTextStyles.title(theme),
        ),
        content: Text(
          'Você tem alterações não salvas. Deseja descartar as alterações e voltar?',
          style: LelloTextStyles.body(theme),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancelar',
              style: LelloTextStyles.button(theme)?.copyWith(
                color: palette.textLight(),
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Descartar',
              style: LelloTextStyles.button(theme)?.copyWith(
                color: palette.primary(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilters() {
    final filters = FilterOptionsEntity(
      locals: selectedEnvironments.toList(),
      assets: selectedEquipment.toList(),
      responsibles: selectedResponsible.toList(),
      employeeGroup: selectedEmployeeGroups.toList(),
      taskType: selectedTaskTypes.toList(),
      taskStatus: selectedStatuses.toList(),
    );

    Navigator.of(context).pop(filters);
  }

  // Remove methods for individual selections
  void _removeEnvironment(FilterLocalEntity environment) {
    setState(() {
      selectedEnvironments.remove(environment);
      _hasUnsavedChanges = true;
    });
  }

  void _removeEquipment(FilterAssetEntity equipment) {
    setState(() {
      selectedEquipment.remove(equipment);
      _hasUnsavedChanges = true;
    });
  }

  void _removeEmployeeGroup(FilterEmployeeGroupEntity group) {
    setState(() {
      selectedEmployeeGroups.remove(group);
      _hasUnsavedChanges = true;
    });
  }

  void _removeResponsible(FilterResponsibleEntity responsible) {
    setState(() {
      selectedResponsible.remove(responsible);
      _hasUnsavedChanges = true;
    });
  }

  // Chip builder methods with 4-item limit
  Widget _buildChipsWithLimit<T>({
    required List<T> items,
    required Function(T) onRemove,
    required String Function(T) getLabel,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    const int maxChips = 4;
    final displayItems = items.take(maxChips).toList();
    final excessCount = items.length - maxChips;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...displayItems.map((item) => _buildSelectedChip(
              label: getLabel(item),
              onRemove: () => onRemove(item),
              theme: theme,
              palette: palette,
            )),
        if (excessCount > 0)
          _buildExcessChip(
            count: excessCount,
            theme: theme,
            palette: palette,
          ),
      ],
    );
  }

  Widget _buildSelectedChip({
    required String label,
    required VoidCallback onRemove,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: Colors.white,
                fontSize: 12,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExcessChip({
    required int count,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: palette.textLight(),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '+$count',
        style: LelloTextStyles.body(theme)?.copyWith(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildResponsibleCard({
    required FilterResponsibleEntity person,
    required VoidCallback onRemove,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.blue,
            child: Text(
              person.name.isNotEmpty ? person.name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Responsável',
                  style: LelloTextStyles.body(theme)?.copyWith(
                    fontSize: 12,
                    color: palette.textLight(),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 20,
                color: palette.textLight(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
