import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'base_question_widget.dart';

/// Widget para assinatura digital (SIGNATURE)
class SignatureQuestionWidget extends BaseQuestionWidget {
  final String? currentAnswer;
  final Function(String) onAnswerChanged;

  const SignatureQuestionWidget({
    super.key,
    required super.question,
    this.currentAnswer,
    required this.onAnswerChanged,
  });

  @override
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette) {
    final hasSigned = currentAnswer != null && currentAnswer!.isNotEmpty;

    return GestureDetector(
      onTap: () {
        // TODO: Implementar tela de assinatura com canvas
        // Por enquanto, apenas simula uma assinatura
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Funcionalidade de assinatura em desenvolvimento'),
            backgroundColor: Colors.orange,
          ),
        );
      },
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: palette.background(), // Design System
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: palette.grey(), // Design System
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                hasSigned ? Icons.check_circle : Icons.edit,
                size: 40,
                color: hasSigned ? palette.success() : palette.grey(), // Design System
              ),
              const SizedBox(height: 8),
              Text(
                hasSigned ? 'Assinado' : 'Toque para assinar',
                style: TextStyle(
                  fontFamily: 'Anek Latin',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: hasSigned
                      ? palette.success()
                      : palette.grey(), // Design System
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
