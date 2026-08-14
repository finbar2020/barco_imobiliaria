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
import 'package:lello/feature/reports_book/presentation/pages/reports_reply_page.dart';
import 'package:lello/feature/reports_book/presentation/pages/reports_reply_success_page.dart';
import 'package:lello/feature/reports_book/presentation/widgets/reply_preview_widget.dart';

class ReportsPreviewReplyPageArgs {
  final Report report;
  ReportsPreviewReplyPageArgs({required this.report});
}

class ReportsPreviewReplyPage extends StatefulWidget {
  const ReportsPreviewReplyPage({Key? key}) : super(key: key);

  @override
  ReportsPreviewReplyPageState createState() => ReportsPreviewReplyPageState();
}

class ReportsPreviewReplyPageState extends State<ReportsPreviewReplyPage>
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
    ReportsPreviewReplyPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ReportsPreviewReplyPageArgs;
    report = arguments.report;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocConsumer(
          listener: (context, state) {
            if (state is ReportPostedState) {
              Navigator.pushReplacementNamed(
                context,
                ApplicationRoute.reportReplySuccess,
                arguments: ReportsReplySuccessPageArgs(report: report),
              );
            }
          },
          bloc: controller.reportsBloc,
          builder: (context, state) {
            return Scaffold(
              appBar:
                  _buildAppBar(controller.reportsBloc, theme, context, report),
              body:
                  _scaffoldBody(controller.reportsBloc, theme, context, report),
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
    Report report,
  ) {
    if (reportsBloc.state is ReportsEmptyState ||
        reportsBloc.state is ReportLoadingState) {
      return Column(
        children: const [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (reportsBloc.state is ReportsFailureState) {
      return ErrorMessageWidget(
          message: getString(context, "reports_send_error"));
    }
    if (reportsBloc.state is PreviewReplyState) {
      return _buildBody(theme, context, reportsBloc,
          reportsBloc.state as PreviewReplyState, report);
    }
    return Container();
  }

  Widget _buildBody(ThemeData theme, BuildContext context,
      ReportsBloc reportsBloc, PreviewReplyState state, Report report) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25.0),
              child: ReplyPreviewWidget(
                report: state.report,
                theme: theme,
                content: state.content,
              ),
            ),
          ),
        ),
        _buttonsReplyBack(reportsBloc, state, theme, context, report),
      ],
    );
  }

  AppBar _buildAppBar(ReportsBloc reportsBloc, ThemeData theme,
      BuildContext context, Report report) {
    return PrimaryAppBar(
      title: getString(context, "reports_reply"),
      centerTitle: true,
      theme: theme,
      onBackArrowPressed: (){
    _backToReplyPage(reportsBloc, report, context);
    },
    );
  }

  void _backToReplyPage(
      ReportsBloc reportsBloc, Report report, BuildContext context) {
    ReportContents? content;
    if (reportsBloc.state is PreviewReplyState) {
      report = (reportsBloc.state as PreviewReplyState).report;
      content = (reportsBloc.state as PreviewReplyState).content;
      controller.replyReport(report: report, content: content);
    }
    controller.replyReport(report: report, content: null);
    Navigator.pushReplacementNamed(
      context,
      ApplicationRoute.reportReply,
      arguments: ReportsReplyPageArgs(report: report),
    );
  }

  Column _buttonsReplyBack(ReportsBloc reportsBloc, PreviewReplyState state,
      ThemeData theme, BuildContext context, Report report) {
    return Column(
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
                    getString(context, "reports_send_reply"),
                    style: LelloTextStyles.button(theme)!
                        .copyWith(color: Colors.white),
                  ),
                  onPressed: () {
                    controller.sendReplyReport(
                        report: state.report, content: state.content);
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
                    ),
                  ),
                  child: Text(
                    getString(context, "back"),
                    style: LelloTextStyles.button(theme)!
                        .copyWith(color: Colors.black),
                  ),
                  onPressed: () {
                    _backToReplyPage(reportsBloc, report, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
