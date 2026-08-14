import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import '../../home/bloc/maintenance_management_last_week/maintenance_management_last_week_state.dart';
import '../../home/widgets/task_progress_bar_widget.dart';
import '../../home/widgets/task_summary/task_summary_model.dart';

class EfficiencyTileWidget extends StatelessWidget {
  final EfficiencyItem item;
  final bool showDivider;

  const EfficiencyTileWidget({
    super.key,
    required this.item,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    final pendingCount = item.pending;
    final completedCount = item.completed;
    final inProgressCount = item.inProgress;

    // Parse color from hex string
    Color avatarColor;
    try {
      avatarColor =
          Color(int.parse(item.avatarColor.replaceFirst('#', '0xFF')));
    } catch (e) {
      avatarColor = palette.primary();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Title row
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  item.title.isNotEmpty ? item.title[0].toUpperCase() : '?',
                  style: LelloTextStyles.titleBold(theme)?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: LelloTextStyles.subtitleBold(theme)),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: LelloTextStyles.body(theme)
                          ?.copyWith(color: palette.grey()),
                    ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Progress bar - sempre mostra os status na ordem: completed, inProgress, pending
        TaskProgressBar(statuses: [
          TaskStatus(
            status: TaskStatusType.completed,
            count: completedCount,
          ),
          TaskStatus(
            status: TaskStatusType.inProgress,
            count: inProgressCount,
          ),
          TaskStatus(
            status: TaskStatusType.pending,
            count: pendingCount,
          ),
        ]),

        const SizedBox(height: 10),

        if (showDivider) const Divider(),
      ],
    );
  }
}
