import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../domain/entity/filter_options_entity.dart';
import '../pages/create_routine_detail_page.dart';

class ResponsibleSelectionWidget extends StatelessWidget {
  final ResponsibleType? selectedResponsibleType;
  final FilterEmployeeGroupEntity? selectedEmployeeGroup;
  final FilterResponsibleEntity? selectedEmployee;
  final List<FilterEmployeeGroupEntity> availableEmployeeGroups;
  final List<FilterResponsibleEntity> availableEmployees;
  final Function(ResponsibleType) onResponsibleTypeSelected;
  final Function(FilterEmployeeGroupEntity?) onEmployeeGroupSelected;
  final Function(FilterResponsibleEntity?) onEmployeeSelected;
  final ThemeData theme;
  final ColorPallete palette;

  const ResponsibleSelectionWidget({
    super.key,
    required this.selectedResponsibleType,
    required this.selectedEmployeeGroup,
    required this.selectedEmployee,
    required this.availableEmployeeGroups,
    required this.availableEmployees,
    required this.onResponsibleTypeSelected,
    required this.onEmployeeGroupSelected,
    required this.onEmployeeSelected,
    required this.theme,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Responsible type selection chips
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ResponsibleType.values.map((type) {
            final isSelected = selectedResponsibleType == type;
            return _buildResponsibleTypeChip(
              type: type,
              isSelected: isSelected,
              onTap: () => onResponsibleTypeSelected(type),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        // Conditional dropdown based on selected type
        if (selectedResponsibleType == ResponsibleType.team)
          _buildEmployeeGroupDropdown(context),
        if (selectedResponsibleType == ResponsibleType.employee)
          _buildEmployeeDropdown(context),
      ],
    );
  }

  Widget _buildResponsibleTypeChip({
    required ResponsibleType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final label = _getResponsibleTypeLabel(type);
    final color = isSelected ? palette.primary() : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: LelloTextStyles.body(theme)?.copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeGroupDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEmployeeGroupBottomSheet(context),
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
            Expanded(
              child: Text(
                selectedEmployeeGroup?.name ?? 'Selecione a equipe',
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: selectedEmployeeGroup != null
                      ? palette.text()
                      : palette.textLight(),
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

  Widget _buildEmployeeDropdown(BuildContext context) {
    return GestureDetector(
      onTap: () => _showEmployeeBottomSheet(context),
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
            Expanded(
              child: Text(
                selectedEmployee?.name ?? 'Selecione a equipe',
                style: LelloTextStyles.body(theme)?.copyWith(
                  color: selectedEmployee != null
                      ? palette.text()
                      : palette.textLight(),
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

  Widget _buildAllSelectedInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: palette.primary().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: palette.primary().withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.group,
            color: palette.primary(),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Todos os funcionários serão responsáveis',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.primary(),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEmployeeGroupBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) => _EmployeeGroupBottomSheet(
        availableEmployeeGroups: availableEmployeeGroups,
        selectedEmployeeGroup: selectedEmployeeGroup,
        onEmployeeGroupSelected: onEmployeeGroupSelected,
        theme: theme,
        palette: palette,
      ),
    );
  }

  void _showEmployeeBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10),
        ),
      ),
      builder: (context) => _EmployeeBottomSheet(
        availableEmployees: availableEmployees,
        selectedEmployee: selectedEmployee,
        onEmployeeSelected: onEmployeeSelected,
        theme: theme,
        palette: palette,
      ),
    );
  }

  String _getResponsibleTypeLabel(ResponsibleType type) {
    switch (type) {
      case ResponsibleType.team:
        return 'Equipe';
      case ResponsibleType.employee:
        return 'Funcionário';
    }
  }
}

class _EmployeeGroupBottomSheet extends StatelessWidget {
  final List<FilterEmployeeGroupEntity> availableEmployeeGroups;
  final FilterEmployeeGroupEntity? selectedEmployeeGroup;
  final Function(FilterEmployeeGroupEntity?) onEmployeeGroupSelected;
  final ThemeData theme;
  final ColorPallete palette;

  const _EmployeeGroupBottomSheet({
    required this.availableEmployeeGroups,
    required this.selectedEmployeeGroup,
    required this.onEmployeeGroupSelected,
    required this.theme,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: palette.text()),
              ),
              Expanded(
                child: Text(
                  'Responsável pela tarefa',
                  style: LelloTextStyles.title(theme)?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 24),

          // Employee groups list
          Expanded(
            child: ListView.separated(
              itemCount: availableEmployeeGroups.length,
              separatorBuilder: (context, index) => Divider(
                color: palette.separator(),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final group = availableEmployeeGroups[index];
                final isSelected = selectedEmployeeGroup?.id == group.id;

                return ListTile(
                  title: Text(
                    group.name,
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.text(),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: palette.primary(),
                        )
                      : null,
                  onTap: () {
                    onEmployeeGroupSelected(group);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmployeeBottomSheet extends StatelessWidget {
  final List<FilterResponsibleEntity> availableEmployees;
  final FilterResponsibleEntity? selectedEmployee;
  final Function(FilterResponsibleEntity?) onEmployeeSelected;
  final ThemeData theme;
  final ColorPallete palette;

  const _EmployeeBottomSheet({
    required this.availableEmployees,
    required this.selectedEmployee,
    required this.onEmployeeSelected,
    required this.theme,
    required this.palette,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close, color: palette.text()),
              ),
              Expanded(
                child: Text(
                  'Responsável pela tarefa',
                  style: LelloTextStyles.title(theme)?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),

          const SizedBox(height: 24),

          // Employees list
          Expanded(
            child: ListView.separated(
              itemCount: availableEmployees.length,
              separatorBuilder: (context, index) => Divider(
                color: palette.separator(),
                height: 1,
              ),
              itemBuilder: (context, index) {
                final employee = availableEmployees[index];
                final isSelected = selectedEmployee?.id == employee.id;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: palette.primary(),
                    child: Text(
                      employee.name.isNotEmpty
                          ? employee.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    employee.name,
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: palette.text(),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: palette.primary(),
                        )
                      : null,
                  onTap: () {
                    onEmployeeSelected(employee);
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
