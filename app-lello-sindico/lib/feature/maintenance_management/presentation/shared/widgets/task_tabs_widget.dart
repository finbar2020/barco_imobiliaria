import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/task/bloc/task_details_event.dart';

class GenericTabsWidget<T> extends StatelessWidget {
  final T selectedTab;
  final Function(T) onTabChanged;
  final List<TabItem<T>> tabs;

  const GenericTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: tabs
            .map(
              (tab) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: tabs.indexOf(tab) < tabs.length - 1 ? 12 : 0,
                  ),
                  child: _buildTab(
                    label: tab.label,
                    selected: selectedTab == tab.value,
                    onTap: () => onTabChanged(tab.value),
                    theme: theme,
                    palette: palette,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool selected,
    required VoidCallback onTap,
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? palette.background() : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withAlpha(20),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: (selected
                  ? LelloTextStyles.bodyBold(theme)
                  : LelloTextStyles.body(theme))
              ?.copyWith(color: Colors.black87),
        ),
      ),
    );
  }
}

class TabItem<T> {
  final String label;
  final T value;

  const TabItem({
    required this.label,
    required this.value,
  });
}

// Widget específico para TaskDetails (mantém compatibilidade)

class TaskTabsWidget extends StatelessWidget {
  final TaskDetailsTabType selectedTab;
  final Function(TaskDetailsTabType) onTabChanged;

  const TaskTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GenericTabsWidget<TaskDetailsTabType>(
      selectedTab: selectedTab,
      onTabChanged: onTabChanged,
      tabs: const [
        TabItem(
          label: 'Etapas',
          value: TaskDetailsTabType.steps,
        ),
        TabItem(
          label: 'Anexos',
          value: TaskDetailsTabType.attachments,
        ),
      ],
    );
  }
}
