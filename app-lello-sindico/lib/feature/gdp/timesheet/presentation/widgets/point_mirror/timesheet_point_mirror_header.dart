import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_point_mirror_controller.dart';

class TimesheetPointMirrorHeaderWidget extends StatefulWidget {
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  final String title;
  final TimesheetPointMirrorController controller;
  const TimesheetPointMirrorHeaderWidget({
    super.key,
    required this.date,
    required this.dateList,
    required this.controller,
    required this.title,
  });

  @override
  State<TimesheetPointMirrorHeaderWidget> createState() =>
      _TimesheetPointMirrorHeaderWidgetState();
}

class _TimesheetPointMirrorHeaderWidgetState
    extends State<TimesheetPointMirrorHeaderWidget> {
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
              initialDate: selectDate ?? widget.date,
              firstDate: widget.dateList.last.periodMonth,
              lastDate: widget.dateList.first.periodMonth,
            );
            if (select != null) {
              setState(() {
                selectDate = select;
              });
              widget.controller.selectDate = select;
              widget.controller.getPointMirrorList(select);
            }
          },
          child: Row(
            children: [
              Text(getString(context, "gdp_timesheet_type_month_analyze"),
                  style: LelloTextStyles.subBody(theme)),
              Text(
                  selectDate != null
                      ? '${transformDateInText(selectDate!)}/${selectDate!.year}'
                      : '${transformDateInText(widget.date)}/${widget.date.year}',
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
