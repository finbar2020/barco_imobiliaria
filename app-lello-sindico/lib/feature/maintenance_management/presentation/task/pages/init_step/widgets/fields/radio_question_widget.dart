import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'base_question_widget.dart';

/// Widget para seleção única com opções (RADIO)
class RadioQuestionWidget extends BaseQuestionWidget {
  final String? currentAnswer;
  final Function(String) onAnswerChanged;

  const RadioQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette) {
    final options = question.options ?? [];

    return Column(
      children: options.map((option) {
        final isSelected = currentAnswer == option.id;
        
        return GestureDetector(
          onTap: () => onAnswerChanged(option.id),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: palette.background(), // Design System
              border: Border.all(
                color: isSelected 
                    ? palette.primary() 
                    : palette.grey(), // Design System
                width: isSelected ? 2 : 1.5,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? palette.primary() 
                          : palette.grey(), // Design System
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: palette.primary(),
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    option.name,
                    style: LelloTextStyles.body(theme)?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: palette.text(), // Design System
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
