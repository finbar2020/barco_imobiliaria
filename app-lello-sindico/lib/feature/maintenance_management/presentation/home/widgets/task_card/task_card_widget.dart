import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/maintenance_management/presentation/home/widgets/task_card/task_card_enum.dart';
import 'package:lello/feature/maintenance_management/presentation/shared/widgets/info_tooltip_widget.dart';

import '../task_summary/task_summary_model.dart';

class TaskCardWidget extends StatelessWidget {
  final String title;
  final String start;
  final String timeDescription;
  final TaskType type;
  final bool isAllDay;
  final TaskStatusType status;
  final VoidCallback onTap;
  final bool showViewTaskButton;
  final DateTime? createdAt;
  final DateTime? referenceDate; // Data de referência para cálculo relativo

  const TaskCardWidget({
    super.key,
    required this.title,
    required this.start,
    required this.timeDescription,
    required this.type,
    required this.status,
    required this.onTap,
    required this.isAllDay,
    this.showViewTaskButton = true,
    this.createdAt,
    this.referenceDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Container(
      constraints: const BoxConstraints(
        minHeight: 130,
      ),
      decoration: BoxDecoration(
        color: pallete.background(),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 8,
              decoration: BoxDecoration(
                color: type.color(theme),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: pallete.background(),
                  border: Border.all(
                    color: type.color(theme),
                    width: 1,
                  ),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            type.name(context).toUpperCase(),
                            style: LelloTextStyles.captionBold(theme)
                                ?.copyWith(color: type.color(theme)),
                          ),
                          const Spacer(),
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: status.color(theme),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status.statusLabel(context).toLowerCase(),
                            style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: pallete.grey(),
                            ),
                          ),
                        ],
                      ),
                      const Divider(
                        height: 8,
                      ),
                      Text(
                        title,
                        style: LelloTextStyles.subtitleBold(theme),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (type == TaskType.serviceOrder &&
                          (status == TaskStatusType.pending ||
                              status == TaskStatusType.inProgress)) ...[
                        const SizedBox(height: 4),
                        const InfoTooltip(
                          message:
                              "Esta ordem de serviço permanecerá visível até conclusão.",
                        ),
                      ],
                      const Spacer(),
                      Row(
                        children: [
                          Icon(
                            isAllDay
                                ? Icons.calendar_today_rounded
                                : Icons.access_time,
                            size: 16,
                            color: pallete.grey(),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _getDisplayTime(context),
                            style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: pallete.grey(),
                            ),
                          ),
                          Expanded(child: Container()),
                          if (showViewTaskButton)
                            PrimaryButton(
                              onPressed: onTap,
                              buttonColor: pallete.secondary(),
                              width: 100,
                              height: 32,
                              text: getString(context, "task_card_view_task"),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDisplayTime(BuildContext context) {
    // Sempre usa timeDescription quando disponível, pois já vem formatado do backend
    // com toda a lógica necessária (horários, "Criada há X dias", "Dia todo", etc.)
    if (timeDescription.isNotEmpty) {
      return timeDescription;
    }

    // Fallback: se timeDescription estiver vazio, usa a lógica anterior
    if (isAllDay) {
      return getString(context, "task_card_all_day");
    } else {
      return start;
    }
  }
}
