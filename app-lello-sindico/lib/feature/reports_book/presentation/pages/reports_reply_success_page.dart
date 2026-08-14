import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/reports_book/domain/entity/report.dart';
import 'package:lello/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:lello/feature/reports_book/presentation/controller/report_controller.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReportsReplySuccessPageArgs {
  final Report report;
  ReportsReplySuccessPageArgs({required this.report});
}

class ReportsReplySuccessPage extends StatelessWidget {
  const ReportsReplySuccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late Report report;
    ReportsReplySuccessPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as ReportsReplySuccessPageArgs;
    report = arguments.report;

    final ReportController controller =
        ApplicationContainer.instance().resolve<ReportController>();

    final theme = LelloTheme.dark;
    return Theme(
      data: theme,
      child: BlocConsumer(
        listener: (context, state) {
          if (state is ReportClosedState) {
            Navigator.pushReplacementNamed(
                context, ApplicationRoute.reportsCloseReportSuccess);
          }
          if (controller.reportsBloc.state is ReportsFailureState) {
            Navigator.pop(context);
          }
        },
        bloc: controller.reportsBloc,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: LelloTheme.palleteOf(theme).success(),
            body: Padding(
              padding: EdgeInsets.all(Dimens.spacingLarge),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset("assets/ic_success.svg",
                        width: 92, height: 92),
                    SizedBox(height: Dimens.spacingLarge),
                    Text(getString(context, "reports_reply_success"),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.headline(theme)!
                            .copyWith(color: Colors.white)),
                    SizedBox(height: Dimens.spacingSmall),
                    Text(getString(context, "reports_reply_success_subtitle"),
                        textAlign: TextAlign.center,
                        style: LelloTextStyles.subtitle(theme)),
                    SizedBox(height: Dimens.spacingLarge),
                    PrimaryButton(
                      buttonColor: Colors.white,
                      onPressed: () {
                        if (state is! ReportLoadingState) {
                          controller.closeReport(report: report);
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              state is ReportLoadingState
                                  ? getString(context, "reports_closing_report")
                                  : getString(context, "reports_close_report"),
                              textAlign: TextAlign.center,
                              style: LelloTextStyles.button(theme)!.copyWith(
                                color:
                                    LelloTheme.palleteOf(theme).customColor(),
                              ),
                            ),
                          ),
                          if (state is ReportLoadingState)
                            const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: LoadingWidget(),
                            ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: Dimens.spacingLarge),
                      child: SizedBox(
                        width: double.infinity,
                        height: 54.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                LelloTheme.palleteOf(theme).success(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.white),
                            ),
                          ),
                          child: Text(
                            getString(context, "reports_keep_open_report"),
                            style: LelloTextStyles.button(theme)!
                                .copyWith(color: Colors.white),
                          ),
                          onPressed: () {
                            if (state is! ReportLoadingState) {
                              Navigator.pop(context);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
