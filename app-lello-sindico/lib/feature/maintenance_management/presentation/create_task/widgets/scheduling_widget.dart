import 'package:essentials/essentials.dart' hide Switch;
import 'package:flutter/material.dart';
import '../pages/create_routine_detail_page.dart';

class SchedulingWidget extends StatelessWidget {
  final SchedulingType? schedulingType;
  final TimeOfDay? selectedTime;
  final FrequencyType? selectedFrequency;
  final DateTime? selectedDate;
  final bool isDayLong;
  final bool reminderEnabled;
  final Function(SchedulingType)? onSchedulingTypeChanged;
  final Function(FrequencyType)? onFrequencyChanged;
  final Function(TimeOfDay)? onTimeChanged;
  final Function(DateTime)? onDateChanged;
  final Function(bool)? onDayLongChanged;
  final Function(bool)? onReminderChanged;
  final Function(List<int>)? onWeekDaysChanged;
  final List<int>? selectedWeekDays;
  final ThemeData theme;
  final ColorPallete palette;

  const SchedulingWidget({
    super.key,
    required this.schedulingType,
    required this.selectedFrequency,
    required this.selectedTime,
    required this.selectedDate,
    required this.isDayLong,
    required this.reminderEnabled,
    required this.theme,
    required this.palette,
    this.onSchedulingTypeChanged,
    this.onFrequencyChanged,
    this.onTimeChanged,
    this.onDateChanged,
    this.onDayLongChanged,
    this.onReminderChanged,
    this.onWeekDaysChanged,
    this.selectedWeekDays,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Faça o agendamento',
            style: LelloTextStyles.bodyBold(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 16),

          // Scheduling type selection chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SchedulingType.values.map((type) {
              final isSelected = schedulingType == type;
              return _buildSchedulingTypeChip(
                type: type,
                isSelected: isSelected,
                onTap: () => onSchedulingTypeChanged?.call(type),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Conditional content based on selected scheduling type
          _buildSchedulingOptions(context),
        ],
      ),
    );
  }

  Widget _buildSchedulingTypeChip({
    required SchedulingType type,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final label = _getSchedulingTypeLabel(type);
    final color = isSelected ? palette.primary() : Colors.grey.shade500;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: color,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: LelloTextStyles.body(theme)?.copyWith(
            color: isSelected ? Colors.white : color,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildFromTodayOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day long toggle
        _buildToggleOption(
          title: 'Dia inteiro',
          value: isDayLong,
          onChanged: onDayLongChanged ?? (value) {},
        ),

        const SizedBox(height: 16),

        // Time selection (only if not day long)
        if (!isDayLong) ...[
          _buildTimeSelector(context),
          const SizedBox(height: 16),
        ],

        // Frequency selection with conditional weekly day selection
        _buildFromTodayFrequencyField(context),
      ],
    );
  }

  Widget _buildScheduleStartOptions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date selection
        _buildDateSelector(context),

        const SizedBox(height: 16),

        // Day long toggle
        _buildToggleOption(
          title: 'Dia inteiro',
          value: isDayLong,
          onChanged: onDayLongChanged ?? (value) {},
        ),

        const SizedBox(height: 16),

        // Time selection (only if not day long)
        if (!isDayLong) ...[
          _buildTimeSelector(context),
          const SizedBox(height: 16),
        ],

        // Frequency selection with conditional weekly day selection and alerts
        _buildScheduleStartFrequencyField(context),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildToggleOption({
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: LelloTextStyles.body(theme)?.copyWith(
            color: palette.text(),
            fontSize: 16,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: palette.primary(),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data de início',
          style: LelloTextStyles.bodyBold(theme)?.copyWith(
            color: palette.text(),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDate(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: palette.separator()),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: palette.textLight(),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? _formatDate(selectedDate!)
                        : 'Selecione',
                    style: LelloTextStyles.body(theme)?.copyWith(
                      color: selectedDate != null
                          ? palette.text()
                          : palette.textLight(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSelector(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Horário do check-in',
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 4,
          child: DropdownButtonFormField<TimeOfDay>(
            value: selectedTime,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.primary()),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.access_time,
                color: palette.textLight(),
                size: 20,
              ),
            ),
            hint: Text(
              'Selecione',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.textLight(),
              ),
            ),
            items: _getAvailableTimes().map((TimeOfDay time) {
              return DropdownMenuItem<TimeOfDay>(
                value: time,
                child: Text(
                  _formatTime(time),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: palette.text(),
                  ),
                ),
              );
            }).toList(),
            onChanged: (TimeOfDay? newTime) {
              if (newTime != null) {
                onTimeChanged?.call(newTime);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencyDropdown(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Text(
            'Frequência',
            style: LelloTextStyles.body(theme)?.copyWith(
              color: palette.text(),
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: DropdownButtonFormField<FrequencyType>(
            value: selectedFrequency,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.separator()),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: palette.primary()),
              ),
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(
                Icons.repeat,
                color: palette.textLight(),
                size: 20,
              ),
            ),
            hint: Text(
              'Selecione',
              style: LelloTextStyles.body(theme)?.copyWith(
                color: palette.textLight(),
              ),
            ),
            items: FrequencyType.values.map((FrequencyType frequency) {
              return DropdownMenuItem<FrequencyType>(
                value: frequency,
                child: Text(
                  _getFrequencyLabel(frequency),
                  style: LelloTextStyles.body(theme)?.copyWith(
                    color: palette.text(),
                  ),
                ),
              );
            }).toList(),
            onChanged: (FrequencyType? newFrequency) {
              if (newFrequency != null) {
                onFrequencyChanged?.call(newFrequency);
              }
            },
          ),
        ),
      ],
    );
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: palette.primary(),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      onDateChanged?.call(picked);
    }
  }

  List<TimeOfDay> _getAvailableTimes() {
    final times = <TimeOfDay>[];

    // Gera horários de 08:00 às 18:00 com intervalos de 15 minutos
    for (int hour = 8; hour <= 18; hour++) {
      for (int minute = 0; minute < 60; minute += 15) {
        times.add(TimeOfDay(hour: hour, minute: minute));
      }
    }

    return times;
  }

  String _getSchedulingTypeLabel(SchedulingType type) {
    switch (type) {
      case SchedulingType.fromToday:
        return 'A partir de hoje';
      case SchedulingType.scheduleStart:
        return 'Agendar início';
    }
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildSchedulingOptions(BuildContext context) {
    if (schedulingType == SchedulingType.fromToday) {
      return _buildFromTodayOptions(context);
    } else if (schedulingType == SchedulingType.scheduleStart) {
      return _buildScheduleStartOptions(context);
    }
    return const SizedBox.shrink();
  }

  Widget _buildFromTodayFrequencyField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frequency dropdown (always editable)
        _buildFrequencyDropdown(context),

        // Show weekly day selection if frequency is weekly
        if (selectedFrequency == FrequencyType.weekly) ...[
          const SizedBox(height: 16),
          _buildWeeklyDaySelection(context),
        ],

        // Show informative messages for monthly and yearly frequencies
        if (selectedFrequency == FrequencyType.monthly) ...[
          const SizedBox(height: 16),
          _buildFrequencyInfoMessage(_getMonthlyMessage()),
        ],

        if (selectedFrequency == FrequencyType.yearly) ...[
          const SizedBox(height: 16),
          _buildFrequencyInfoMessage(_getYearlyMessage()),
        ],
      ],
    );
  }

  Widget _buildScheduleStartFrequencyField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Frequency dropdown (always editable)
        _buildFrequencyDropdown(context),

        // Show weekly day selection if frequency is weekly
        if (selectedFrequency == FrequencyType.weekly) ...[
          const SizedBox(height: 16),
          _buildWeeklyDaySelection(context),
        ],

        // Show informative messages for monthly and yearly frequencies
        if (selectedFrequency == FrequencyType.monthly) ...[
          const SizedBox(height: 16),
          _buildFrequencyInfoMessage(_getScheduleStartMonthlyMessage()),
        ],

        if (selectedFrequency == FrequencyType.yearly) ...[
          const SizedBox(height: 16),
          _buildFrequencyInfoMessage(_getScheduleStartYearlyMessage()),
        ],
      ],
    );
  }

  String _getMonthlyMessage() {
    final now = DateTime.now();
    return 'Está rotina será programada todo dia ${now.day}.';
  }

  String _getYearlyMessage() {
    final now = DateTime.now();
    final months = [
      'janeiro',
      'fevereiro',
      'março',
      'abril',
      'maio',
      'junho',
      'julho',
      'agosto',
      'setembro',
      'outubro',
      'novembro',
      'dezembro'
    ];
    final monthName = months[now.month - 1];
    return 'Está rotina será programada todo dia ${now.day} do mês de $monthName.';
  }

  String _getScheduleStartMonthlyMessage() {
    if (selectedDate != null) {
      return 'Está rotina será programada todo dia ${selectedDate!.day}.';
    }
    return 'Está rotina será programada mensalmente na data selecionada.';
  }

  String _getScheduleStartYearlyMessage() {
    if (selectedDate != null) {
      final months = [
        'janeiro',
        'fevereiro',
        'março',
        'abril',
        'maio',
        'junho',
        'julho',
        'agosto',
        'setembro',
        'outubro',
        'novembro',
        'dezembro'
      ];
      final monthName = months[selectedDate!.month - 1];
      return 'Está rotina será programada todo dia ${selectedDate!.day} do mês de $monthName.';
    }
    return 'Está rotina será programada anualmente na data selecionada.';
  }

  Widget _buildFrequencyInfoMessage(String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(
            Icons.info,
            color: Colors.red.shade600,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: LelloTextStyles.bodyBold(theme)?.copyWith(
                color: palette.grey(),
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyDaySelection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecione os dias da semana:',
          style: LelloTextStyles.body(theme)?.copyWith(
            color: palette.text(),
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildDayButton('Dom', 0),
            _buildDayButton('Seg', 1),
            _buildDayButton('Ter', 2),
            _buildDayButton('Qua', 3),
            _buildDayButton('Qui', 4),
            _buildDayButton('Sex', 5),
            _buildDayButton('Sab', 6),
          ],
        ),
      ],
    );
  }

  Widget _buildDayButton(String label, int dayIndex) {
    final isSelected = selectedWeekDays?.contains(dayIndex) ?? false;

    return GestureDetector(
      onTap: () {
        if (onWeekDaysChanged != null) {
          final currentDays = List<int>.from(selectedWeekDays ?? []);
          if (isSelected) {
            currentDays.remove(dayIndex);
          } else {
            currentDays.add(dayIndex);
          }
          onWeekDaysChanged!(currentDays);
        }
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isSelected ? palette.primary() : Colors.transparent,
          border: Border.all(
            color: isSelected ? palette.primary() : palette.separator(),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: LelloTextStyles.body(theme)?.copyWith(
              color: isSelected ? Colors.white : palette.text(),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
