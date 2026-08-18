import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_periods.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet/timesheet_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/timesheet_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_point_mirror_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_signature_failed_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_signature_success_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_card.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/timesheet/timesheet_detail_body.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class TimesheetWidget extends StatefulWidget {
  final TimesheetController controller;
  final List<TimesheetPeriods> dateList;
  const TimesheetWidget({
    super.key,
    required this.controller,
    required this.dateList,
  });

  @override
  State<TimesheetWidget> createState() => _TimesheetWidgetState();
}

class _TimesheetWidgetState extends State<TimesheetWidget> {
  bool selectAll = false;

  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return BlocConsumer(
      bloc: widget.controller.bloc,
      listener: (context, state) {
        if (state is TimesheetLoadedState && state.getDetailFailed) {
          Flushbar(
            message: getString(context, "gdp_timesheet_detail_error"),
            duration: const Duration(seconds: 5),
          ).show(context);
        } else if (state is TimesheetDetailLoadedState && state.pdf != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PDFScreen(
                pdfFile: state.pdf,
                title: getString(context, "space_reservation_report"),
                canDownload: true,
                fileName:
                    "${getString(context, "gdp_timesheet_type_all_timesheet")} ${widget.controller.selectedDate.year}-${widget.controller.selectedDate.month} ${widget.controller.timesheetEmployee?.name}.pdf",
              ),
            ),
          ).then((value) => state.pdf = null);
        } else if (state is TimesheetDetailLoadedState && state.putFailed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TimesheetSignatureFailedPage(),
            ),
          );
        } else if (state is TimesheetLoadedState &&
            state.saveSignatureOrNotify != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimesheetSignatureSuccessPage(
                  notify: state.saveSignatureOrNotify!),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is TimesheetLoadingState) {
          return const Expanded(child: Center(child: LoadingWidget()));
        } else if (state is TimesheetLoadedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {});
          return Expanded(
            child: DismissKeyboard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: state.list.isEmpty
                        ? Center(
                            child: Text(
                                getString(context,
                                    "gdp_timesheet_mark_day_dont_find"),
                                style: LelloTextStyles.subBody(theme)))
                        : Scrollbar(
                            thumbVisibility: true,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ...List.generate(
                                    state.list.length,
                                    (index) => InkWell(
                                      onTap: () {
                                        widget.controller.getDetailFromEmployee(
                                            state.list[index]);
                                      },
                                      child: TimesheetCard(
                                        theme: theme,
                                        controller: widget.controller,
                                        item: state.list[index],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: Dimens.spacingSmall),
                      PrimaryButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TimesheetPointMirrorPage(
                                  date: widget.controller.selectedDate,
                                  dateList: widget.dateList,
                                ),
                              ),
                            );
                          },
                          text: getString(
                              context, "gdp_timesheet_signature_button")),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else if (state is TimesheetDetailLoadedState) {
          return Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimesheetCard(
                      controller: widget.controller,
                      item: state.employee,
                      showIcon: false,
                      theme: theme,
                    ),
                    SizedBox(height: Dimens.spacing),
                    Text(
                      "${getString(context, "gdp_timesheet_status_signature")}: ${state.entity.signatureStatus}",
                      style: LelloTextStyles.bodyBold(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textLight()),
                    ),
                    SizedBox(height: Dimens.spacing),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${getString(context, "reports_filter_selected_period")}: ",
                          style: LelloTextStyles.bodyBold(theme),
                        ),
                        Text(
                          "${state.entity.initDate} a ${state.entity.endDate}",
                          style: LelloTextStyles.body(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimens.spacing),
                  ],
                ),
                TimesheetEmployeeDetailBody(
                  controller: widget.controller,
                  entity: state.entity,
                  employee: state.employee,
                ),
              ],
            ),
          );
        } else if (state is TimesheetFailedState) {
          return Expanded(
            child: Center(
              child: ErrorMessageWidget(
                  message: getString(context, "request_fine_error_message")),
            ),
          );
        }
        return Container();
      },
    );
  }
}
