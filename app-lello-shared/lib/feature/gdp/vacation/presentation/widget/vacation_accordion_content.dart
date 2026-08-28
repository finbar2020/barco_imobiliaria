import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/gdp/vacation/domain/entity/vacation_locked_days.dart';
import 'package:shared_features/feature/gdp/vacation/presentation/page/vacation_page.dart';

class AccordionSectionContent extends StatefulWidget {
  final PeriodConfig periodConfig;
  final PeriodConfig? periodConfigPrevious;
  final int periodNumber;
  final DateTime vacationEndDateFormatted;
  final VacationLockedDays? lockedDays;
  final int minFirstDateFromToday;
  AccordionSectionContent(
      {Key? key,
      required this.periodConfig,
      required this.periodConfigPrevious,
      required this.periodNumber,
      required this.vacationEndDateFormatted,
      required this.lockedDays,
      required this.minFirstDateFromToday})
      : super(key: key);

  @override
  State<AccordionSectionContent> createState() =>
      _AccordionSectionContentState();
}

class _AccordionSectionContentState extends State<AccordionSectionContent> {
  @override
  Widget build(BuildContext context) {
    final PeriodConfig periodConfig = widget.periodConfig;
    ThemeData theme = Theme.of(context);

    return Form(
      key: periodConfig.key,
      child: Container(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  getString(context, "gdp_vacation_employee_days"),
                  style: LelloTextStyles.caption(theme)!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimens.spacingSmall),
                Container(
                    alignment: Alignment.topLeft,
                    constraints: BoxConstraints(maxWidth: 150),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 1.0, color: Colors.grey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                    ),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: periodConfig.days.toString(),
                        hintStyle: TextStyle(
                            color: LelloTheme.palleteOf(theme).text()),
                      ),
                    )),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  getString(context, "gdp_vacation_employee_start"),
                  style: LelloTextStyles.caption(theme)!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  autofocus: false,
                  keyboardType: TextInputType.datetime,
                  validator: (valid) {
                    if (periodConfig.start == null) {
                      return getString(context, "validation_required");
                    }
                    return null;
                  },
                  readOnly: true,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(color: LelloTheme.palleteOf(theme).text()),
                    hintText: periodConfig.getStartFormatted == null
                        ? getString(context,
                                "gdp_vacation_employee_select_start_date")
                            .toString()
                        : periodConfig.getStartFormatted.toString(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                  onTap: () async {
                    //FocusScope.of(context).requestFocus(new FocusNode());
                    final date = await datePickerPeriod(context, periodConfig);
                    if (date != null) periodConfig.start = date;
                    // O Accordion recria os States a cada rebuild da página,
                    // então o State pode ter sido descartado durante o
                    // calendário: só atualiza se ainda estiver montado.
                    if (!mounted) return;
                    setState(() {
                      periodConfig.key.currentState?.validate();
                    });
                  },
                ),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  getString(context, "gdp_vacation_employee_end"),
                  style: LelloTextStyles.caption(theme)!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: Dimens.spacingSmall),
                TextFormField(
                  autofocus: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintStyle:
                        TextStyle(color: LelloTheme.palleteOf(theme).text()),
                    hintText: periodConfig.getEndFormatted == null
                        ? ''
                        : periodConfig.getEndFormatted.toString(),
                    suffixIcon: Icon(
                      Icons.calendar_today,
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  Future<DateTime?> datePickerPeriod(
      BuildContext context, PeriodConfig config) async {
    var index = widget.periodNumber;
    var vacationEndDateFormatted = widget.vacationEndDateFormatted;
    var lockedDays = widget.lockedDays;
    var periodConfigPrevious = widget.periodConfigPrevious;

    var vacationEndDateFormattedMax = vacationEndDateFormatted
        .add(Duration(days: 365))
        .subtract(Duration(days: 30));

    late DateTime firstDate;

    switch (index) {
      case 0:
        firstDate = getFirstAlowedDate(
          initialBlock: Duration(days: 1),
          startDate: vacationEndDateFormatted,
          lockedDays: lockedDays,
        );
        break;
      case 1:
        if (periodConfigPrevious != null &&
            periodConfigPrevious.start == null) {
          _showFlushBar();
          return null;
        }
        firstDate = getFirstAlowedDate(
            startDate: periodConfigPrevious!.getEnd,
            initialBlock: Duration(days: 1),
            lockedDays: lockedDays);
        break;
      case 2:
        if (periodConfigPrevious!.start == null) {
          _showFlushBar();
          return null;
        }
        firstDate = getFirstAlowedDate(
            startDate: periodConfigPrevious.getEnd,
            initialBlock: Duration(days: 1),
            lockedDays: lockedDays);
        break;
      default:
        return null;
    }

    //não da para exibir calendario pois data inicial é maior que data limite
    if (firstDate.isAfter(vacationEndDateFormattedMax)) {
      showFlushDateLimit(context);
      return null;
    }
    final DateTime? picked = await showDatePicker(
        context: context,
        selectableDayPredicate: (DateTime val) {
          String sanitized = sanitizeDateTime(val);
          return !(lockedDays?.locked_days.contains(sanitized) ?? false);
        },
        initialDate: firstDate,
        firstDate: firstDate,
        lastDate: vacationEndDateFormattedMax);
    if (picked != null) return picked;
    return null;
  }

  Flushbar? flush;
  void showFlushDateLimit(BuildContext context) {
    if (flush != null) {
      flush!.dismiss();
    }
    flush = Flushbar(
      message: getString(context, "gdp_vacation_date_limit"),
      isDismissible: true,
      duration: Duration(seconds: 30),
      onTap: (flush) {
        flush.dismiss();
      },
    )..show(context);
  }

  String sanitizeDateTime(DateTime dateTime) =>
      "${dateTime.year}-${dateTime.month.toString().padLeft(2, "0")}-${dateTime.day.toString().padLeft(2, "0")}";

  void _showFlushBar() {
    Flushbar(
        duration: Duration(seconds: 3),
        message: getString(context, "gdp_vacation_not_possible_assign_date"))
      ..show(context);
  }

  DateTime getFirstAlowedDate(
      {Duration? initialBlock,
      VacationLockedDays? lockedDays,
      DateTime? startDate}) {
    var initialDate = startDate ?? DateTime.now();

    //verifica se data inicial esta anterior ao limite minimo de x dias apartir de hoje
    if (initialDate.isBefore(
        DateTime.now().add(Duration(days: widget.minFirstDateFromToday))))
      initialDate =
          DateTime.now().add(Duration(days: widget.minFirstDateFromToday));

    //adiciona limitador de d+x
    if (initialBlock != null) {
      initialDate = initialDate.add(initialBlock);
    }

    //busca primeira data que não coincide com as bloqueadas por folga e feriado
    if (lockedDays != null && lockedDays.locked_days.length > 0) {
      while (lockedDays.locked_days.contains(sanitizeDateTime(initialDate))) {
        initialDate = initialDate.add(Duration(days: 1));
      }
    }
    return initialDate;
  }
}
