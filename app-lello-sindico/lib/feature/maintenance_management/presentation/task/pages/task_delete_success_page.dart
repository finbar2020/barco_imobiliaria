import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../shared/utils/maintenance_reload_helper.dart';

class TaskDeleteSuccessPage extends StatelessWidget {
  final String title;
  final String description;
  final bool isSingleDelete;

  const TaskDeleteSuccessPage({
    super.key,
    required this.title,
    required this.description,
    required this.isSingleDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      backgroundColor: palette.background(),
      appBar: PrimaryAppBar(
        theme: theme,
        title: 'Detalhe da tarefa',
      ),
      body: Column(
        children: [
          // Content area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Success icon
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: palette.success(),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Success title
                  Text(
                    title,
                    style: LelloTextStyles.headline(theme)?.copyWith(
                      color: palette.text(),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),
                  Text(
                    description,
                    style: LelloTextStyles.bodyBold(theme)?.copyWith(
                      color: palette.text(),
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Bottom button
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                theme: theme,
                buttonColor: palette.secondary(),
                onPressed: () => _goToHome(context),
                text: 'Ir para página inicial',
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goToHome(BuildContext context) {
    // Recarrega os dados da semana atual
    MaintenanceReloadHelper.reloadCurrentWeek();
    
    // Fecha a tela de sucesso e retorna true para indicar que precisa recarregar
    Navigator.of(context).pop(true);
  }
}
