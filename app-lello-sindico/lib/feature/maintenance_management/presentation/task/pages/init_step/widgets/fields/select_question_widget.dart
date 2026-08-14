import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'base_question_widget.dart';

/// Widget para campos de seleção (SELECT e COMBO_SELECT)
class SelectQuestionWidget extends BaseQuestionWidget {
  final String? currentAnswer;
  final Function(String) onAnswerChanged;

  const SelectQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(
      BuildContext context, ThemeData theme, ColorPallete palette) {
    final options = question.options ?? [];

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

    return DropdownButtonFormField<String>(
      value: currentAnswer,
      onChanged: (value) {
        if (value != null) {
          onAnswerChanged(value);
        }
      },
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option.id,
          child: Text(
            option.name,
            style: TextStyle(
              fontFamily: 'Anek Latin',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: palette.text(), // Design System
            ),
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        hintText: 'Selecione uma opção',
        hintStyle: TextStyle(
          fontFamily: 'Anek Latin',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: palette.grey(), // Design System
        ),
        filled: true,
        fillColor: palette.background(), // Design System,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: palette.grey(), // Design System
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: palette.grey(), // Design System
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(
            color: palette.primary(),
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
