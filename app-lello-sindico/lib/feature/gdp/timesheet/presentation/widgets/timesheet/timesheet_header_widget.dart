import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';

class TimesheetHeaderWidget extends StatefulWidget {
  final String title;
  final List<TimesheetPeriods> dateList;
  final TimesheetController controller;
  const TimesheetHeaderWidget({
    super.key,
    required this.dateList,
    required this.controller,
    required this.title,
  });

  @override
  State<TimesheetHeaderWidget> createState() => _TimesheetHeaderWidgetState();
}

class _TimesheetHeaderWidgetState extends State<TimesheetHeaderWidget> {
  DateTime? selectDate;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: LelloTextStyles.bodyBold(theme)),
        SizedBox(height: Dimens.spacing),
        InkWell(
          onTap: () async {
            var select = await showMonthPicker(
              context: context,
              initialDate: selectDate ?? widget.controller.selectedDate,
              firstDate: widget.dateList.last.periodMonth,
              lastDate: widget.dateList.first.periodMonth,
            );
            if (select != null) {
              setState(() {
                selectDate = select;
              });
              widget.controller.selectedDate = select;
              widget.controller.getList(select);
            }
          },
          child: Row(
            children: [
              Text(getString(context, "gdp_timesheet_type_month_analyze"),
                  style: LelloTextStyles.subBody(theme)),
              Text(
                  selectDate != null
                      ? '${transformDateInText(selectDate!)}/${selectDate!.year}'
                      : '${transformDateInText(widget.controller.selectedDate)}/${widget.controller.selectedDate.year}',
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: LelloTheme.palleteOf(theme).hubText(),
                  )),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ],
    );
  }

  transformDateInText(DateTime date) {
    var format = DateFormat.MMMM().format(date);
    return toBeginningOfSentenceCase(format);
  }
}
