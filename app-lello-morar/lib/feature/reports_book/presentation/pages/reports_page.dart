import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/domain/entity/report_option.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_my_reports/reports_my_reports_page.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_register_new_report_page.dart';
import 'package:morar/feature/reports_book/presentation/widgets/reports_option_card_widget.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class ReportsPageArgs {
  String? reportNotificationContext;
  ReportsPageArgs({this.reportNotificationContext});
}

class ReportsPage extends StatefulWidget {
  const ReportsPage({Key? key}) : super(key: key);

  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final ReportsController controller =
      ApplicationContainer.instance().resolve<ReportsController>();
  @override
  void initState() {
    controller.showFirstEvent();
    super.initState();
  }

  ReportsPageArgs? arguments;
  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    arguments = ModalRoute.of(context)!.settings.arguments as ReportsPageArgs?;

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
              appBar: CustomAppBar(title: "reports_title"),
              body: _scaffoldBody(controller, sessionBloc, theme, context),
            );
          },
        ),
      ),
    );
  }

  Widget _scaffoldBody(
    ReportsController controller,
    SessionBloc sessionBloc,
    ThemeData theme,
    BuildContext context,
  ) {
    if (controller.reportsBloc.state is ReportsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (controller.reportsBloc.state is ReportsBookFirstState) {
      return _buildBody(controller, sessionBloc, theme, context);
    }
    if (controller.reportsBloc.state is ReportsFailureState) {
      return Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  getString(context, "reports_error"),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Container();
  }

  Column _buildBody(
    ReportsController controller,
    SessionBloc sessionBloc,
    ThemeData theme,
    BuildContext context,
  ) {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (arguments?.reportNotificationContext?.isNotEmpty == true && mounted) {
        controller.getAllReports();
        Navigator.pushNamed(
          context,
          ApplicationRoute.myReports,
          arguments: MyReportsPageArgs(
              controller: controller,
              reportNotificationContext: arguments?.reportNotificationContext),
        );
        arguments?.reportNotificationContext = null;
      }
    });
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          color: LelloTheme.palleteOf(theme).backgroundDark(),
          width: double.infinity,
          height: Dimens.spacingLarge,
          child: Center(
            child: Text(
              '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
              overflow: TextOverflow.ellipsis,
              style: LelloTextStyles.body(theme),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 20.0,
          ),
          child: Center(
            child: Text(
              getString(context, 'reports_description'),
              style: LelloTextStyles.subBody(theme),
            ),
          ),
        ),
        CircuitBreakerWidget(
          reference: sessionBloc.state.session?.condominium?.reference ?? "",
          appContainer: ApplicationContainer.instance(),
          applicationRbac: ApplicationRbac.morarOcorrenciasMinhasOcorrencias,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.morarOcorrenciasMinhasOcorrencias),
          child: ReportsOptionCardWidget(
            reportOption: ReportOption(
              title: getString(context, 'reports_my_reports'),
              assetImage: 'assets/ic_my_reports.svg',
              newMessages: false,
              onTap: () {
                controller.getAllReports();
                Navigator.pushNamed(
                  context,
                  ApplicationRoute.myReports,
                  arguments: MyReportsPageArgs(controller: controller),
                );
              },
            ),
          ),
        ),
        CircuitBreakerWidget(
          reference: sessionBloc.state.session?.condominium?.reference ?? "",
          appContainer: ApplicationContainer.instance(),
          applicationRbac: ApplicationRbac.morarOcorrenciasNovaOcorrencia,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.morarOcorrenciasNovaOcorrencia),
          child: ReportsOptionCardWidget(
            reportOption: ReportOption(
              title: getString(context, 'reports_register_new_report'),
              assetImage: 'assets/ic_new_reports.svg',
              onTap: () {
                controller.createNewReport();
                Navigator.pushNamed(context, ApplicationRoute.registerNewReport,
                    arguments: RegisterNewReportPageArgs(
                      controller: controller,
                    ));
              },
            ),
          ),
        )
      ],
    );
  }
}
