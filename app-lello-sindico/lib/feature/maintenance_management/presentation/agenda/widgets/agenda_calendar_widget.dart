import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:shimmer/shimmer.dart';
import '../bloc/calendar_indicators_bloc.dart';
import '../bloc/calendar_indicators_state.dart';
import '../bloc/calendar_indicators_event.dart';
import '../../../domain/entity/filter_options_entity.dart';

class AgendaCalendarWidget extends StatefulWidget {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final CalendarFormat calendarFormat;
  final Function(DateTime, DateTime) onDaySelected;
  final Function(CalendarFormat) onFormatChanged;
  final Function(DateTime) onPageChanged;
  final bool isExpanded;
  final VoidCallback onToggleExpansion;
  final FilterOptionsEntity? appliedFilters;

  const AgendaCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.selectedDay,
    required this.calendarFormat,
    required this.onDaySelected,
    required this.onFormatChanged,
    required this.onPageChanged,
    required this.isExpanded,
    required this.onToggleExpansion,
    this.appliedFilters,
  });

  @override
  State<AgendaCalendarWidget> createState() => _AgendaCalendarWidgetState();
}

class _AgendaCalendarWidgetState extends State<AgendaCalendarWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);

    return Container(
      width: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<CalendarIndicatorsBloc, CalendarIndicatorsState>(
            builder: (context, indicatorsState) {
              if (indicatorsState is CalendarIndicatorsLoadingState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCustomHeader(context, theme, pallete),
                    _buildCalendarShimmer(theme, pallete),
                  ],
                );
              }

              if (indicatorsState is CalendarIndicatorsErrorState) {
                return Container(
                  height: 400,
                  padding: const EdgeInsets.all(16),
                  child: ErrorHandlingWidget(
                    isProduction: false,
                    error: indicatorsState.message,
                    errorCode: "CALENDAR_INDICATORS_ERROR",
                    title: "error_handling_widget_title",
                    subTitle:
                        "Não foi possível carregar os indicadores do calendário. Verifique sua conexão e tente novamente.",
                    reTryFunction: () {
                      context.read<CalendarIndicatorsBloc>().add(
                            LoadCalendarIndicatorsEvent(
                              month: indicatorsState.month,
                              year: indicatorsState.year,
                              appliedFilters: widget.appliedFilters,
                            ),
                          );
                    },
                    backFunction: () {
                      context.read<CalendarIndicatorsBloc>().add(
                            LoadCalendarIndicatorsEvent(
                              month: widget.focusedDay.month,
                              year: widget.focusedDay.year,
                              appliedFilters: widget.appliedFilters,
                            ),
                          );
                    },
                  ),
                );
              }

              if (indicatorsState is CalendarIndicatorsInitialState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCustomHeader(context, theme, pallete),
                    _buildCalendarWithMessage(
                      theme,
                      pallete,
                      indicatorsState,
                      "Toque em 'Tentar novamente' para carregar os indicadores",
                      Icons.info_outline,
                      Colors.blue,
                    ),
                  ],
                );
              }

              if (indicatorsState is CalendarIndicatorsEmptyState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildCustomHeader(context, theme, pallete),
                    _buildCalendarWithMessage(
                      theme,
                      pallete,
                      indicatorsState,
                      "Nenhum evento encontrado para este mês",
                      Icons.event_busy,
                      Colors.grey,
                    ),
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCustomHeader(context, theme, pallete),
                  TableCalendar<dynamic>(
                    locale: 'pt_BR',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: widget.focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(widget.selectedDay, day);
                    },
                    calendarFormat: widget.calendarFormat,
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Mês',
                      CalendarFormat.week: 'Semana',
                    },
                    availableGestures: AvailableGestures.horizontalSwipe,
                    onFormatChanged: widget.onFormatChanged,
                    onDaySelected: widget.onDaySelected,
                    onPageChanged: (focusedDay) {
                      widget.onPageChanged(focusedDay);
                    },
                    enabledDayPredicate: (day) => day.day <= 30,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    headerVisible: false,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: LelloTextStyles.caption(theme)?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: pallete.grey(),
                          ) ??
                          const TextStyle(),
                      weekendStyle: LelloTextStyles.caption(theme)?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: pallete.grey(),
                          ) ??
                          const TextStyle(),
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: pallete.primary().withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      todayTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: pallete.primary(),
                        shape: BoxShape.circle,
                      ),
                      selectedTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      defaultTextStyle: LelloTextStyles.body(theme)?.copyWith(
                            color: pallete.text(),
                          ) ??
                          const TextStyle(),
                      weekendTextStyle: LelloTextStyles.body(theme)?.copyWith(
                            color: pallete.text(),
                          ) ??
                          const TextStyle(),
                      outsideTextStyle: LelloTextStyles.body(theme)?.copyWith(
                            color: pallete.grey().withOpacity(0.6),
                          ) ??
                          const TextStyle(),
                      disabledTextStyle: LelloTextStyles.body(theme)?.copyWith(
                            color: pallete.grey().withOpacity(0.4),
                          ) ??
                          const TextStyle(),
                      outsideDaysVisible: false,
                      cellMargin: const EdgeInsets.all(4),
                      cellPadding: const EdgeInsets.all(0),
                      markersMaxCount: 3,
                      canMarkersOverflow: false,
                      defaultDecoration: const BoxDecoration(),
                      weekendDecoration: const BoxDecoration(),
                      outsideDecoration: const BoxDecoration(),
                      disabledDecoration: const BoxDecoration(),
                    ),
                    rowHeight: widget.isExpanded ? 44 : 38,
                    daysOfWeekHeight: 32,
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        return Center(
                          child: Text(
                            _weekdayInitial(day.weekday),
                            style: LelloTextStyles.caption(theme)?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: pallete.grey(),
                                ) ??
                                const TextStyle(),
                          ),
                        );
                      },
                      disabledBuilder: (context, day, focusedDay) {
                        if (day.day > 30) {
                          return const SizedBox.shrink();
                        }
                        return _buildDayCell(
                            day, indicatorsState, theme, pallete, false, false);
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        return _buildDayCell(
                            day, indicatorsState, theme, pallete, false, false);
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return _buildDayCell(
                            day, indicatorsState, theme, pallete, true, false);
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return _buildDayCell(
                            day, indicatorsState, theme, pallete, false, true);
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        return _buildDayCell(
                            day, indicatorsState, theme, pallete, false, false,
                            isOutside: true);
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          _buildDragHandle(),
        ],
      ),
    );
  }

  Widget _buildDragHandle() {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onToggleExpansion,
      child: Container(
        width: double.infinity,
        color: Colors.white,
        constraints: const BoxConstraints(minHeight: 36),
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Center(
          child: Container(
            width: 90,
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(999),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomHeader(
      BuildContext context, ThemeData theme, ColorPallete pallete) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _navigateToPreviousMonth(),
            icon: Icon(
              Icons.chevron_left,
              color: pallete.text(),
              size: 24,
            ),
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: EdgeInsets.zero,
          ),
          Flexible(
            child: _buildMonthYearDropdown(context, theme, pallete),
          ),
          IconButton(
            onPressed: () => _navigateToNextMonth(),
            icon: Icon(
              Icons.chevron_right,
              color: pallete.text(),
              size: 24,
            ),
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }

  Widget _buildMonthYearDropdown(
      BuildContext context, ThemeData theme, ColorPallete pallete) {
    final currentMonth =
        DateFormat("MMMM 'de' yyyy", 'pt_BR').format(widget.focusedDay);

    return PopupMenuButton<DateTime>(
      onSelected: (DateTime selectedDate) {
        widget.onPageChanged(selectedDate);
      },
      itemBuilder: (BuildContext context) {
        return _generatePopupMenuItems(theme, pallete);
      },
      position: PopupMenuPosition.under,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Colors.white,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _capitalizeMonthName(currentMonth),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontStyle: FontStyle.normal,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  List<PopupMenuEntry<DateTime>> _generatePopupMenuItems(
      ThemeData theme, ColorPallete pallete) {
    final List<PopupMenuEntry<DateTime>> items = [];
    final focusedDate = widget.focusedDay;

    for (int i = -6; i <= 6; i++) {
      final date = DateTime(focusedDate.year, focusedDate.month + i, 1);
      final isSelected =
          date.year == focusedDate.year && date.month == focusedDate.month;

      items.add(
        PopupMenuItem<DateTime>(
          value: date,
          child: Text(
            _capitalizeMonthName(
                DateFormat("MMMM 'de' yyyy", 'pt_BR').format(date)),
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ),
      );
    }

    return items;
  }

  String _capitalizeMonthName(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  void _navigateToPreviousMonth() {
    final previousMonth = DateTime(
      widget.focusedDay.year,
      widget.focusedDay.month - 1,
      1,
    );
    widget.onPageChanged(previousMonth);
  }

  void _navigateToNextMonth() {
    final nextMonth = DateTime(
      widget.focusedDay.year,
      widget.focusedDay.month + 1,
      1,
    );
    widget.onPageChanged(nextMonth);
  }

  Widget _buildDayCell(
    DateTime day,
    CalendarIndicatorsState indicatorsState,
    ThemeData theme,
    ColorPallete pallete,
    bool isToday,
    bool isSelected, {
    bool isOutside = false,
  }) {
    final dayNumber = day.day;
    bool hasTasks = false;

    if (indicatorsState is CalendarIndicatorsLoadedState) {
      hasTasks = indicatorsState.hasTasks(dayNumber);
    }

    Color? backgroundColor;
    Color textColor;

    if (isSelected) {
      backgroundColor = pallete.primary();
      textColor = Colors.white;
    } else if (isToday) {
      backgroundColor = pallete.primary().withOpacity(0.7);
      textColor = Colors.white;
    } else {
      backgroundColor = null;
      textColor = isOutside ? pallete.grey().withOpacity(0.6) : pallete.text();
    }

    return Container(
      margin: const EdgeInsets.all(4),
      decoration: isSelected
          ? BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(6),
            )
          : BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
      child: Stack(
        children: [
          Center(
            child: Text(
              '$dayNumber',
              style: LelloTextStyles.body(theme)?.copyWith(
                    color: textColor,
                    fontWeight: isToday || isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ) ??
                  TextStyle(color: textColor),
            ),
          ),
          if (hasTasks && !isSelected && !isToday)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCalendarShimmer(ThemeData theme, ColorPallete pallete) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                7,
                (index) => Container(
                  width: 30,
                  height: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          ...List.generate(
            6,
            (weekIndex) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  7,
                  (dayIndex) => Container(
                    width: 35,
                    height: 35,
                    margin: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: pallete.primary(),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "Carregando indicadores...",
                  style: LelloTextStyles.caption(theme)?.copyWith(
                    color: pallete.grey(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarWithMessage(
    ThemeData theme,
    ColorPallete pallete,
    CalendarIndicatorsState indicatorsState,
    String message,
    IconData icon,
    Color iconColor,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: iconColor.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: iconColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: LelloTextStyles.caption(theme)?.copyWith(
                        color: iconColor,
                      ) ??
                      const TextStyle(),
                ),
              ),
            ],
          ),
        ),
        TableCalendar<dynamic>(
          locale: 'pt_BR',
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: widget.focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(widget.selectedDay, day);
          },
          calendarFormat: widget.calendarFormat,
          availableCalendarFormats: const {
            CalendarFormat.month: 'Mês',
            CalendarFormat.week: 'Semana',
          },
          availableGestures: AvailableGestures.horizontalSwipe,
          onFormatChanged: widget.onFormatChanged,
          onDaySelected: widget.onDaySelected,
          onPageChanged: (focusedDay) {
            widget.onPageChanged(focusedDay);
          },
          enabledDayPredicate: (day) => day.day <= 30,
          startingDayOfWeek: StartingDayOfWeek.monday,
          headerVisible: false,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: LelloTextStyles.caption(theme)?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: pallete.grey(),
                ) ??
                const TextStyle(),
            weekendStyle: LelloTextStyles.caption(theme)?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: pallete.grey(),
                ) ??
                const TextStyle(),
          ),
          calendarStyle: CalendarStyle(
            todayDecoration: BoxDecoration(
              color: pallete.primary().withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            todayTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            selectedDecoration: BoxDecoration(
              color: pallete.primary(),
              shape: BoxShape.circle,
            ),
            selectedTextStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            outsideDaysVisible: false,
            weekendTextStyle: LelloTextStyles.body(theme)?.copyWith(
                  color: pallete.text(),
                ) ??
                const TextStyle(),
            defaultTextStyle: LelloTextStyles.body(theme)?.copyWith(
                  color: pallete.text(),
                ) ??
                const TextStyle(),
          ),
          calendarBuilders: CalendarBuilders(
            dowBuilder: (context, day) {
              return Center(
                child: Text(
                  _weekdayInitial(day.weekday),
                  style: LelloTextStyles.caption(theme)?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: pallete.grey(),
                      ) ??
                      const TextStyle(),
                ),
              );
            },
            disabledBuilder: (context, day, focusedDay) {
              if (day.day > 30) {
                return const SizedBox.shrink();
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  String _weekdayInitial(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'S';
      case DateTime.tuesday:
        return 'T';
      case DateTime.wednesday:
        return 'Q';
      case DateTime.thursday:
        return 'Q';
      case DateTime.friday:
        return 'S';
      case DateTime.saturday:
        return 'S';
      case DateTime.sunday:
        return 'D';
      default:
        return '';
    }
  }
}
