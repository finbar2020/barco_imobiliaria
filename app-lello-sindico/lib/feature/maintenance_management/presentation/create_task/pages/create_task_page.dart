import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import '../enums/task_creation_type.dart';

class CreateTaskPage extends StatefulWidget {
  const CreateTaskPage({super.key});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  int? _selectedCardIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = LelloTheme.palleteOf(theme);

    return Scaffold(
      appBar: PrimaryAppBar(
        title: "",
        theme: theme,
        onBackArrowPressed: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Text(
                "Qual tipo de tarefa você precisa?",
                style: LelloTextStyles.headline(theme)?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 24),

            // Card "Criar uma rotina"
            _buildTaskTypeCard(
              context: context,
              theme: theme,
              palette: palette,
              title:
                  getString(context, "maintenance_management_create_routine"),
              subtitle: 'Tarefas que terão uma frequência',
              illustration: const Center(
                child: Image(
                  image: AssetImage('assets/routines.png'),
                ),
              ),
              onTap: () => _selectCard(0),
              isSelected: _selectedCardIndex == 0,
              cardIndex: 0,
              cardColor: palette.raffle(),
            ),

            const SizedBox(height: 24),

            // Card "Criar ordem de serviço"
            _buildTaskTypeCard(
              context: context,
              theme: theme,
              palette: palette,
              title: getString(
                  context, "maintenance_management_create_service_order"),
              subtitle: "Tarefas não previstas ou ocasionais",
              illustration: const Center(
                child: Image(
                  image: AssetImage('assets/service_orders.png'),
                ),
              ),
              onTap: () => _selectCard(1),
              isSelected: _selectedCardIndex == 1,
              cardIndex: 1,
              cardColor: palette.primary(),
            ),
            const SizedBox(height: 24),
            // Botão "Começar"
            PrimaryButton(
              onPressed: _selectedCardIndex != null
                  ? () => _navigateToSelectedOption(context)
                  : null,
              text: 'Começar',
            ),
          ],
        ),
      ),
    );
  }

  void _selectCard(int index) {
    setState(() {
      _selectedCardIndex = index;
    });
  }

  Future _navigateToSelectedOption(BuildContext context) async {
    if (_selectedCardIndex == 0) {
      await _navigateToCreateRoutine();
    } else if (_selectedCardIndex == 1) {
      await _navigateToCreateServiceOrder();
    }
  }

  Widget _buildTaskTypeCard({
    required BuildContext context,
    required ThemeData theme,
    required ColorPallete palette,
    required String title,
    required String subtitle,
    required Widget illustration,
    required VoidCallback onTap,
    required bool isSelected,
    required int cardIndex,
    required Color cardColor,
  }) {
    return Flexible(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: palette.grey(), width: 2)
                : Border.all(color: palette.grey(), width: 0.5),
          ),
          child: Column(
            children: [
              Flexible(child: illustration),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: LelloTextStyles.bodyBold(theme)?.copyWith(
                            color: cardColor,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: LelloTextStyles.body(theme)?.copyWith(
                            color: cardColor,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.add,
                    color: cardColor,
                    size: 30,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _navigateToCreateRoutine() {
    return Navigator.pushNamed(
      context,
      ApplicationRoute.maintenanceManagementCreateRoutine,
      arguments: TaskCreationType.routine,
    );
  }

  Future _navigateToCreateServiceOrder() {
    return Navigator.pushNamed(
      context,
      ApplicationRoute.maintenanceManagementCreateRoutine,
      arguments: TaskCreationType.serviceOrder,
    );
  }
}
