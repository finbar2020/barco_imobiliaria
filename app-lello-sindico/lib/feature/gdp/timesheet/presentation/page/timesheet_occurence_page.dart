import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_occurrence/timesheet_occurrence_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_occurrence_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/occurrences/timesheet_occurrence_drawer.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/occurrences/timesheet_occurrence_dropdown.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/occurrences/timesheet_occurrence_widget.dart';

class TimesheetOccurrencePage extends StatefulWidget {
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  final String? numCra;
  final TimesheetOccurrenceTypeEnum? initialFilter;
  const TimesheetOccurrencePage({
    super.key,
    required this.date,
    this.numCra,
    this.initialFilter,
    required this.dateList,
  });

  @override
  State<TimesheetOccurrencePage> createState() =>
      _TimesheetOccurrencePageState();
}

class _TimesheetOccurrencePageState extends State<TimesheetOccurrencePage> {
  TimesheetOccurrenceController controller =
      ApplicationContainer.instance().resolve<TimesheetOccurrenceController>();

  bool selectAll = false;
  String? selectedValue;

  @override
  void initState() {
    if (widget.initialFilter != null) {
      controller.filterSelectedType =
          controller.filterTypes[widget.initialFilter];
      controller.filterList();
    } else {
      controller.getOccurrences(null, widget.date, widget.numCra);
    }

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    controller.bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      endDrawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TimesheetOccurrenceDrawer(
            controller: controller,
            dateList: widget.dateList,
          )),
      appBar: PrimaryAppBar(
        iconColor: theme.primaryColor,
        theme: theme,
        title: getString(context, "notification_preferences_occurrence"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(getString(context, "notification_preferences_occurrence"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacingSmall),
            BlocConsumer(
              bloc: controller.bloc,
              listener: (context, state) {},
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            getString(
                                context, "gdp_timesheet_type_month_analyze"),
                            style: LelloTextStyles.subBody(theme)),
                        Text(
                            '${transformDateInText(controller.selectDate)}/${controller.selectDate.year}',
                            style: LelloTextStyles.subBody(theme)!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: LelloTheme.palleteOf(theme).hubText(),
                            )),
                      ],
                    ),
                    if (state is TimesheetOccurrenceLoadedState &&
                        (state.employeeFiltered != null ||
                            state.typeFiltered != null))
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: Dimens.spacing),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (state.typeFiltered != null)
                                    InkWell(
                                      onTap: () {
                                        controller.filterSelectedType = null;
                                        controller.filterList();
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFD9D9D9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: Row(children: [
                                              Text(
                                                state.typeFiltered!,
                                                style: LelloTextStyles.bodyBold(
                                                    theme),
                                              ),
                                              SizedBox(
                                                  width: Dimens.spacingSmall),
                                              const Icon(
                                                Icons.close,
                                                color: Color(0xFF989898),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                  if (state.typeFiltered != null)
                                    SizedBox(width: Dimens.spacing),
                                  if (state.employeeFiltered != null)
                                    InkWell(
                                      onTap: () {
                                        controller.filterSelectedEmployee =
                                            null;
                                        controller.filterList();
                                      },
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Color(0xFFD9D9D9),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25.0))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Center(
                                            child: Row(children: [
                                              Text(
                                                state.employeeFiltered!,
                                                style: LelloTextStyles.bodyBold(
                                                    theme),
                                              ),
                                              SizedBox(
                                                  width: Dimens.spacingSmall),
                                              const Icon(
                                                Icons.close,
                                                color: Color(0xFF989898),
                                              ),
                                            ]),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          if (state.typeFiltered?.contains("Hora") == false &&
                              state.list.isNotEmpty)
                            SizedBox(height: Dimens.spacing),
                          if (state.typeFiltered?.contains("Hora") == false &&
                              state.list.isNotEmpty)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                selectAll
                                    ? Row(
                                        children: [
                                          Checkbox(
                                              value: selectAll,
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectAll = false;
                                                  selectedValue = null;
                                                });
                                              }),
                                          Text(
                                              getString(context,
                                                  "gdp_timesheet_detail_select"),
                                              style: LelloTextStyles.subBody(
                                                      theme)!
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black)),
                                        ],
                                      )
                                    : InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectAll = true;
                                            controller.employesSelecteds =
                                                List.generate(state.list.length,
                                                    (index) => true);
                                            controller.individualAction =
                                                List.generate(state.list.length,
                                                    (index) => '');
                                          });
                                        },
                                        child: Text(
                                            getString(context,
                                                "gdp_timesheet_detail_select"),
                                            style:
                                                LelloTextStyles.subBody(theme)!
                                                    .copyWith(
                                              color: theme.primaryColor,
                                            )),
                                      ),
                                if (selectAll)
                                  TimesheetOccurrenceDropdown(
                                    items: controller
                                        .dropdownItems(state.typeFiltered!),
                                    width: selectedValue != null
                                        ? state.typeFiltered!.contains("Folga")
                                            ? 200.0
                                            : 145.0
                                        : 170.0,
                                    hintText: getString(context,
                                        "gdp_timesheet_detail_mass_action"),
                                    selectedValue: selectedValue,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedValue = value;
                                      });
                                    },
                                  ),
                              ],
                            ),
                        ],
                      ),
                  ],
                );
              },
            ),
            SizedBox(height: Dimens.spacing),
            TimesheetOccurrenceWidget(
              date: widget.date,
              controller: controller,
              selectAll: selectAll,
              selectedValue: selectedValue,
            ),
          ],
        ),
      ),
    );
  }

  void _nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  transformDateInText(DateTime date) {
    var format = DateFormat.MMMM().format(date);
    return toBeginningOfSentenceCase(format);
  }
}
