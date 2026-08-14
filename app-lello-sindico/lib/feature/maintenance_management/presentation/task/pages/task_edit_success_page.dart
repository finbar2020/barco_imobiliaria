import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

import '../../../../../core/navigation/application_route.dart';
import '../../shared/utils/maintenance_reload_helper.dart';

class TaskEditSuccessPage extends StatelessWidget {
  final String title;
  final String? description;
  final String taskId;
  final bool isServiceOrder;

  const TaskEditSuccessPage({
    super.key,
    required this.title,
    this.description,
    required this.taskId,
    this.isServiceOrder = false,
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
                    width: isServiceOrder ? 63.461 : 80,
                    height: isServiceOrder ? 63.461 : 80,
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

                  SizedBox(height: isServiceOrder ? 38 : 32),

                  // Success title
                  Text(
                    title,
                    style: isServiceOrder
                        ? TextStyle(
                            fontFamily: 'Anek Latin',
                            fontSize: 32,
                            fontWeight: FontWeight.w400,
                            color: palette.text(),
                            height: 1.0012,
                          )
                        : LelloTextStyles.headline(theme)?.copyWith(
                            color: palette.text(),
                          ),
                    textAlign: TextAlign.center,
                  ),

                  if (!isServiceOrder && description != null) ...[
                    const SizedBox(height: 24),
                    Text(
                      description!,
                      style: LelloTextStyles.body(theme)?.copyWith(
                        color: palette.text(),
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Bottom buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: PrimaryButton(
                    theme: theme,
                    buttonColor: palette.primary(),
                    onPressed: () => _handlePrimaryAction(context),
                    text: 'Abrir tarefa',
                  ),
                ),
                SizedBox(height: isServiceOrder ? 8 : 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: PrimaryButton(
                    theme: theme,
                    buttonColor: palette.secondary(),
                    onPressed: () => _goToHome(context),
                    text: 'Ir para página inicial',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handlePrimaryAction(BuildContext context) {
    _openTask(context);
  }

  void _openTask(BuildContext context) {
    // Navegar para os detalhes da tarefa usando pushNamedAndRemoveUntil
    Navigator.of(context).pushNamedAndRemoveUntil(
      ApplicationRoute.maintenanceManagementTaskDetails,
      ModalRoute.withName(ApplicationRoute.maintenanceManagement),
      arguments: taskId,
    );
  }

  void _goToHome(BuildContext context) {
    // Recarrega os dados da semana atual
    MaintenanceReloadHelper.reloadCurrentWeek();
    
    // Volta para a tela inicial fazendo pop até encontrá-la
    Navigator.of(context).popUntil(
      ModalRoute.withName(ApplicationRoute.maintenanceManagement),
    );
  }
}
