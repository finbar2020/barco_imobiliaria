import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/detail_list_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/list_details_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/list_details/timesheet_list_details_header_widget.dart';

class TimesheetListDetailsPage extends StatefulWidget {
  final TimesheetOccurrenceTypeEnum type;
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  const TimesheetListDetailsPage({
    super.key,
    required this.date,
    required this.dateList,
    required this.type,
  });

  @override
  State<TimesheetListDetailsPage> createState() =>
      _TimesheetListDetailsPageState();
}

class _TimesheetListDetailsPageState extends State<TimesheetListDetailsPage> {
  ListDetailsController controller =
      ApplicationContainer.instance().resolve<ListDetailsController>();

  @override
  void initState() {
    controller.getDelayList(widget.type, widget.date);
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
        title: appBarTitle(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimesheetListDetailsHeaderWidget(
              title: appBarTitle(),
              date: widget.date,
              dateList: widget.dateList,
              controller: controller.searchController,
              detailController: controller,
              type: widget.type,
            ),
            SizedBox(height: Dimens.spacing),
            ListDetailsWidget(
              date: widget.date,
              controller: controller,
              type: widget.type,
            ),
          ],
        ),
      ),
    );
  }

  String appBarTitle() {
    switch (widget.type) {
      case TimesheetOccurrenceTypeEnum.delay:
        return getString(context, "gdp_timesheet_detail_delay");
      case TimesheetOccurrenceTypeEnum.fouls:
        return getString(context, "gdp_timesheet_detail_foul");
      case TimesheetOccurrenceTypeEnum.extraHour:
        return getString(context, "gdp_timesheet_detail_extra_hour");
      case TimesheetOccurrenceTypeEnum.vacation:
        return getString(context, "gdp_timesheet_detail_vacation");
    }
  }
}
