import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/detail_list_controller.dart';

class TimesheetListDetailsHeaderWidget extends StatefulWidget {
  final TextEditingController controller;
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  final String title;
  final ListDetailsController detailController;
  final TimesheetOccurrenceTypeEnum type;
  const TimesheetListDetailsHeaderWidget({
    super.key,
    required this.date,
    required this.dateList,
    required this.controller,
    required this.title,
    required this.detailController,
    required this.type,
  });

  @override
  State<TimesheetListDetailsHeaderWidget> createState() =>
      _TimesheetListDetailsHeaderWidgetState();
}

class _TimesheetListDetailsHeaderWidgetState
    extends State<TimesheetListDetailsHeaderWidget> {
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
                lastDate: widget.dateList.first.periodMonth);

            if (select != null) {
              setState(() {
                selectDate = select;
              });
              widget.detailController.getDelayList(widget.type, select);
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
        SizedBox(height: Dimens.spacing),
        TextField(
          onSubmitted: (value) {
            widget.detailController.searchCollaborator(widget.type);
          },
          onChanged: (value) {
            widget.detailController.searchCollaborator(widget.type);
          },
          controller: widget.controller,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimens.spacing,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        widget.controller.clear();
                        widget.detailController.searchCollaborator(widget.type);
                      },
                      child: const Icon(
                        Icons.close,
                      ),
                    ),
                  ],
                ),
              ),
              hintText: "Buscar por funcionário"),
        ),
      ],
    );
  }

  transformDateInText(DateTime date) {
    var format = DateFormat.MMMM().format(date);
    return toBeginningOfSentenceCase(format);
  }
}
