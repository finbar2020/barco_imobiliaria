import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

/// Widget reutilizável para seleção de dias da semana
/// 
/// Usado em telas de criação e edição de tarefas para permitir
/// que o usuário selecione quais dias da semana a tarefa deve ocorrer.
class WeekDaySelectorWidget extends StatelessWidget {
  final List<int> selectedDays;
  final Function(int) onDayToggled;
  final ThemeData theme;
  final ColorPallete palette;
  final String? title;

  const WeekDaySelectorWidget({
    super.key,
    required this.selectedDays,
    required this.onDayToggled,
    required this.theme,
    required this.palette,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(
            title!,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDayButton('Dom', 0),
            _buildDayButton('Seg', 1),
            _buildDayButton('Ter', 2),
            _buildDayButton('Qua', 3),
            _buildDayButton('Qui', 4),
            _buildDayButton('Sex', 5),
            _buildDayButton('Sáb', 6),
          ],
        ),
      ],
    );
  }

  Widget _buildDayButton(String label, int dayIndex) {
    final isSelected = selectedDays.contains(dayIndex);

    return GestureDetector(
      onTap: () => onDayToggled(dayIndex),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? palette.primary() : Colors.transparent,
          border: Border.all(
            color: isSelected ? palette.primary() : palette.separator(),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: isSelected ? Colors.white : palette.text(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
