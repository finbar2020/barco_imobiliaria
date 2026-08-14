import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/widgets/report_details_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class MyReportDetailsPage extends StatefulWidget {
  const MyReportDetailsPage({Key? key}) : super(key: key);

  @override
  _MyReportDetailsPageState createState() => _MyReportDetailsPageState();
}

class _MyReportDetailsPageState extends State<MyReportDetailsPage>
    with SingleTickerProviderStateMixin {
  final ScrollController _controller = ScrollController();
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List;
    final ReportsController reportsController = arguments[0];

    return WillPopScope(
      onWillPop: () async {
        _onWillPop(reportsController, context);
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocBuilder(
          bloc: reportsController.reportsBloc,
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
                  _onWillPop(reportsController, context);
                },
              ),
              body: _scaffoldBody(sessionBloc, theme, context,
                  reportsController, state, authenticationStore),
            );
          },
        ),
      ),
    );
  }

  void _onWillPop(ReportsController reportsController, BuildContext context) {
    if (reportsController.reportsBloc.state is SeeReportDetailsState) {
      if (reportsController.reportsBloc.state.report?.closed == true &&
          reportsController.reportsBloc.state.report?.newMessage == true) {
        AppReview.call(context: context);
      }
    }
    reportsController.getAllReports();
    Navigator.pop(context);
  }

  Widget _scaffoldBody(
      SessionBloc sessionBloc,
      ThemeData theme,
      BuildContext context,
      ReportsController reportsController,
      ReportsState state,
      AuthenticationStore authenticationStore) {
    if (reportsController.reportsBloc.state is ReportsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (reportsController.reportsBloc.state is ReportsFailureState) {
      return _buildError(
          reportsController: reportsController, report: state.report);
    }
    if (reportsController.reportsBloc.state is SeeReportDetailsState) {
      return _buildBody(sessionBloc, theme, context, reportsController,
          state as SeeReportDetailsState, authenticationStore);
    }
    return Container();
  }

  Container _buildBody(
    SessionBloc sessionBloc,
    ThemeData theme,
    BuildContext context,
    ReportsController reportsController,
    SeeReportDetailsState state,
    AuthenticationStore authenticationStore,
  ) {
    if (state.report!.reportContents!.length != 0) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    }
    return Container(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingSmall),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              getString(context, state.report!.getTypeReport),
              textAlign: TextAlign.left,
              style: LelloTextStyles.subtitleBold(theme),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: Dimens.spacing,
            ),
            Expanded(
              child: state.report!.reportContents!.length != 0
                  ? ListView.builder(
                      itemCount: state.report!.reportContents!.length,
                      scrollDirection: Axis.vertical,
                      controller: _controller,
                      shrinkWrap: true,
                      itemBuilder: (BuildContext context, int index) {
                        return ReportDetailsWidget(
                          typeReport: state.report!.getTypeReport,
                          content: state.report!.reportContents![index],
                          httpHeaders: authenticationStore.getCustomHeader(),
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
            if (!state.report!.closed!)
              _buttonNewReplie(reportsController, state, theme, context,
                  state.report!, sessionBloc),
            _buttonBackMyReplies(reportsController, state, theme, context,
                state.report!, sessionBloc),
          ],
        ),
      ),
    );
  }

  Column _buildError(
      {required ReportsController reportsController, required Report? report}) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                if (report != null) {
                  reportsController.getReport(report: report);
                }
              },
              backFunction: () => Navigator.pop(context, true),
              isProduction: env.isProduction,
              error: "",
              errorCode: "",
              textReturnButton: "back_to_the_previous_page",
            ),
          ),
        ),
      ],
    );
  }

  Container _buttonNewReplie(
      ReportsController reportsController,
      SeeReportDetailsState state,
      ThemeData theme,
      BuildContext context,
      Report report,
      SessionBloc sessionBloc) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          Dimens.spacingMedium, Dimens.spacingMedium, Dimens.spacingMedium, 0),
      child: PrimaryButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getString(context, "reply"),
                style: LelloTextStyles.subBody(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).background(),
                ),
              ),
            ],
          ),
          onPressed: () {
            reportsController.replyReport(state.report!);
            Navigator.pushNamed(
              context,
              ApplicationRoute.myReportReply,
              arguments: [reportsController],
            );
            OwnerAnalyticsLogEvents.logEvent(
              event: AnalyticsEventsOwner.ocorrenciasMinhasResponder(),
              userId: sessionBloc.state.session?.me?.id ?? "",
              unitValue:
                  sessionBloc.state.session!.unity?.namedTitle.toString() ?? "",
              referenceValue: sessionBloc.state.session!.condominium?.reference
                      ?.toString() ??
                  "",
            );
          }),
    );
  }

  Container _buttonBackMyReplies(
      ReportsController reportsController,
      SeeReportDetailsState state,
      ThemeData theme,
      BuildContext context,
      Report report,
      SessionBloc sessionBloc) {
    return Container(
      padding: EdgeInsets.fromLTRB(Dimens.spacingMedium, Dimens.spacingMedium,
          Dimens.spacingMedium, Dimens.spacing),
      child: SecondaryButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(getString(context, "back")),
            ],
          ),
          onPressed: () {
            if (reportsController.reportsBloc.state is SeeReportDetailsState) {
              if (reportsController.reportsBloc.state.report?.closed == true &&
                  reportsController.reportsBloc.state.report?.newMessage ==
                      true) {
                AppReview.call(context: context);
              }
            }
            reportsController.getAllReports();
            Navigator.pop(context);
          }),
    );
  }
}
