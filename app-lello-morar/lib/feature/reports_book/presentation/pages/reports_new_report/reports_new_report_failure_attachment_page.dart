import 'dart:io';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/reports_book/domain/entity/report.dart';
import 'package:morar/feature/reports_book/domain/entity/report_contents.dart';
import 'package:morar/feature/reports_book/presentation/bloc/reports_state.dart';
import 'package:morar/feature/reports_book/presentation/controller/reports_controller.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class ReportsNewReportFailureAttachmentPageArg {
  final ReportsController controller;
  final Report report;
  final ReportContents content;
  final File attachment;

  ReportsNewReportFailureAttachmentPageArg(
      {required this.controller,
      required this.report,
      required this.content,
      required this.attachment});
}

class ReportsNewReportFailureAttachmentPage extends StatefulWidget {
  const ReportsNewReportFailureAttachmentPage({Key? key}) : super(key: key);

  @override
  _ReportsNewReportFailureAttachmentPageState createState() =>
      _ReportsNewReportFailureAttachmentPageState();
}

class _ReportsNewReportFailureAttachmentPageState
    extends State<ReportsNewReportFailureAttachmentPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
    ReportsNewReportFailureAttachmentPageArg arguments = ModalRoute.of(context)!
        .settings
        .arguments as ReportsNewReportFailureAttachmentPageArg;
    final ReportsController controller = arguments.controller;

    return Theme(
      data: theme,
      child: BlocConsumer(
        bloc: controller.reportsBloc,
        listener: (context, state) {
          if (state is ReportPostedState) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              ApplicationRoute.newReportSuccess,
              ModalRoute.withName(ApplicationRoute.reports),
              arguments: [controller],
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is ReportsLoadingState;
          print(isLoading);
          return BlocBuilder(
            bloc: controller.reportsBloc,
            builder: (context, state) {
              return WillPopScope(
                onWillPop: () async {
                  controller.getAllReports();
                  return true;
                },
                child: Scaffold(
                  backgroundColor: LelloTheme.palleteOf(theme).warning(),
                  body: Padding(
                    padding: EdgeInsets.all(Dimens.spacingLarge),
                    child: Column(
                      children: [
                        Expanded(
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SvgPicture.asset("assets/ic_blocked_info.svg",
                                    width: 92, height: 92),
                                SizedBox(height: Dimens.spacingLarge),
                                Text(
                                  getString(context, 'reports_reply_success'),
                                  textAlign: TextAlign.center,
                                  style:
                                      LelloTextStyles.headline(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                Text(
                                  '${getString(context, "reports_report")} #${arguments.report.numReport}',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  style: LelloTextStyles.title(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                Text(
                                  '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                                  textAlign: TextAlign.center,
                                  style:
                                      LelloTextStyles.subtitle(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
                                  ),
                                ),
                                SizedBox(height: Dimens.spacingMedium),
                                Text(
                                  getString(context,
                                      'reports_attachment_failure_text'),
                                  textAlign: TextAlign.center,
                                  style:
                                      LelloTextStyles.subtitle(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme)
                                        .customColor(),
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
                              disabledForegroundColor:
                                  LelloTheme.palleteOf(theme)
                                      .customColor()
                                      .withOpacity(1),
                              disabledBackgroundColor:
                                  LelloTheme.palleteOf(theme)
                                      .customColor()
                                      .withOpacity(1),
                              backgroundColor:
                                  LelloTheme.palleteOf(theme).customColor(),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          LelloTheme.palleteOf(theme).primary(),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        getString(context, "resending"),
                                        style: LelloTextStyles.button(theme)!
                                            .copyWith(
                                          color: LelloTheme.palleteOf(theme)
                                              .text(),
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    getString(context, "try_again"),
                                    style:
                                        LelloTextStyles.button(theme)!.copyWith(
                                      color: LelloTheme.palleteOf(theme).text(),
                                    ),
                                  ),
                            onPressed: isLoading
                                ? null
                                : () async {
                                    await controller.putAttachment(
                                        arguments.report,
                                        arguments.content,
                                        arguments.attachment,
                                        true);
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
                                backgroundColor:
                                    LelloTheme.palleteOf(theme).customColor(),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                getString(context, "conclude"),
                                style: LelloTextStyles.button(theme)!.copyWith(
                                    color: LelloTheme.palleteOf(theme).text()),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () {
                                      AppReview.call(context: context);
                                      controller.showFirstEvent();
                                      Navigator.pop(
                                          context,
                                          (state is ReportPostedState)
                                              ? state.report
                                              : null);
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
          );
        },
      ),
    );
  }
}
