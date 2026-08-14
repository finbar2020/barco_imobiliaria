import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:essentials/configs/environment.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_new_reserve_page.dart';
import 'package:morar/feature/reservation/presentation/page/reservation_schedules_page.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';

class ReservationPageArgs {
  String? reserveNotificationContext;
  int? selectedTab;
  ReservationPageArgs({this.reserveNotificationContext, this.selectedTab});
}

class ReservationPage extends StatefulWidget {
  const ReservationPage({Key? key}) : super(key: key);

  @override
  _ReservationPageState createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage>
    with SingleTickerProviderStateMixin {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  late TabController controller;
  final bloc = ApplicationContainer.instance().resolve<ReservationBloc>();
  int selectedTab = 0;
  ReservationPageArgs? arguments;

  @override
  void initState() {
    super.initState();
    final SessionBloc sessionBloc = BlocProvider.of(context);

    _registerAnalyticsEvent(selectedTab, sessionBloc);
    controller = TabController(length: 2, vsync: this);
    bloc.setTabController(controller);
    controller.addListener(() {
      setState(() {
        selectedTab = controller.index;
      });
      _registerAnalyticsEvent(selectedTab, sessionBloc);
    });

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (arguments?.selectedTab != null) {
        controller.animateTo(arguments!.selectedTab!);
      } else if (arguments?.reserveNotificationContext != null && mounted) {
        controller.animateTo(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    arguments =
        ModalRoute.of(context)!.settings.arguments as ReservationPageArgs?;

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          appBar: AppBar(
            title: Text(getString(context, "reserves"),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white)),
            centerTitle: true,
            iconTheme:
                IconThemeData(color: LelloTheme.palleteOf(theme).customColor()),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12),
                    bottomLeft: Radius.circular(12))),
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
                  labelStyle:
                      LelloTextStyles.subBody(theme)?.copyWith(shadows: []),
                  unselectedLabelStyle:
                      LelloTextStyles.subBody(theme)?.copyWith(shadows: []),
                  unselectedLabelColor:
                      LelloTheme.palleteOf(theme).textOpaque(),
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                      color: theme.primaryColor,
                    ),
                  ),
                  controller: controller,
                  tabs: [
                    Tab(
                      text: getString(context, "reserve_new"),
                    ),
                    Tab(
                      text: getString(context, "reserve_schedule"),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: BlocProvider(
            create: (context) => bloc,
            child: TabBarView(
              controller: controller,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ReservationNewReservePage(),
                ReservationSchedulesPage(arguments: arguments)
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registerAnalyticsEvent(selectedTab, SessionBloc sessionBloc) {
    if (selectedTab == 0 || selectedTab == 1) {
      OwnerAnalyticsLogEvents.logEvent(
        event: selectedTab == 0
            ? AnalyticsEventsOwner.reservasAcessar()
            : AnalyticsEventsOwner.reservasAcessarAgendamentos(),
        userId: sessionBloc.state.session?.me?.id ?? "",
        unitValue:
            sessionBloc.state.session!.unity?.namedTitle.toString() ?? "",
        referenceValue:
            sessionBloc.state.session!.condominium?.reference?.toString() ?? "",
      );
    }
  }
}
