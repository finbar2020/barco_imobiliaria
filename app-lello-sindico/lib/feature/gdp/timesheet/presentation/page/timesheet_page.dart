import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_occurence_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_detail_buttons.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_header_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_widget.dart';

class TimesheetPage extends StatefulWidget {
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  const TimesheetPage({
    super.key,
    required this.date,
    required this.dateList,
  });

  @override
  State<TimesheetPage> createState() => _TimesheetPageState();
}

class _TimesheetPageState extends State<TimesheetPage> {
  TimesheetController controller =
      ApplicationContainer.instance().resolve<TimesheetController>();

  @override
  void initState() {
    controller.getList(widget.date);
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
    return BlocConsumer(
      bloc: controller.bloc,
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            if (controller.timesheetEmployee != null) {
              controller.previousStep();
            } else {
              Navigator.pop(context);
            }
            return false;
          },
          child: Scaffold(
            appBar: PrimaryAppBar(
                theme: theme,
                title: 'Ponto Digital',
                onBackArrowPressed: () {
                  if (controller.timesheetEmployee != null) {
                    controller.previousStep();
                  } else {
                    Navigator.pop(context);
                  }
                },
                ),
            body: Column(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TimesheetHeaderWidget(
                          title: getString(
                              context, "gdp_timesheet_type_all_timesheet"),
                          controller: controller,
                          dateList: widget.dateList,
                        ),
                        SizedBox(height: Dimens.spacing),
                        TimesheetWidget(
                          controller: controller,
                          dateList: widget.dateList,
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder(
                  bloc: controller.bloc,
                  builder: (context, state) {
                    if (state is TimesheetDetailLoadedState) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                            onTap: () {
                              launchUrl(Uri.parse(
                                  "https://portal.lellocondominios.com.br/menuPortal2/"));
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "Precisa de ajuda com alguma informação?",
                                      style: LelloTextStyles.subBody(theme)!
                                          .copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Text("Peça para gente!",
                                      style: LelloTextStyles.subBody(theme)!
                                          .copyWith(
                                              color: theme.primaryColor,
                                              fontWeight: FontWeight.bold))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Dimens.spacing),
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
                                              padding:
                                                  const EdgeInsets.symmetric(
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
                                                      style: LelloTextStyles
                                                          .subBody(theme),
                                                    ),
                                                    Icon(
                                                        Icons
                                                            .keyboard_arrow_down_rounded,
                                                        color: LelloTheme
                                                                .palleteOf(
                                                                    theme)
                                                            .textLight()),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            TimesheetDetailButtons(
                                              showNotifyButton:
                                                  state.entity.dontShowButton,
                                              isNotifyButton:
                                                  state.entity.notifyButton,
                                              getTimesheetReport: () {
                                                Navigator.pop(context);
                                                controller.getTimesheetReport();
                                              },
                                              put: () {
                                                Navigator.pop(context);
                                                controller
                                                    .postSignatureOrNotify(
                                                        notify: state.entity
                                                            .notifyButton);
                                              },
                                              goToOccurrences: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TimesheetOccurrencePage(
                                                            dateList:
                                                                widget.dateList,
                                                            date: controller
                                                                .selectedDate,
                                                            numCra: state
                                                                .employee
                                                                .numCra),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        )));
                              },
                              child: Container(
                                height: 50.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: LelloTheme.palleteOf(theme)
                                            .textOpaque()),
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
                                        color: LelloTheme.palleteOf(theme)
                                            .textLight()),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
