import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/widgets/reports_card_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class MyReportsPageArgs {
  String? reportNotificationContext;
  final ReportsController controller;
  MyReportsPageArgs({required this.controller, this.reportNotificationContext});
}

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({Key? key}) : super(key: key);

  @override
  _MyReportsPageState createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage>
    with SingleTickerProviderStateMixin {
  late MyReportsPageArgs arguments;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);

    arguments = ModalRoute.of(context)!.settings.arguments as MyReportsPageArgs;
    final ReportsController controller = arguments.controller;
    return WillPopScope(
      onWillPop: () async {
        await controller.showFirstEvent();
        return true;
      },
      child: Theme(
        data: theme,
        child: BlocBuilder(
          bloc: controller.reportsBloc,
          builder: (context, state) {
            return Scaffold(
              appBar: WhiteAppBar(
                  isGetString: true,
                  title: "reports_my_reports",
                  onPressed: () {
                    controller.showFirstEvent();
                    Navigator.pop(context);
                  }),
              body: _scaffoldBody(controller, theme, context, sessionBloc),
            );
          },
        ),
      ),
    );
  }

  Widget _scaffoldBody(ReportsController controller, ThemeData theme,
      BuildContext context, SessionBloc sessionBloc) {
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
      return _buildError(controller: controller);
    }

    if (controller.reportsBloc.state is ReportsLoadedState) {
      return _buildReports(
          controller: controller,
          state: controller.reportsBloc.state as ReportsLoadedState,
          theme: theme,
          sessionBloc: sessionBloc);
    }

    return Container();
  }

  Column _buildError({required ReportsController controller}) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.getAllReports();
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

  Widget _buildReports(
      {required ReportsController controller,
      required ReportsLoadedState state,
      required ThemeData theme,
      required SessionBloc sessionBloc}) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (arguments.reportNotificationContext?.isNotEmpty == true && mounted) {
        var item = state.allReports.cast<Report?>().firstWhere(
            (element) =>
                element?.numReport == arguments.reportNotificationContext ||
                element?.notificationParameter ==
                    arguments.reportNotificationContext,
            orElse: () => null);
        if (item != null) {
          controller.getReport(report: item);
          Navigator.pushNamed(
            context,
            ApplicationRoute.myReportDetails,
            arguments: [controller],
          );
        }
        arguments.reportNotificationContext = null;
      }
    });
    return Container(
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacing),
        child: state.allReports.isNotEmpty
            ? ListView.builder(
                itemCount: state.allReports.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  return ReportsCardWidget(
                    report: state.allReports[index],
                    index: '#' + state.allReports[index].numReport! + "  ",
                    onTap: () {
                      controller.getReport(report: state.allReports[index]);
                      Navigator.pushNamed(
                        context,
                        ApplicationRoute.myReportDetails,
                        arguments: [controller, state.allReports[index]],
                      );
                      _registerAnalyticsEvent(
                          closed: state.allReports[index].closed!,
                          sessionBloc: sessionBloc);
                    },
                  );
                },
              )
            : Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          getString(context, "reports_no_reports"),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _registerAnalyticsEvent(
      {required bool closed, required SessionBloc sessionBloc}) {
    OwnerAnalyticsLogEvents.logEvent(
      event: closed == false
          ? AnalyticsEventsOwner.ocorrenciasMinhasAbertas()
          : AnalyticsEventsOwner.ocorrenciasMinhasEncerradas(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session!.unity?.namedTitle.toString() ?? "",
      referenceValue:
          sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
    );
  }
}
