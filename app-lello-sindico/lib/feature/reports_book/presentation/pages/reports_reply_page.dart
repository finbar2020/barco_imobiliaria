import 'package:another_flushbar/flushbar.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/error_message_widget.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/domain/entity/report_contents.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_bloc.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:lello/feature/reports_book/presentation/controller/report_controller.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_details_report_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_preview_reply_page.dart';
import 'package:lello/feature/reports_book/presentation/widgets/report_message_widget.dart';

class ReportsReplyPageArgs {
  final Report report;
  ReportsReplyPageArgs({required this.report});
}

class ReportsReplyPage extends StatefulWidget {
  const ReportsReplyPage({Key? key}) : super(key: key);

  @override
  ReportsReplyPageState createState() => ReportsReplyPageState();
}

class ReportsReplyPageState extends State<ReportsReplyPage>
    with SingleTickerProviderStateMixin {
  late Report report;
  final ReportContents reportContents = ReportContents();

  final ReportController controller =
      ApplicationContainer.instance().resolve<ReportController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    ReportsReplyPageArgs arguments =
        ModalRoute.of(context)!.settings.arguments as ReportsReplyPageArgs;
    report = arguments.report;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocBuilder(
          bloc: controller.reportsBloc,
          builder: (context, state) {
            return Scaffold(
              appBar:
                  _buildAppBar(controller.reportsBloc, theme, context, report),
              body: _scaffoldBody(controller.reportsBloc, theme, context),
              bottomNavigationBar: Container(
                color: const Color(0xFFFFFFFF),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: SizedBox(
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
                        getString(context, "next"),
                        style: LelloTextStyles.button(theme)!
                            .copyWith(color: Colors.white),
                      ),
                      onPressed: () {
                        if (state is SendReportState &&
                            controller.content != null &&
                            controller.content != "") {
                          reportContents.attachmentType =
                              controller.attachmentType;
                          reportContents.attachmentFile =
                              controller.attachmentFile;
                          reportContents.content = controller.content;

                          controller.previewReply(
                              report: report, content: reportContents);
                          Navigator.pushReplacementNamed(
                            context,
                            ApplicationRoute.reportPreviewReply,
                            arguments:
                                ReportsPreviewReplyPageArgs(report: report),
                          );
                        } else {
                          Flushbar(
                            message: getString(
                                context, "reports_empty_content_flushbar"),
                            duration: const Duration(seconds: 5),
                          ).show(context);
                        }
                      },
                    ),
                  ),
                ),
              ),
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
        reportsBloc.state is ReportsLoadingState) {
      return Column(
        children: const [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }

    if (reportsBloc.state is ReportsFailureState) {
      return ErrorMessageWidget(message: getString(context, "reports_error"));
    }

    if (reportsBloc.state is SendReportState) {
      return _buildBody(
          reportsBloc.state as SendReportState, theme, reportsBloc);
    }

    return Container();
  }

  AppBar _buildAppBar(ReportsBloc reportsBloc, ThemeData theme,
      BuildContext context, Report report) {
    return PrimaryAppBar(
      title: getString(context, "reports_reply"),
      centerTitle: true,
      theme: theme,
      onBackArrowPressed: () {
        controller.seeReportDetails(report: report);
        Navigator.pushReplacementNamed(
          context,
          ApplicationRoute.reportDetails,
          arguments: ReportsDetailsReportPageArgs(report: report),
        );
      },
    );
  }

  ReportMessageWidget _buildBody(
      SendReportState state, ThemeData theme, ReportsBloc reportsBloc) {
    return ReportMessageWidget(
      content: state.content!,
      report: state.report!,
    );
  }
}
