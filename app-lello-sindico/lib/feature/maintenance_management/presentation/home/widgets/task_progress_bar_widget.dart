import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/text/lello_text_styles.dart';
import 'package:flutter/material.dart';

import 'task_summary/task_summary_model.dart';

class TaskProgressBar extends StatelessWidget {
  final List<TaskStatus> statuses;

  const TaskProgressBar({
    super.key,
    required this.statuses,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Row(
          children: statuses
              .asMap()
              .entries
              .where((entry) => entry.value.count > 0)
              .map((entry) {
            final item = entry.value;
            final filteredStatuses =
                statuses.where((s) => s.count > 0).toList();
            final newIdx = filteredStatuses.indexOf(item);

            // Garantir que barras pequenas sejam visíveis, mas não mostrar quando for zero
            // Se o valor for muito pequeno comparado ao total, usar um mínimo (mas só se > 0)
            final maxCount =
                statuses.map((s) => s.count).reduce((a, b) => a > b ? a : b);
            final minVisibleFlex = (maxCount * 0.02)
                .ceil()
                .clamp(1, 5); // 2% do maior valor, entre 1 e 5
            final flexValue =
                item.count < minVisibleFlex ? minVisibleFlex : item.count;

            return Expanded(
              flex: flexValue,
              child: Container(
                height: 13,
                margin: EdgeInsets.only(
                  right: newIdx == filteredStatuses.length - 1 ? 0 : 2,
                  left: newIdx == 0 ? 0 : 2,
                ),
                decoration: BoxDecoration(
                  color: item.status.color(theme),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(8),
                    right: Radius.circular(8),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8.0, // Espaçamento horizontal entre itens
          runSpacing: 4.0, // Espaçamento vertical entre linhas
          children: statuses.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: item.status.color(theme),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  '${item.count} ${item.status.name(context)}'.toLowerCase(),
                  style: LelloTextStyles.captionBold(theme),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
