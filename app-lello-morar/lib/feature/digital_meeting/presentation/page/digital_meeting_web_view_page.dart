import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/white_app_bar.dart';
import 'package:morar/feature/digital_meeting/presentation/bloc/digital_meeting_state.dart';
import 'package:morar/feature/digital_meeting/presentation/controller/digital_meeting_controller.dart';
import 'package:morar/feature/digital_meeting/presentation/page/digital_meeting_page.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class DigitalMeetingWebViewPage extends StatefulWidget {
  const DigitalMeetingWebViewPage({Key? key}) : super(key: key);

  @override
  _DigitalMeetingWebViewPageState createState() =>
      _DigitalMeetingWebViewPageState();
}

class _DigitalMeetingWebViewPageState extends State<DigitalMeetingWebViewPage> {
  bool isLoading = true;
  bool onlyOnce = true;

  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<DigitalMeetingController>();
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        _onWillPop(context);
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: WhiteAppBar(
            isGetString: true,
            onPressed: () {
              _onWillPop(context);
            },
            title: "digital_meeting_title",
          ),
          body: BlocBuilder(
            bloc: controller.bloc,
            builder: (context, state) {
              if (state is DigitalMeetingLoadingState) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(child: CircularProgressIndicator()),
                    SizedBox(height: Dimens.spacing),
                    Center(
                      child: Text(
                        getString(context, "digital_accessing"),
                        style: LelloTextStyles.titleSmall(theme),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Center(
                      child: Text(
                        getString(context, "please_wait"),
                        style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).textOpaque(),
                        ),
                      ),
                    ),
                  ],
                );
              }
              if (state is DigitalMeetingFailureState) {
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
                                getString(context,
                                    "digital_meeting_failure_access_profile"),
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
              if (state is DigitalMeetingWebViewState) {
                if (onlyOnce) {
                  onlyOnce = false;
                  UrlLauncherNative.openUrl(
                    state.meeting.link!,
                  ).then((value) {
                    if (value) {
                      setState(() {
                        controller.getMeetings();
                        Navigator.popAndPushNamed(
                          context,
                          ApplicationRoute.digitalMeeting,
                          arguments:
                              new DigitalMeetingPageArgs(reviewApp: true),
                        );
                        return;
                      });
                    } else {
                      Flushbar(
                        message: getString(context, "warning_failed_message"),
                        duration: Duration(seconds: 3),
                        title: "Ops...",
                        onStatusChanged: (status) {
                          if (status == FlushbarStatus.DISMISSED) {
                            controller.getMeetings();
                            Navigator.popAndPushNamed(
                              context,
                              ApplicationRoute.digitalMeeting,
                              arguments:
                                  new DigitalMeetingPageArgs(reviewApp: false),
                            );
                          }
                        },
                      )..show(context);
                    }
                  });
                }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  void _onWillPop(BuildContext context) {
    Navigator.popAndPushNamed(
      context,
      ApplicationRoute.digitalMeeting,
      arguments: DigitalMeetingPageArgs(reviewApp: true),
    );
  }
}
