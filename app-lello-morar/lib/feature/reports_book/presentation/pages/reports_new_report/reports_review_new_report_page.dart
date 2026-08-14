import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_new_report_failure_attachment_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_preview_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class ReviewNewReportPage extends StatefulWidget {
  const ReviewNewReportPage({Key? key}) : super(key: key);

  @override
  _ReviewNewReportPageState createState() => _ReviewNewReportPageState();
}

class _ReviewNewReportPageState extends State<ReviewNewReportPage>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List;
    final ReportsController controller = arguments[0];

    final theme = Theme.of(context);
    return Theme(
      data: theme,
      child: BlocConsumer(
        listener: (context, state) async {
          if (state is ReportPostedState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ApplicationRoute.newReportSuccess,
              ModalRoute.withName(ApplicationRoute.reports),
              arguments: [controller],
            );
          }
          if (state is AttachmentReportsFailureState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ApplicationRoute.reportNewReportFailureAttachment,
              ModalRoute.withName(ApplicationRoute.reports),
              arguments: ReportsNewReportFailureAttachmentPageArg(
                  controller: controller,
                  report: state.report!,
                  content: state.content,
                  attachment: state.attachment!),
            );
          }
        },
        bloc: controller.reportsBloc,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              if (state is PreviewReportState) {
                controller.createNewReport(
                    report: state.report!,
                    content: state.content,
                    attachment: state.attachment);
              }
              if (state is NewReportsFailureState) {
                controller.createNewReport(
                    report: state.report!,
                    content: state.content,
                    attachment: state.attachment);
              }
              return true;
            },
            child: Scaffold(
              appBar: WhiteAppBar(
                  isGetString: false,
                  title: getString(context, 'reports_new_report'),
                  onPressed: () {
                    if (state is NewReportsFailureState) {
                      controller.createNewReport(
                          report: state.report!,
                          content: state.content,
                          attachment: state.attachment);
                    }
                    if (state is PreviewReportState) {
                      controller.createNewReport(
                          report: state.report!,
                          content: state.content,
                          attachment: state.attachment);
                    }
                    Navigator.pop(context);
                  }),
              body: _scaffoldBody(theme, context, controller, sessionBloc),
            ),
          );
        },
      ),
    );
  }

  Widget _scaffoldBody(ThemeData theme, BuildContext context,
      ReportsController controller, SessionBloc sessionBloc) {
    if (controller.reportsBloc.state is ReportsInitialState ||
        controller.reportsBloc.state is ReportsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (controller.reportsBloc.state is ReportsFailureState) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(getString(context, "reports_create_error"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!
                        .copyWith(color: LelloTheme.palleteOf(theme).text())),
              ),
            ),
          ),
        ],
      );
    }
    if (controller.reportsBloc.state is PreviewReportState) {
      return _buildBody(theme, context, controller,
          controller.reportsBloc.state as PreviewReportState, sessionBloc);
    }
    return Container();
  }

  Widget _buildBody(
      ThemeData theme,
      BuildContext context,
      ReportsController controller,
      PreviewReportState state,
      SessionBloc sessionBloc) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25.0),
              child: ReportPreviewWidget(
                report: state.report!,
                theme: theme,
                content: state.content,
              ),
            ),
          ),
        ),
        Container(
          color: LelloTheme.palleteOf(theme).customColor(),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
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
                  getString(context, "send"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                onPressed: () {
                  controller.postNewReport(state.report!, state.content);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
