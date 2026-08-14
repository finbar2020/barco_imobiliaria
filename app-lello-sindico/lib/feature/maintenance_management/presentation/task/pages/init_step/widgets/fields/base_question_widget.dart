import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../../../../../../domain/entity/event_details_entity.dart';

/// Widget base para todas as questions
/// Fornece estrutura comum: título, indicador de obrigatório, container
abstract class BaseQuestionWidget extends StatelessWidget {
  final QuestionEntity question;

  const BaseQuestionWidget({
    super.key,
    required this.question,
  });

  /// Método abstrato que cada widget filho deve implementar
  Widget buildField(BuildContext context, ThemeData theme, ColorPallete palette);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: palette.grey().withOpacity(0.1), // Design System
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título da pergunta com indicador de obrigatório
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: RichText(
              text: TextSpan(
                text: question.name,
                style: LelloTextStyles.body(theme)?.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: palette.text(), // Design System
                ),
                children: [
                  if (question.required)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: palette.error(),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Campo específico de cada tipo
          buildField(context, theme, palette),
        ],
      ),
    );
  }
}
