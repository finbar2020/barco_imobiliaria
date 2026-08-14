import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import '../pages/create_routine_detail_page.dart';

class CreateTaskConfirmationModal extends StatelessWidget {
  final String taskTitle;
  final String? equipmentName;
  final String? responsibleTeam;
  final DateTime? startDate;
  final DateTime? endDate;
  final TimeOfDay? startTime;
  final bool isDayLong;
  final FrequencyType? frequency;
  final List<int>? selectedWeekDays;
  final String? description;
  final String confirmationLabel;
  final String summaryLabel;
  final String confirmButtonLabel;
  final String secondaryButtonLabel;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final ThemeData theme;
  final ColorPallete palette;

  const CreateTaskConfirmationModal({
    super.key,
    required this.taskTitle,
    this.equipmentName,
    this.responsibleTeam,
    this.startDate,
    this.endDate,
    this.startTime,
    this.isDayLong = false,
    this.frequency,
    this.selectedWeekDays,
    this.description,
    required this.confirmationLabel,
    required this.summaryLabel,
    required this.confirmButtonLabel,
    required this.secondaryButtonLabel,
    required this.onConfirm,
    required this.onCancel,
    required this.theme,
    required this.palette,
  });

  static Future<bool?> show({
    required BuildContext context,
    required String taskTitle,
    String? equipmentName,
    String? responsibleTeam,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startTime,
    bool isDayLong = false,
    FrequencyType? frequency,
    List<int>? selectedWeekDays,
    String? description,
    String confirmationLabel = 'rotina preventiva',
    String summaryLabel = 'Tarefa de rotina preventiva',
    String confirmButtonLabel = 'Confirmar criação',
    String secondaryButtonLabel = 'Voltar e editar',
    required ThemeData theme,
    required ColorPallete palette,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CreateTaskConfirmationModal(
        taskTitle: taskTitle,
        equipmentName: equipmentName,
        responsibleTeam: responsibleTeam,
        startDate: startDate,
        endDate: endDate,
        startTime: startTime,
        isDayLong: isDayLong,
        frequency: frequency,
        selectedWeekDays: selectedWeekDays,
        description: description,
        confirmationLabel: confirmationLabel,
        summaryLabel: summaryLabel,
        confirmButtonLabel: confirmButtonLabel,
        secondaryButtonLabel: secondaryButtonLabel,
        theme: theme,
        palette: palette,
        onConfirm: () => Navigator.of(context).pop(true),
        onCancel: () => Navigator.of(context).pop(false),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            // Title
            Text(
              'Confirmar criação da tarefa de $confirmationLabel',
              textAlign: TextAlign.center,
              style: LelloTextStyles.title(theme)?.copyWith(
                color: palette.text(),
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Subtitle
            Text(
              'Revise os dados antes de criar a tarefa.',
              textAlign: TextAlign.center,
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: palette.text(),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 16),

            // Task details section
            Text(
              'Tarefa de ${summaryLabel.toLowerCase()}',
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: palette.textLight(),
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 12),

            // Details list
            ..._buildDetailsList(),

            const SizedBox(height: 24),

            // Confirm button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: palette.primary(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  confirmButtonLabel,
                  style: LelloTextStyles.bodyBold(theme)?.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Cancel button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onCancel,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: palette.primary()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  secondaryButtonLabel,
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

  List<Widget> _buildDetailsList() {
    final details = <Widget>[];

    if (equipmentName != null) {
      details.add(_buildDetailItem('Equipamento: $equipmentName'));
    }

    if (responsibleTeam != null) {
      details.add(_buildDetailItem('Equipe responsável: $responsibleTeam'));
    }

    if (startDate != null) {
      final dateStr =
          '${startDate!.day.toString().padLeft(2, '0')}/${startDate!.month.toString().padLeft(2, '0')}/${startDate!.year}';
      details.add(_buildDetailItem('Data de início: $dateStr'));
    }

    if (endDate != null) {
      final dateStr =
          '${endDate!.day.toString().padLeft(2, '0')}/${endDate!.month.toString().padLeft(2, '0')}/${endDate!.year}';
      details.add(_buildDetailItem('Data de fim: $dateStr'));
    }

    if (summaryLabel.toLowerCase() != 'ordem de serviço') {
      if (isDayLong) {
        details.add(_buildDetailItem('Dia inteiro: Sim'));
      } else if (startTime != null) {
        final timeStr =
            '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
        details.add(_buildDetailItem('Horário: $timeStr'));
      }
    }

    if (frequency != null) {
      String frequencyStr = _getFrequencyLabel(frequency!);
      details.add(_buildDetailItem('Frequência: $frequencyStr'));
    }

    if (selectedWeekDays != null && selectedWeekDays!.isNotEmpty) {
      final dayNames = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sab'];
      final selectedDays =
          selectedWeekDays!.map((index) => dayNames[index]).join(', ');
      details.add(_buildDetailItem('Dias da semana: $selectedDays'));
    }

    if (description != null && description!.isNotEmpty) {
      details.add(_buildDetailItem('Orientações: $description'));
    }

    return details;
  }

  Widget _buildDetailItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: BoxDecoration(
              color: palette.textLight(),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.textLight(),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getFrequencyLabel(FrequencyType frequency) {
    switch (frequency) {
      case FrequencyType.daily:
        return 'Diária';
      case FrequencyType.weekly:
        return 'Semanal';
      case FrequencyType.monthly:
        return 'Mensal';
      case FrequencyType.yearly:
        return 'Anual';
    }
  }
}
