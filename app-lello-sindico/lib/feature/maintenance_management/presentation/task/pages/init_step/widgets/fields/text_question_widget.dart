import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../../../../domain/entity/event_details_entity.dart';
import 'base_question_widget.dart';

/// Widget para campos de texto simples (TEXT)
class TextQuestionWidget extends BaseQuestionWidget {
  final String? currentAnswer;
  final Function(String) onAnswerChanged;

  const TextQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: palette.background(), // Design System
        border: Border.all(
          color: palette.grey(), // Design System
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: TextField(
        onChanged: onAnswerChanged,
        controller: TextEditingController(text: currentAnswer)
          ..selection = TextSelection.collapsed(
            offset: currentAnswer?.length ?? 0,
          ),
        decoration: InputDecoration(
          hintText: 'Digite sua resposta',
          hintStyle: LelloTextStyles.body(theme)?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: palette.grey(), // Design System
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.zero,
          isDense: true,
        ),
        style: LelloTextStyles.body(theme)?.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: palette.text(), // Design System
        ),
      ),
    );
  }
}
