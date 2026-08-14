import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

enum TaskDeleteScope { single, future }

class TaskDeleteConfirmationModal extends StatelessWidget {
  const TaskDeleteConfirmationModal({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título
            Text(
              'Você optou por excluir\nestá tarefa.',
              textAlign: TextAlign.center,
              style: LelloTextStyles.headline(theme)?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.w400,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            // Subtítulo
            Text(
              'Deseja continuar?',
              textAlign: TextAlign.center,
              style: LelloTextStyles.body(theme)?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: palette.text(),
              ),
            ),
            const SizedBox(height: 32),
            // Botão Sim, excluir tarefa
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                theme: theme,
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                text: 'Sim, excluir tarefa',
                buttonColor: palette.primary(),
              ),
            ),
            const SizedBox(height: 12),
            // Botão Não, voltar
            SizedBox(
              width: double.infinity,
              child: InvertedPrimaryButton(
                onPressed: () {
                  Navigator.of(context).pop(null);
                },
                text: 'Não, voltar',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
