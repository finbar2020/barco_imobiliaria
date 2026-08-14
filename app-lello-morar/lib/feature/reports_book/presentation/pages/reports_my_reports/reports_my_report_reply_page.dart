import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_failure_attachment_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_report_reply_success_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_message_widget.dart';

class MyReportReplyPage extends StatefulWidget {
  const MyReportReplyPage({Key? key}) : super(key: key);

  @override
  _MyReportReplyPageState createState() => _MyReportReplyPageState();
}

class _MyReportReplyPageState extends State<MyReportReplyPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List;
    final ReportsController controller = arguments[0];

    return WillPopScope(
      onWillPop: () async {
        _onPop(context, controller);
        return false;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer(
          bloc: controller.reportsBloc,
          listener: (context, state) async {
            if (state is ReportPostedState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                ApplicationRoute.myReportReplySuccess,
                ModalRoute.withName(ApplicationRoute.myReports),
                arguments: MyReportReplySuccessPageArg(controller: controller),
              );
            }
            if (state is AttachmentReportsFailureState) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                ApplicationRoute.myReportReplyFailureAttachment,
                ModalRoute.withName(ApplicationRoute.myReports),
                arguments: MyReportReplyFailureAttachmentPageArg(
                    controller: controller,
                    report: state.report!,
                    content: state.content,
                    attachment: state.attachment!),
              );
            }
          },
          builder: (context, state) {
            var numReport = "";
            if ((state as ReportsState).report != null &&
                state.report?.numReport != null) {
              numReport = "#" + state.report!.numReport.toString();
            }
            return Scaffold(
              appBar: WhiteAppBar(
                isGetString: false,
                title: "${getString(context, 'reports_report')} $numReport",
                onPressed: () {
                  _onPop(context, controller);
                },
              ),
              body: _scaffoldBody(theme, controller),
            );
          },
        ),
      ),
    );
  }

  void _onPop(BuildContext context, ReportsController controller) {
    var state = controller.reportsBloc.state;
    if (state is NewReplyReportsFailureState) {
      controller.replyReport(state.CurrentReport, state.content);
    } else {
      controller.seeReportDetails(controller.reportsBloc.state.report!);
      Navigator.pop(context);
    }
  }

  Widget _scaffoldBody(ThemeData theme, ReportsController controller) {
    final state = controller.reportsBloc.state;
    if (state is ReportsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (state is ReportsFailureState) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  getString(context, "reports_send_error"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }
    if (state is SendReportState) {
      return Column(
        children: [
          Expanded(
            child: ReportMessageWidget(
              content: state.content,
              theme: theme,
              controller: controller,
              report: state.report!,
            ),
          ),
        ],
      );
    }
    return Container();
  }
}
