import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class TaskStartStepConfirmationModal extends StatelessWidget {
  final String stepName;

  const TaskStartStepConfirmationModal({
    required this.stepName,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String stepName,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => TaskStartStepConfirmationModal(stepName: stepName),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: palette.background(),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título principal
            Text(
              'Você optou por iniciar a etapa de $stepName',
              textAlign: TextAlign.center,
              style: LelloTextStyles.title(theme)?.copyWith(
                color: palette.text(),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Subtítulo
            Text(
              'Deseja continuar?',
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: palette.text(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),

            // Botão "Sim, iniciar etapa agora"
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Sim, iniciar etapa agora',
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Botão "Não, voltar"
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(false),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: palette.primary()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Não, voltar',
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    color: palette.primary(),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
