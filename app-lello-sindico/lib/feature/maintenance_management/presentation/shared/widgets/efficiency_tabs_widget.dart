import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';

enum EfficiencyTabType { responsibles, groups }

class EfficiencyTabsWidget extends StatelessWidget {
  final EfficiencyTabType selectedTab;
  final Function(EfficiencyTabType) onTabChanged;
  final String responsiblesLabel;
  final String groupsLabel;

  const EfficiencyTabsWidget({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
    required this.responsiblesLabel,
    required this.groupsLabel,
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
        children: [
          _buildTab(
            label: responsiblesLabel,
            selected: selectedTab == EfficiencyTabType.responsibles,
            onTap: () => onTabChanged(EfficiencyTabType.responsibles),
            theme: theme,
            palette: palette,
          ),
          const SizedBox(width: 12),
          _buildTab(
            label: groupsLabel,
            selected: selectedTab == EfficiencyTabType.groups,
            onTap: () => onTabChanged(EfficiencyTabType.groups),
            theme: theme,
            palette: palette,
          ),
        ],
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
    return Expanded(
      child: InkWell(
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
      ),
    );
  }
}
