import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'base_question_widget.dart';

/// Widget para campos de data (DATE e SCHEDULE)
class DateQuestionWidget extends BaseQuestionWidget {
  final String? currentAnswer;
  final Function(String) onAnswerChanged;

  const DateQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    DateTime? selectedDate;
    
    if (currentAnswer != null && currentAnswer!.isNotEmpty) {
      try {
        selectedDate = dateFormat.parse(currentAnswer!);
      } catch (e) {
        // Ignora erro de parse
      }
    }

    return GestureDetector(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          locale: const Locale('pt', 'BR'),
        );
        
        if (picked != null) {
          onAnswerChanged(dateFormat.format(picked));
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: palette.background(), // Design System
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: palette.grey(), // Design System
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 20,
              color: palette.grey(), // Design System
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                selectedDate != null
                    ? dateFormat.format(selectedDate)
                    : 'Selecione uma data',
                style: TextStyle(
                  fontFamily: 'Anek Latin',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: selectedDate != null
                      ? palette.text() // Design System
                      : palette.grey(), // Design System
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
