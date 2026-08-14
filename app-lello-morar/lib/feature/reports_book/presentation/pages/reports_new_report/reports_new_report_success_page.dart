import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/reports_book/presentation/pages/reports_new_report/reports_register_new_report_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class NewReportSuccessPage extends StatefulWidget {
  const NewReportSuccessPage({Key? key}) : super(key: key);

  @override
  _NewReportSuccessPageState createState() => _NewReportSuccessPageState();
}

class _NewReportSuccessPageState extends State<NewReportSuccessPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
    List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List;
    final ReportsController controller = arguments[0];

    return Theme(
      data: theme,
      child: BlocBuilder(
        bloc: controller.reportsBloc,
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              controller.showFirstEvent();
              return true;
            },
            child: Scaffold(
              backgroundColor: LelloTheme.palleteOf(theme).success(),
              body:
                  _scaffoldBody(context, theme, sessionBloc, state, controller),
            ),
          );
        },
      ),
    );
  }

  Widget _scaffoldBody(BuildContext context, ThemeData theme,
      SessionBloc sessionBloc, state, ReportsController controller) {
    if (controller.reportsBloc.state is ReportsInitialState ||
        state is ReportsLoadingState) {
      return Column(
        children: [
          Expanded(
            child: LoadingWidget(),
          ),
        ],
      );
    }
    if (controller.reportsBloc.state is ReportsFailureState) {
      return _buildError(theme);
    }
    if (controller.reportsBloc.state is ReportPostedState) {
      return _buildBody(context, theme, sessionBloc, state, controller);
    }
    return Container();
  }

  Padding _buildBody(BuildContext context, ThemeData theme,
      SessionBloc sessionBloc, state, ReportsController controller) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingLarge),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_success.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, 'reports_registered_success'),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingLarge),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    '${getString(context, "reports_report")} #${(controller.reportsBloc.state as ReportPostedState).report!.numReport}',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: LelloTextStyles.title(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 54.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                getString(context, "conclude"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                AppReview.call(context: context);
                controller.showFirstEvent();
                Navigator.pop(context,
                    (state is ReportPostedState) ? state.report : null);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Dimens.spacingLarge),
            child: Container(
              width: double.infinity,
              height: 54.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).success(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                          color: LelloTheme.palleteOf(theme).customColor())),
                ),
                child: Text(
                  getString(context, "reports_register_new_report"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                onPressed: () {
                  controller.createNewReport();
                  Navigator.popAndPushNamed(
                    context,
                    ApplicationRoute.registerNewReport,
                    arguments: RegisterNewReportPageArgs(
                      controller: controller,
                      isSucess: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildError(ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                getString(context, "reports_create_error"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).customColor(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
