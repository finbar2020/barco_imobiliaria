import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_point_mirror/timesheet_point_mirror_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_point_mirror_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_occurence_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirro_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/point_mirror/timesheet_point_mirror_header.dart';

class TimesheetPointMirrorPage extends StatefulWidget {
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  const TimesheetPointMirrorPage({
    super.key,
    required this.date,
    required this.dateList,
  });

  @override
  State<TimesheetPointMirrorPage> createState() =>
      _TimesheetPointMirrorPageState();
}

class _TimesheetPointMirrorPageState extends State<TimesheetPointMirrorPage> {
  TimesheetPointMirrorController controller =
      ApplicationContainer.instance().resolve<TimesheetPointMirrorController>();

  @override
  void initState() {
    controller.getPointMirrorList(widget.date);
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
      appBar: PrimaryAppBar(
        iconColor: theme.primaryColor,
        theme: theme,
        title: getString(context, "gdp_timesheet_signature_button"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimesheetPointMirrorHeaderWidget(
              title: getString(context, "gdp_timesheet_signature_button"),
              date: widget.date,
              dateList: widget.dateList,
              controller: controller,
            ),
            SizedBox(height: Dimens.spacing),
            TimesheetPointMirrorWidget(
              date: widget.date,
              controller: controller,
            ),
            SizedBox(height: Dimens.spacingXSmall),
            BlocBuilder(
              bloc: controller.bloc,
              builder: (context, state) {
                return Column(
                  children: [
                    PrimaryButton(
                        buttonColor: const Color(0xFF2F80ED),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TimesheetOccurrencePage(
                                date: controller.selectDate,
                                dateList: widget.dateList,
                              ),
                            ),
                          );
                        },
                        text:
                            getString(context, "gdp_timesheet_go_occurrence")),
                    if (state is TimesheetPointMirrorLoadedState)
                      SizedBox(height: Dimens.spacingSmall),
                    if (state is TimesheetPointMirrorLoadedState)
                      PrimaryButton(
                        onPressed: state.list.any((element) =>
                                element.signatureEmployee == false ||
                                element.signatureManager == false)
                            ? () {
                                controller.saveActions();
                              }
                            : null,
                        text: getString(context, "save"),
                      ),
                    SizedBox(height: Dimens.spacingSmall),
                    SecondaryButton(
                        buttonBorderColor: Colors.black,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        text: getString(context, "cancel")),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
