import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'base_question_widget.dart';

/// Widget para campos numéricos (NUMBER e DECIMAL)
class NumberQuestionWidget extends BaseQuestionWidget {
  final String? currentAnswer;
  final Function(String) onAnswerChanged;
  final bool isDecimal;

  const NumberQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
    this.isDecimal = false,
  });

  @override
  Widget buildField(
      BuildContext context, ThemeData theme, ColorPallete palette) {
    return TextField(
      controller: TextEditingController(text: currentAnswer ?? '')
        ..selection = TextSelection.fromPosition(
          TextPosition(offset: currentAnswer?.length ?? 0),
        ),
      keyboardType: isDecimal
          ? const TextInputType.numberWithOptions(decimal: true)
          : TextInputType.number,
      inputFormatters: [
        if (isDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: onAnswerChanged,
      style: TextStyle(
        fontFamily: 'Anek Latin',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: palette.text(), // Design System
      ),
      decoration: InputDecoration(
        hintText: isDecimal ? 'Digite um número decimal' : 'Digite um número',
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
