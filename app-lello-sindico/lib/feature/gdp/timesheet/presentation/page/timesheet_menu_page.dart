import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/loading_widget.dart';
import 'package:lello/feature/gdp/timesheet/domain/entity/timesheet_occurrence_type_enum.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_bloc.dart';
import 'package:lello/feature/gdp/timesheet/presentation/bloc/timesheet_month_resume/timesheet_menu_state.dart';
import 'package:lello/feature/gdp/timesheet/presentation/controllers/day_appointments_controller.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_occurence_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/page/timesheet_point_mirror_page.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/day_appointments/day_appointments_widget.dart';
import 'package:lello/feature/gdp/timesheet/presentation/widgets/month_resume/timesheet_menu_month_resume_widget.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';

class TimesheetMenuPagePageArgs {
  String gdpNotificationContext;
  FeaturesRoutesEnum route;

  TimesheetMenuPagePageArgs({
    required this.gdpNotificationContext,
    required this.route,
  });
}

class TimesheetMenuPage extends StatefulWidget {
  const TimesheetMenuPage({super.key});

  @override
  State<TimesheetMenuPage> createState() => _TimesheetMenuPageState();
}

class _TimesheetMenuPageState extends State<TimesheetMenuPage> {
  bool realizedRedirect = false;

  DayAppointmentsController dayAppointmentController =
      ApplicationContainer.instance().resolve<DayAppointmentsController>();

  final TimesheetMenuBloc bloc = ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    bloc.getPeriods();
    dayAppointmentController.getAppointments();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments;
    TimesheetMenuPagePageArgs? redirect;
    if (arguments is TimesheetMenuPagePageArgs) {
      redirect = arguments;
    }
    if (redirect != null && !realizedRedirect) {
      redirectFromNotification(redirect);
    }

    return Theme(
      data: theme,
      child: BlocConsumer<TimesheetMenuBloc, TimesheetMenuState>(
        bloc: bloc,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is TimesheetLoadingState) {
            return const Material(child: LoadingWidget());
          } else if (state is TimesheetFailedState) {
            return Material(
                child: ErrorHandlingWidget(
              isProduction: true,
              reTryFunction: () => bloc.getPeriods(),
              backFunction: () => Navigator.pop(context),
            ));
          } else {
            return DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: PrimaryAppBar(
                  iconColor: theme.primaryColor,
                  theme: theme,
                  title: getString(context, "gdp_timesheet_appBar"),
                  tabs: PreferredSize(
                    preferredSize: const Size(double.infinity, 40.0),
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        indicatorColor: theme.primaryColor,
                        labelColor: theme.primaryColor,
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.bold),
                        tabs: [
                          Tab(
                            text:
                                getString(context, "gdp_timesheet_tab_overview")
                                    .toUpperCase(),
                          ),
                          Tab(
                              text: getString(
                                      context, "gdp_timesheet_tab_mark_day")
                                  .toUpperCase()),
                        ],
                      ),
                    ),
                  ),
                ),
                body: TabBarView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
                      child: TimesheetMenuMonthResumeWidget(bloc: bloc),
                    ),
                    DismissKeyboard(
                        child: DayAppointmentsWidget(
                      controller: dayAppointmentController,
                      dateList: bloc.listPeriods,
                    )),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  redirectFromNotification(TimesheetMenuPagePageArgs redirect) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      realizedRedirect = true;
      switch (redirect.route) {
        case FeaturesRoutesEnum.ALERTA_FALTAS:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimesheetOccurrencePage(
                  date: bloc.selectDate,
                  dateList: bloc.listPeriods,
                  initialFilter: TimesheetOccurrenceTypeEnum.fouls),
            ),
          );
          break;
        case FeaturesRoutesEnum.ALERTA_HORAS_ATRASO:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimesheetOccurrencePage(
                  date: bloc.selectDate,
                  dateList: bloc.listPeriods,
                  initialFilter: TimesheetOccurrenceTypeEnum.delay),
            ),
          );
          break;
        case FeaturesRoutesEnum.ALERTA_ASSINATURA_SINDICO:
        case FeaturesRoutesEnum.ALERTA_ASSINATURA_FUNCIONARIO:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TimesheetPointMirrorPage(
                  date: bloc.selectDate, dateList: bloc.listPeriods),
            ),
          );
          break;
        //case FeaturesRoutesEnum.ALERTA_HORAS_EXTRAS:
        default:
          break;
      }
    });
  }
}
