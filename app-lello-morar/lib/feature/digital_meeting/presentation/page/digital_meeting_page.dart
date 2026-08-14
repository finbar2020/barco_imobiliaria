import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_bloc.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_state.dart';
import 'package:morar/feature/digital_meeting/presentation/controller/digital_meeting_controller.dart';
import 'package:morar/feature/digital_meeting/presentation/widget/digital_meeting_widget.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class DigitalMeetingPageArgs {
  String? digitalMeetingNotificationContext;
  bool reviewApp;
  DigitalMeetingPageArgs({
    this.digitalMeetingNotificationContext,
    this.reviewApp = false,
  });
}

class DigitalMeetingPage extends StatefulWidget {
  const DigitalMeetingPage({Key? key}) : super(key: key);

  @override
  _DigitalMeetingPageState createState() => _DigitalMeetingPageState();
}

class _DigitalMeetingPageState extends State<DigitalMeetingPage> {
  DigitalMeetingPageArgs? arguments;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final controller =
      ApplicationContainer.instance().resolve<DigitalMeetingController>();

  @override
  void initState() {
    super.initState();
    controller.getMeetings();
  }

  @override
  Widget build(BuildContext context) {
    arguments =
        ModalRoute.of(context)?.settings.arguments as DigitalMeetingPageArgs?;
    _showReviewDialog(arguments: arguments, context: context);

    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: CustomAppBar(title: "digital_meeting_title"),
          body: BlocBuilder<DigitalMeetingBloc, DigitalMeetingState>(
            bloc: controller.bloc,
            builder: (context, state) {
              if (state is DigitalMeetingInitialState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/ic_billet_alert.svg"),
                              SizedBox(height: Dimens.spacing),
                              Text(
                                getString(context, "digital_meeting_failure"),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is DigitalMeetingLoadingState) {
                return Column(
                  children: [
                    Expanded(
                      child: LoadingWidget(),
                    ),
                  ],
                );
              }
              if (state is DigitalMeetingLoadedState) {
                return Column(
                  children: [
                    Expanded(
                      flex: 7,
                      child: ListView.separated(
                        itemCount: state.meetings.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 1),
                        itemBuilder: (context, index) {
                          return DigitalMeetingWidget(
                            model: state.meetings[index],
                            onTap: () {
                              controller.getWebView(
                                  meeting: state.meetings[index]);
                              Navigator.pushReplacementNamed(
                                context,
                                ApplicationRoute.digitalMeetingWebView,
                              );
                            },
                          );
                        },
                      ),
                    ),
                    SizedBox(height: Dimens.spacingMedium),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                controller.getAllMeetings();
                              },
                              child: Text(
                                "${getString(context, "mailing_all_records")}",
                                style: LelloTextStyles.subBody(theme)!.copyWith(
                                  color:
                                      LelloTheme.palleteOf(theme).textAccent(),
                                ),
                              ),
                            ),
                            SizedBox(height: Dimens.spacingMedium),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is DigitalMeetingShowAllState) {
                return Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: ListView.separated(
                        itemCount: state.meetings.length,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(height: 1),
                        itemBuilder: (context, index) {
                          return IgnorePointer(
                            ignoring: !state.meetings[index].validandoAcesso,
                            child: DigitalMeetingWidget(
                                model: state.meetings[index],
                                onTap: () async {
                                  UrlLauncherNative.openUrl(
                                      state.meetings[index].link.toString());
                                }),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              if (state is DigitalMeetingFailureState) {
                return Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(Dimens.spacingMedium),
                        child: ErrorHandlingWidget(
                          reTryFunction: () {
                            controller.getAllMeetings();
                          },
                          backFunction: () => Navigator.pop(context, true),
                          isProduction: env.isProduction,
                          error: "",
                          errorCode: "",
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is DigitalMeetingInitialState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset("assets/ic_billet_alert.svg"),
                              SizedBox(height: Dimens.spacing),
                              Text(
                                getString(context, "digital_meeting_failure"),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  //Função que verificará se é para exibir Dialog de Avaliação do App.
  //Será exibido caso o usuário tenha voltado de uma assembleia.
  void _showReviewDialog(
      {required DigitalMeetingPageArgs? arguments,
      required BuildContext context}) {
    if (arguments != null) {
      if (arguments.reviewApp == true) {
        Future.delayed(Duration(seconds: 1))
            .then((value) => AppReview.call(context: context));
      }
    }
  }
}
