import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/core/widget/loading_widget.dart';

import 'package:lello/feature/agreements/presentation/bloc/agreements_bloc.dart';
import 'package:lello/feature/agreements/presentation/bloc/agreements_state.dart';
import 'package:lello/feature/agreements/presentation/controllers/agreements_controller.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_in_progress/agreements_in_progress_page.dart';
import 'package:lello/feature/agreements/presentation/page/agreements_proposals/agreements_proposals_page.dart';
import 'package:lello/feature/agreements/presentation/widgets/agreements_option.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class AgreementsPageArgs {
  String? agreementsNotificationContext;
  FeaturesRoutesEnum? route;
  AgreementsPageArgs({
    this.agreementsNotificationContext,
    this.route,
  });
}

class AgreementsPage extends StatefulWidget {
  const AgreementsPage({Key? key}) : super(key: key);

  @override
  AgreementsPageState createState() => AgreementsPageState();
}

class AgreementsPageState extends State<AgreementsPage> {
  final controller =
      ApplicationContainer.instance().resolve<AgreementsController>();
  PackageInfo? packageInfo;
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  AgreementsPageArgs? arguments;
  bool redirect = false;

  @override
  void initState() {
    controller.pipeline();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String reference = controller
            .sessionBloc.state.session!.selectedCondominium?.reference
            .toString() ??
        "";
    final theme = Theme.of(context);
    arguments =
        ModalRoute.of(context)!.settings.arguments as AgreementsPageArgs?;

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
          title: getString(context, "agreements_title"),
          theme: theme,
        ),
        body: BlocBuilder<AgreementsBloc, AgreementsState>(
          bloc: controller.agreementsBloc,
          builder: (context, state) {
            if (state is AgreementsLoadingState) {
              return const Column(
                children: [
                  Expanded(child: LoadingWidget()),
                ],
              );
            }

            if (state is AgreementsErrorState) {
              return Padding(
                padding: EdgeInsets.all(Dimens.spacingMedium),
                child: ErrorHandlingWidget(
                  reTryFunction: () {
                    controller.pipeline();
                  },
                  backFunction: () => Navigator.pop(context, true),
                  isProduction: env.isProduction,
                  error: state.error?.error.toString() ?? "",
                  errorCode: state.error?.code.toString() ?? "",
                  subTitle: "agreements_all_error",
                ),
              );
            }

            if (state is AgreementsSuccessState) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
                if (arguments?.route != null && redirect == false) {
                  if (arguments?.route ==
                      FeaturesRoutesEnum.ACORDO_APROVADO_AUTOMATICAMENTE) {
                    ManagerAnalyticsLogEvents.logEvent(
                        event:
                            AnalyticsEventsManager.acordosEmProgressoAcessar(),
                        referenceValue: reference);
                    redirect = true;
                    await Navigator.pushNamed(
                      context,
                      ApplicationRoute.agreementsInProgress,
                      arguments: AgreementsInProgressPageArgs(
                          agreementsNotificationContext:
                              arguments?.agreementsNotificationContext),
                    );
                  } else {
                    ManagerAnalyticsLogEvents.logEvent(
                        event: AnalyticsEventsManager.acordosPendentesAcessar(),
                        referenceValue: reference);
                    redirect = true;
                    await Navigator.pushNamed(
                      context,
                      ApplicationRoute.agreementsProposals,
                      arguments: AgreementsProposalsPageArgs(
                          agreementsNotificationContext:
                              arguments?.agreementsNotificationContext),
                    );
                  }
                }
              });
              return SingleChildScrollView(
                child: Column(
                  children: [
                    const Divider(height: 2.0),
                    SizedBox(height: Dimens.spacingSmall),
                    AgreementsOption(
                      iconKey: "assets/ic_agreements_analysis.svg",
                      titleKey: "agreements_analysis",
                      optionIndex: null,
                      onTap: () {
                        ManagerAnalyticsLogEvents.logEvent(
                            event: AnalyticsEventsManager
                                .acordosRelatorioAcessar(),
                            referenceValue: reference);
                        controller.getAnalysis().then(
                              (value) => Navigator.pushNamed(
                                context,
                                ApplicationRoute.agreementsAnalysis,
                              ),
                            );
                      },
                    ),
                    AgreementsOption(
                      iconKey: "assets/ic_agreements_proposals.svg",
                      titleKey: "agreements_proposals",
                      optionIndex: controller
                          .agreementsAllInfo?.agreementsProposals.length,
                      onTap: () {
                        ManagerAnalyticsLogEvents.logEvent(
                            event: AnalyticsEventsManager
                                .acordosPendentesAcessar(),
                            referenceValue: reference);
                        Navigator.pushNamed(
                          context,
                          ApplicationRoute.agreementsProposals,
                        );
                      },
                    ),
                    AgreementsOption(
                      iconKey: "assets/ic_agreements_in_progress.svg",
                      titleKey: "agreements_in_progress",
                      optionIndex: controller
                          .agreementsAllInfo?.agreementsInProgress.length,
                      onTap: () {
                        ManagerAnalyticsLogEvents.logEvent(
                            event: AnalyticsEventsManager
                                .acordosEmProgressoAcessar(),
                            referenceValue: reference);
                        Navigator.pushNamed(
                          context,
                          ApplicationRoute.agreementsInProgress,
                        );
                      },
                    ),
                    AgreementsOption(
                      iconKey: "assets/ic_agreements_history.svg",
                      titleKey: "agreements_history",
                      optionIndex: null,
                      onTap: () {
                        ManagerAnalyticsLogEvents.logEvent(
                            event: AnalyticsEventsManager
                                .acordosHistoricoAcessar(),
                            referenceValue: reference);
                        Navigator.pushNamed(
                          context,
                          ApplicationRoute.agreementsHistory,
                        );
                      },
                    ),
                    AgreementsOption(
                      iconKey: "assets/ic_agreements_rules.svg",
                      titleKey: "agreements_rules",
                      optionIndex: null,
                      onTap: () {
                        ManagerAnalyticsLogEvents.logEvent(
                            event:
                                AnalyticsEventsManager.acordosRegrasAcessar(),
                            referenceValue: reference);
                        Navigator.pushNamed(
                          context,
                          ApplicationRoute.agreementsRules,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  bool _isGeneric() {
    String packageName = _getPackageName();
    return packageName == SharedPreferencesKeys.genericSindico ||
        packageName == SharedPreferencesKeys.genericSindico;
  }

  String _getPackageName() {
    if (packageInfo != null) {
      return packageInfo!.packageName;
    } else {
      PackageInfo.fromPlatform().then((value) {
        setState(() {
          packageInfo = value;
        });
      });
      return "";
    }
  }

  String changeLelloForCompanyName(BuildContext context, String getText) {
    if (_isGeneric()) {
      var textFormatted = getString(context, getText);
      if (textFormatted.isNotEmpty) {
        return textFormatted.replaceAll("Lello", packageInfo!.appName);
      } else {
        return getString(context, getText);
      }
    } else {
      return getString(context, getText);
    }
  }
}
