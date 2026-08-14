import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:lello/feature/reports_book/presentation/controller/report_controller.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_reply_page.dart';
import 'package:lello/feature/reports_book/presentation/widgets/report_details_widget.dart';

class ReportsDetailsReportPageArgs {
  final Report report;
  ReportsDetailsReportPageArgs({required this.report});
}

class ReportsDetailsReportPage extends StatefulWidget {
  const ReportsDetailsReportPage({super.key});

  @override
  ReportsDetailsReportPageState createState() =>
      ReportsDetailsReportPageState();
}

class ReportsDetailsReportPageState extends State<ReportsDetailsReportPage>
    with SingleTickerProviderStateMixin {
  late Report report;
  final ReportController controller =
      ApplicationContainer.instance().resolve<ReportController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ReportsDetailsReportPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ReportsDetailsReportPageArgs;
    report = arguments.report;
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer(
          listener: (context, state) {
            if (state is ReportClosedState) {
              Navigator.pushReplacementNamed(
                  context, ApplicationRoute.reportsCloseReportSuccess);
            }
          },
          bloc: controller.reportsBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: _buildAppBar(controller, theme, context, report),
              body: _scaffoldBody(controller.reportsBloc, theme, context),
            );
          },
        ),
      ),
    );
  }

  Widget _scaffoldBody(
    ReportsBloc reportsBloc,
    ThemeData theme,
    BuildContext context,
  ) {
    if (reportsBloc.state is ReportsEmptyState ||
        reportsBloc.state is ReportLoadingState) {
      return const Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }

    if (reportsBloc.state is ReportsEmptyState) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Text(getString(context, "reports_no_reports"),
                  style: LelloTextStyles.body(theme)),
            ),
          ),
        ],
      );
    }

    if (reportsBloc.state is ReportsFailureState) {
      return ErrorMessageWidget(
        message: getString(context, "reports_close_error"),
      );
    }

    if (reportsBloc.state is SeeReportDetailsState) {
      return _buildBody(theme, context, reportsBloc,
          reportsBloc.state as SeeReportDetailsState, controller);
    }

    return Container();
  }
}

AppBar _buildAppBar(
  ReportController controller,
  ThemeData theme,
  BuildContext context,
  Report report,
) {
  return PrimaryAppBar(
    title: "${getString(context, "reports_report")} #${report.numReport}",
    centerTitle: true,
    theme: theme,
    onBackArrowPressed: () {
      controller.getReport(report: report);
      Navigator.pushReplacementNamed(
        context,
        ApplicationRoute.reportsBook,
      );
    },
  );
}

Container _buildBody(
    ThemeData theme,
    BuildContext context,
    ReportsBloc reportsBloc,
    SeeReportDetailsState state,
    ReportController controller) {
  return Container(
    color: LelloTheme.palleteOf(theme).backgroundDark(),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: state.report.reportContents!.isNotEmpty
              ? ListView.builder(
                  itemCount: state.report.reportContents!.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return ReportDetailsWidget(
                      content: state.report.reportContents![index],
                      theme: theme,
                      residentName: state.report.residentsName ?? "",
                      unit: state.report.unit!.name!,
                    );
                  },
                )
              : Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      getString(context, "reports_no_content"),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
        ),
        if (!state.report.closed)
          _buttonsReplyClose(state, theme, context, state.report, controller),
      ],
    ),
  );
}

Container _buttonsReplyClose(SeeReportDetailsState state, ThemeData theme,
    BuildContext context, Report report, ReportController controller) {
  return Container(
    color: LelloTheme.palleteOf(theme).backgroundDark(),
    child: Column(
      children: [
        const Divider(
          height: 1,
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SizedBox(
                height: 54.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text(
                    getString(context, "reports_reply"),
                    style: LelloTextStyles.button(theme)!
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    controller.replyReport(report: state.report, content: null);
                    Navigator.pushReplacementNamed(
                      context,
                      ApplicationRoute.reportReply,
                      arguments: ReportsReplyPageArgs(report: report),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              SizedBox(
                height: 54.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.black),
                      )),
                  child: Text(
                    getString(context, "reports_close"),
                    style: LelloTextStyles.button(theme)!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    controller.closeReport(report: state.report);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
