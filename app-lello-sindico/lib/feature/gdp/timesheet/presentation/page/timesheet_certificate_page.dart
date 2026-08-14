import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_certificate_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_certificates/certificate_header_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet_certificates/certificate_widget.dart';

class TimesheetCertificatePage extends StatefulWidget {
  final DateTime date;
  final List<TimesheetPeriods> dateList;
  const TimesheetCertificatePage({
    super.key,
    required this.date,
    required this.dateList,
  });

  @override
  State<TimesheetCertificatePage> createState() =>
      _TimesheetCertificatePageState();
}

class _TimesheetCertificatePageState extends State<TimesheetCertificatePage> {
  TimesheetCertificateController controller =
      ApplicationContainer.instance().resolve<TimesheetCertificateController>();

  @override
  void initState() {
    controller.getCertificates(widget.date);
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
        title: "Ponto Digital",
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TimesheetCertificateHeaderWidget(
              title:
                  "${getString(context, "gdp_timesheet_certificate_title")}s",
              date: widget.date,
              dateList: widget.dateList,
              controller: controller.searchController,
              detailController: controller,
            ),
            SizedBox(height: Dimens.spacing),
            CertificateWidget(
              date: widget.date,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}
