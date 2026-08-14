import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_occurrence_controller.dart';
import 'package:shared_features/core/modal/month_picker.dart';

class TimesheetOccurrenceDrawer extends StatefulWidget {
  final TimesheetOccurrenceController controller;
  final List<TimesheetPeriods> dateList;
  const TimesheetOccurrenceDrawer({
    super.key,
    required this.dateList,
    required this.controller,
  });

  @override
  State<TimesheetOccurrenceDrawer> createState() =>
      _TimesheetOccurrenceDrawerState();
}

class _TimesheetOccurrenceDrawerState extends State<TimesheetOccurrenceDrawer> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Drawer(
      child: Container(
        color: const Color(0xFF2D2D2D),
        child: ListView(
          padding: EdgeInsets.only(top: Dimens.spacingMedium)
              .copyWith(top: Dimens.spacingXLarge),
          children: [
            ListTile(
                title: Text(getString(context, "payment_filter_title"),
                    style: LelloTextStyles.title(LelloTheme.dark)),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )),
            BlocConsumer(
              bloc: widget.controller.bloc,
              listener: (context, state) {},
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(getString(context, "payroll_month"),
                            style: LelloTextStyles.bodyBold(theme)!
                                .copyWith(color: Colors.white)),
                        SizedBox(height: Dimens.spacing),
                        InkWell(
                          onTap: () async {
                            var select = await showMonthPicker(
                              context: context,
                              initialDate: widget.controller.filterSelectDate ??
                                  widget.controller.selectDate,
                              firstDate: widget.dateList.last.periodMonth,
                              lastDate: widget.dateList.first.periodMonth,
                            );
                            if (select != null) {
                              setState(() {
                                widget.controller.filterSelectDate = select;
                              });
                            }
                          },
                          child: Container(
                            height: 70.0,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(6.0)),
                                border: Border.all(color: Colors.white)),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      widget.controller.filterSelectDate == null
                                          ? '${transformDateInText(widget.controller.selectDate)}'
                                          : '${transformDateInText(widget.controller.filterSelectDate!)}',
                                      style: LelloTextStyles.bodyBold(theme)!
                                          .copyWith(color: Colors.white)),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.white),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(getString(context, "gdp_payslip_employee"),
                            style: LelloTextStyles.bodyBold(theme)!
                                .copyWith(color: Colors.white)),
                        SizedBox(height: Dimens.spacing),
                        Container(
                          height: 70.0,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            border: Border.all(color: Colors.white),
                          ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: widget.controller.filterSelectedEmployee,
                            dropdownColor: const Color(0xFF2D2D2D),
                            style: LelloTextStyles.bodyBold(theme)!
                                .copyWith(color: Colors.white),
                            hint: Text(
                              getString(context, "gdp_timesheet_select"),
                              style: LelloTextStyles.body(theme)!
                                  .copyWith(color: Colors.white),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                            items: widget.controller.employeesNames
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                widget.controller.filterSelectedEmployee =
                                    value;
                              });
                            },
                            decoration: _borderDecoration(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                            getString(context, "gdp_timesheet_occurrence_type"),
                            style: LelloTextStyles.bodyBold(theme)!
                                .copyWith(color: Colors.white)),
                        SizedBox(height: Dimens.spacing),
                        Container(
                          height: 70.0,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            border: Border.all(color: Colors.white),
                          ),
                          child: DropdownButtonFormField(
                            isExpanded: true,
                            value: widget.controller.filterSelectedType,
                            dropdownColor: const Color(0xFF2D2D2D),
                            style: LelloTextStyles.bodyBold(theme)!
                                .copyWith(color: Colors.white),
                            hint: Text(
                              getString(context, "gdp_timesheet_select"),
                              style: LelloTextStyles.body(theme)!
                                  .copyWith(color: Colors.white),
                            ),
                            icon: const Icon(Icons.keyboard_arrow_down,
                                color: Colors.white),
                            items: widget.controller.filterTypes.values
                                .map((value) => DropdownMenuItem(
                                      value: value,
                                      child: Text(value),
                                    ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                widget.controller.filterSelectedType = value;
                              });
                            },
                            decoration: _borderDecoration(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        PrimaryButton(
                            text: getString(context, "find"),
                            onPressed: widget.controller.filterSelectedType !=
                                        null ||
                                    widget.controller.filterSelectDate !=
                                        null ||
                                    widget.controller.filterSelectedEmployee !=
                                        null
                                ? () {
                                    Navigator.pop(context);
                                    widget.controller.filterList();
                                  }
                                : null),
                        SizedBox(height: Dimens.spacing),
                        SecondaryButton(
                          buttonBorderColor: Colors.white,
                          text: getString(context, "report_clear_filters"),
                          onPressed: () {
                            setState(() {
                              widget.controller.filterSelectDate = null;
                              widget.controller.filterSelectedEmployee = null;
                              widget.controller.filterSelectedType = null;
                            });
                            widget.controller.clearFilter();
                            Navigator.pop(context);
                          },
                        ),
                      ]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _borderDecoration() {
    return const InputDecoration(
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent)));
  }

  transformDateInText(DateTime date) {
    var format = DateFormat.MMMM().format(date);
    return toBeginningOfSentenceCase(format);
  }
}
