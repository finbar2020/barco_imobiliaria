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
import 'package:lello/feature/reports_book/presentation/pages/reports_details_report_page.dart';
import 'package:lello/feature/reports_book/presentation/widgets/report_preview_widget.dart';

class ReportsPreviewReportPageArgs {
  final Report report;
  ReportsPreviewReportPageArgs({required this.report});
}

class ReportsPreviewReportPage extends StatefulWidget {
  const ReportsPreviewReportPage({Key? key}) : super(key: key);

  @override
  ReportsPreviewReportPageState createState() =>
      ReportsPreviewReportPageState();
}

class ReportsPreviewReportPageState extends State<ReportsPreviewReportPage>
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
    ReportsPreviewReportPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ReportsPreviewReportPageArgs;
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

    if (reportsBloc.state is PreviewReportState) {
      return _buildBody(
          theme, reportsBloc, context, reportsBloc.state as PreviewReportState);
    }

    return Container();
  }

  Widget _buildBody(ThemeData theme, ReportsBloc reportsBloc,
      BuildContext context, PreviewReportState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(25.0),
              child: ReportPreviewWidget(
                report: state.report,
                theme: theme,
                content: state.content,
                attachment: state.attachment,
              ),
            ),
          ),
        ),
        _buttonSeeReplies(reportsBloc, theme, context, state.report),
      ],
    );
  }

  AppBar _buildAppBar(ReportsBloc reportsBloc, ThemeData theme,
      BuildContext context, Report report) {
    return PrimaryAppBar(
      title: "${getString(context, "reports_report")} #${report.numReport}",
      centerTitle: true,
      theme: theme,
      onBackArrowPressed: () => Navigator.pushReplacementNamed(
        context,
        ApplicationRoute.reportsBook,
      ),
    );
  }

  Container _buttonSeeReplies(
    ReportsBloc reportsBloc,
    ThemeData theme,
    BuildContext context,
    Report report,
  ) {
    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Container(
        padding: const EdgeInsets.only(right: 5.0),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: Dimens.spacingSmall),
              Text(
                getString(context, "reports_see_replies"),
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
          onPressed: () {
            controller.seeReportDetails(report: report);
            Navigator.pushReplacementNamed(
                context, ApplicationRoute.reportDetails,
                arguments: ReportsDetailsReportPageArgs(report: report));
          },
        ),
      ),
    );
  }
}
