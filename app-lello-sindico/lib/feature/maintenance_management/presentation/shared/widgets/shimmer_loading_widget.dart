import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../home/widgets/task_summary/task_summary_card_widget.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  final bool showTaskSummary;
  final bool showTabs;
  final bool showSearchField;
  final bool showList;
  final int listItemCount;
  final String? tabsTitle;
  final String? responsiblesLabel;
  final String? groupsLabel;
  final String? searchHint;

  const ShimmerLoadingWidget({
    super.key,
    this.showTaskSummary = true,
    this.showTabs = true,
    this.showSearchField = true,
    this.showList = true,
    this.listItemCount = 3,
    this.tabsTitle,
    this.responsiblesLabel,
    this.groupsLabel,
    this.searchHint,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Column(
      children: [
        if (showTaskSummary) ...[
          _buildTaskSummaryShimmer(theme),
          const SizedBox(height: 16),
        ],
        if (showTabs || showSearchField || showList)
          Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                color: palette.background(),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(10),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (tabsTitle != null) ...[
                    Text(
                      tabsTitle!,
                      style: LelloTextStyles.subtitleBold(theme),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (showTabs) ...[
                    _buildTabsShimmer(context, theme, palette),
                    const SizedBox(height: 16),
                  ],
                  if (showSearchField) ...[
                    _buildSearchFieldShimmer(context, theme, palette),
                    const SizedBox(height: 16),
                  ],
                  if (showList) _buildListShimmer(theme),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTaskSummaryShimmer(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: TaskSummaryCard(
        dtStart: "01/01/2024",
        untilDate: "31/01/2024",
      ),
    );
  }

  Widget _buildTabsShimmer(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
  ) {
    Widget buildTab(String label, bool selected) {
      return Expanded(
        child: Container(
          height: 44,
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
            style: (selected
                    ? LelloTextStyles.bodyBold(theme)
                    : LelloTextStyles.body(theme))
                ?.copyWith(color: Colors.black87),
          ),
        ),
      );
    }

    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          buildTab(
            responsiblesLabel ?? 'Responsáveis',
            true,
          ),
          const SizedBox(width: 12),
          buildTab(
            groupsLabel ?? 'Grupos',
            false,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchFieldShimmer(
    BuildContext context,
    ThemeData theme,
    ColorPallete palette,
  ) {
    return Container(
      height: 46,
      decoration: BoxDecoration(
        color: palette.background(),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: palette.grey()),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Icon(Icons.search, color: palette.grey()),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              enabled: false,
              decoration: InputDecoration.collapsed(
                hintText: searchHint ?? 'Buscar funcionário',
                hintStyle: LelloTextStyles.body(theme)
                    ?.copyWith(color: palette.grey()),
              ),
              style: LelloTextStyles.body(theme),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListShimmer(ThemeData theme) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: Column(
        children: List.generate(listItemCount, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 12,
                        width: 100,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
