import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/access_control/presentation/bloc/access_control_state.dart';
import 'package:morar/feature/access_control/presentation/controllers/access_control_store.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_on_boarding.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_provider_tab.dart';
import 'package:morar/feature/access_control/presentation/widget/access_control_visitant_tab.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class AcessControlPageArgs {
  String? acessControlNotificationContext;
  int? tabIndex;
  bool isGeneric;
  AcessControlPageArgs(
      {this.acessControlNotificationContext,
      this.tabIndex,
      required this.isGeneric});
}

class AccessControlPage extends StatefulWidget {
  const AccessControlPage({Key? key}) : super(key: key);

  @override
  _AccessControlPageState createState() => _AccessControlPageState();
}

class _AccessControlPageState extends State<AccessControlPage>
    with SingleTickerProviderStateMixin {
  late TabController controller;
  int selectedTab = 0;
  AcessControlPageArgs? arguments;

  late SessionBloc sessionBloc;

  AccessControlStore store =
      ApplicationContainer.instance().resolve<AccessControlStore>();

  @override
  void initState() {
    super.initState();
    sessionBloc = BlocProvider.of(context);
    store.getLists(closeOnboarding: false);
    _registerAnalyticsEvent(selectedTab, sessionBloc);
    controller = new TabController(length: 2, vsync: this);
    controller.addListener(() {
      setState(() {
        selectedTab = controller.index;
      });
      _registerAnalyticsEvent(selectedTab, sessionBloc);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    AcessControlPageArgs arguments =
        ModalRoute.of(context)?.settings.arguments as AcessControlPageArgs? ??
            AcessControlPageArgs(isGeneric: false);
    if (arguments.tabIndex != null) {
      controller.animateTo(arguments.tabIndex!);
      arguments.tabIndex = null;
    }
    return WillPopScope(
      onWillPop: () async => true,
      child: Theme(
        data: theme,
        child: BlocBuilder(
          bloc: store.bloc,
          builder: (context, state) {
            return BlocConsumer(
              bloc: store.bloc,
              listener: (context, state) {
                if (state is DeleteVisitState) {
                  Navigator.pushReplacementNamed(
                    context,
                    ApplicationRoute.accessControlAttention,
                    arguments: "access_control_deleted_visit",
                  );
                }
                if (state is DeleteFailureVisitState) {
                  Flushbar(
                    message: getString(context, "warning_failed_message"),
                    duration: Duration(seconds: 2),
                  )..show(context);
                }
              },
              builder: (context, state) {
                if (state is AccessControlOnBoardingState) {
                  return AccessControlOnBoardingWidget(
                    store: store,
                    isGeneric: arguments.isGeneric,
                  );
                }
                return Scaffold(
                  appBar: _buildAppBar(context, theme),
                  body: TabBarView(
                    controller: controller,
                    children: [
                      AccessControlVisitantTab(
                        accessControlStore: store,
                        sessionBloc: sessionBloc,
                        arguments: arguments,
                      ),
                      AccessControlProviderTab(
                        accessControlStore: store,
                        sessionBloc: sessionBloc,
                        arguments: arguments,
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Text(getString(context, "access_control_title"),
          textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
      centerTitle: true,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12),
          bottomLeft: Radius.circular(12),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            color: LelloTheme.palleteOf(theme).backgroundDark(),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(-12),
              topRight: Radius.circular(-12),
            ),
          ),
          child: TabBar(
            labelColor: theme.primaryColor,
            labelStyle: LelloTextStyles.subBody(theme),
            unselectedLabelColor: LelloTheme.palleteOf(theme).hubText(),
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(
                color: theme.primaryColor,
              ),
            ),
            controller: controller,
            tabs: [
              Tab(
                text: getString(context, "access_control_visitors"),
              ),
              Tab(
                text: getString(context, "access_control_providers"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerAnalyticsEvent(selectedTab, SessionBloc sessionBloc) {
    if (selectedTab == 0 || selectedTab == 1) {
      OwnerAnalyticsLogEvents.logEvent(
        event: selectedTab == 0
            ? AnalyticsEventsOwner.autorizacaoEntradasAcessar()
            : AnalyticsEventsOwner.autorizacaoEntradasAcessarAgendamentos(),
        userId: store.sessionBloc.state.session?.me?.id ?? "",
        unitValue:
            sessionBloc.state.session?.unity?.namedTitle.toString() ?? "",
        referenceValue:
            sessionBloc.state.session?.condominium?.reference?.toString() ?? "",
      );
    }
  }
}
