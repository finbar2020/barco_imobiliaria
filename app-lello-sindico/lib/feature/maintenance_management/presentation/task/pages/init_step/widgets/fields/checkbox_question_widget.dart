import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'base_question_widget.dart';

/// Widget para campos de múltipla seleção (CHECKBOX)
class CheckboxQuestionWidget extends BaseQuestionWidget {
  final List<String>? currentAnswer;
  final Function(List<String>) onAnswerChanged;

  const CheckboxQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette) {
    final options = question.options ?? [];
    final selectedIds = currentAnswer ?? [];

    if (options.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.orange),
        ),
        child: Text(
          'Nenhuma opção disponível para seleção',
          style: TextStyle(color: Colors.orange.shade900),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        final isSelected = selectedIds.contains(option.id);
        
        return CheckboxListTile(
          value: isSelected,
          onChanged: (bool? value) {
            final updatedList = List<String>.from(selectedIds);
            if (value == true) {
              updatedList.add(option.id);
            } else {
              updatedList.remove(option.id);
            }
            onAnswerChanged(updatedList);
          },
          title: Text(
            option.name,
            style: TextStyle(
              fontFamily: 'Anek Latin',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: palette.text(), // Design System
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
          activeColor: palette.primary(),
        );
      }).toList(),
    );
  }
}
