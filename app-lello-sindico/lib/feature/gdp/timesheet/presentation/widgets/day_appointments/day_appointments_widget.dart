import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_day_appointments/timesheet_day_appointments_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/day_appointments_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/day_appointments/day_appointments_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/day_appointments_details/day_appointments_details_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_buttons.dart';
import 'package:shared_features/core/widgets/error_message_widget.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class DayAppointmentsWidget extends StatefulWidget {
  final DayAppointmentsController controller;
  final List<TimesheetPeriods> dateList;
  const DayAppointmentsWidget({
    super.key,
    required this.controller,
    required this.dateList,
  });

  @override
  State<DayAppointmentsWidget> createState() => _DayAppointmentsWidgetState();
}

class _DayAppointmentsWidgetState extends State<DayAppointmentsWidget> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    DateFormat format = DateFormat.yMMMMd();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimens.spacing),
              Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                showDuration: const Duration(seconds: 3),
                margin: const EdgeInsets.symmetric(horizontal: 10),
                message: getString(context, "gdp_timesheet_mark_day_message"),
                child: Row(
                  children: [
                    Text(getString(context, "gdp_timesheet_tab_mark_day"),
                        style: LelloTextStyles.subtitleBold(theme)),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Icon(Icons.info_outline),
                    ),
                  ],
                ),
              ),
              Text(format.format(DateTime.now()),
                  style: LelloTextStyles.subBody(theme)),
              SizedBox(height: Dimens.spacingMedium),
              TextField(
                onSubmitted: (value) {
                  widget.controller.searchCollaborator();
                },
                onChanged: (value) {
                  widget.controller.searchCollaborator();
                },
                controller: widget.controller.searchController,
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
                              widget.controller.searchController.clear();
                              widget.controller.searchCollaborator();
                            },
                            child: const Icon(
                              Icons.close,
                            ),
                          ),
                        ],
                      ),
                    ),
                    hintText: getString(context, 'units_search_tooltip')),
              ),
            ],
          ),
        ),
        BlocBuilder(
            bloc: widget.controller.bloc,
            builder: (context, state) {
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      color: const Color(0xFFC4C4C4),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(showTotal(
                                state as TimesheetDayAppointmentsState)),
                            InkWell(
                              onTap: () {
                                widget.controller.getAppointments();
                              },
                              child: Row(
                                children: [
                                  Text(
                                      "Atualizado em: ${DateFormat.Hm().format(DateTime.now())}"),
                                  SizedBox(width: Dimens.spacingSmall),
                                  showIcon(state, theme),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state is TimesheetDayAppointmentsLoadingState)
                      const Expanded(child: Center(child: LoadingWidget())),
                    if (state is TimesheetDayAppointmentsFailedState)
                      Expanded(
                        child: Center(
                          child: ErrorMessageWidget(
                              message: getString(
                                  context, "agreements_analysis_not_found")),
                        ),
                      ),
                    if (state is TimesheetDayAppointmentsLoadedState)
                      Expanded(
                        child: state.appointments.isEmpty
                            ? Center(
                                child: Text(
                                    getString(context,
                                        "gdp_timesheet_mark_day_dont_find"),
                                    style: LelloTextStyles.subBody(theme)))
                            : ListView.separated(
                                itemCount: state.appointments.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(),
                                itemBuilder: (_, i) {
                                  var item = state.appointments[i];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DayAppointmentsDetailsPage(
                                            item: item,
                                            dayAppointments: state.appointments,
                                          ),
                                        ),
                                      );
                                    },
                                    child: DayAppointmentsCard(
                                        item: item, theme: theme),
                                  );
                                },
                              ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: InkWell(
                        onTap: () {
                          Modal.showBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (context) => SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Mais ações",
                                                style: LelloTextStyles.subBody(
                                                    theme),
                                              ),
                                              Icon(
                                                  Icons
                                                      .keyboard_arrow_down_rounded,
                                                  color: LelloTheme.palleteOf(
                                                          theme)
                                                      .textLight()),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: TimesheetButtons(
                                          date: DateTime.now(),
                                          dateList: widget.dateList,
                                        ),
                                      ),
                                    ],
                                  )));
                        },
                        child: Container(
                          height: 50.0,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color:
                                      LelloTheme.palleteOf(theme).textOpaque()),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0),
                              )),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Mais ações",
                                  style: LelloTextStyles.subBody(theme)!),
                              Icon(Icons.keyboard_arrow_up_rounded,
                                  color:
                                      LelloTheme.palleteOf(theme).textLight()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
      ],
    );
  }

  String showTotal(TimesheetDayAppointmentsState state) {
    if (state is TimesheetDayAppointmentsLoadingState) {
      return "Carregando...";
    } else if (state is TimesheetDayAppointmentsFailedState) {
      return "Total: 0 pessoas";
    } else if (state is TimesheetDayAppointmentsLoadedState) {
      return "Total: ${state.appointments.length} pessoas";
    } else {
      return "Carregando...";
    }
  }

  Widget showIcon(TimesheetDayAppointmentsState state, ThemeData theme) {
    if (state is TimesheetDayAppointmentsLoadingState) {
      return const SizedBox(
          height: 15.0, width: 15.0, child: CircularProgressIndicator());
    } else {
      return Icon(
        Icons.refresh,
        color: LelloTheme.palleteOf(theme).primary(),
      );
    }
  }
}
