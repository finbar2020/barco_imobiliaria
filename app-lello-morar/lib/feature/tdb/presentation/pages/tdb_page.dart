import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:morar/feature/tdb/domain/entity/tdb_info.dart';
import 'package:morar/feature/tdb/presentation/bloc/tdb_state.dart';
import 'package:morar/feature/tdb/presentation/controllers/tdb_controller.dart';
import 'package:morar/feature/tdb/presentation/widget/tdb_on_boarding.dart';
import 'package:morar/feature/tdb/presentation/widget/tdb_redirect_dialog.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class TdbPage extends StatefulWidget {
  const TdbPage({Key? key}) : super(key: key);

  @override
  _TdbPageState createState() => _TdbPageState();
}

class _TdbPageState extends State<TdbPage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  late TDBController controller;
  late SessionBloc sessionBloc;

  @override
  void initState() {
    super.initState();
    controller = ApplicationContainer.instance().resolve<TDBController>();
    sessionBloc = BlocProvider.of(context);
    OwnerAnalyticsLogEvents.logEvent(
      event: AnalyticsEventsOwner.tdbAcessar(),
      userId: sessionBloc.state.session?.me?.id ?? "",
      unitValue: sessionBloc.state.session?.unity?.title?.toString() ?? "",
      referenceValue:
          sessionBloc.state.session?.condominium?.reference?.toString() ?? "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => controller.bloc,
        child: BlocBuilder(
          bloc: controller.bloc,
          builder: (context, state) {
            if (state is LoadingTDBState) {
              return Center(
                child: LoadingWidget(),
              );
            }
            if (state is ErrorTDBState) {
              return _buildFailed();
            }

            if (state is LoadedTDBState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _launchPartnerPage(state.tdbInfo);
              });
              return TdbOnBoardingWidget(
                initLastPage: state.tdbInfo != null,
                onTapRegisterButton: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return TdbRedirectDialog(
                          confirmationButtonFunction: () {
                            controller.getTDB();
                          },
                        );
                      });
                },
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Column _buildFailed() {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: ErrorHandlingWidget(
              reTryFunction: () {
                controller.getTDB();
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

  Future<void> _launchPartnerPage(TDBInfo? tdbInfo) async {
    if (tdbInfo == null) {
      return null;
    }

    if (tdbInfo.urlAndQueries != null) {
      UrlLauncherNative.openUrl(
        tdbInfo.urlAndQueries!.toString(),
        headers: tdbInfo.headers,
      );
    } else {
      UrlLauncherNative.openUrl(
        tdbInfo.redirectLink,
      );
    }
  }
}
