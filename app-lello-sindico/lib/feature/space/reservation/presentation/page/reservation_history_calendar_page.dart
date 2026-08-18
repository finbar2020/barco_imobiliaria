import 'dart:developer';

import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_summary_list_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_calendar_history_widget.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class ReservationHistoryCalendarPage extends StatefulWidget {
  final String? spaceNotificationContext;
  const ReservationHistoryCalendarPage(
      {super.key, this.spaceNotificationContext});
  @override
  ReservationHistoryCalendarPageState createState() =>
      ReservationHistoryCalendarPageState();
}

class ReservationHistoryCalendarPageState
    extends State<ReservationHistoryCalendarPage> {
  var filter = ReservationSummaryListFilter();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Environment env = ApplicationContainer.instance().resolve<Environment>();

  final ReservationCalendarBloc bloc =
      ApplicationContainer.instance().resolve();

  @override
  void initState() {
    super.initState();
    bloc.beginLoadCalendarHistory();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    DateTime? selectedDay;
    String? selectedHours;

    return Theme(
      data: theme,
      child: Scaffold(
          key: scaffoldKey,
          appBar: PrimaryAppBar(
            iconColor: theme.primaryColor,
            theme: theme,
            title: _getTitle(),
          ),
          body: BlocConsumer<ReservationCalendarBloc, ReservationCalendarState>(
            bloc: bloc,
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              if (state is ReservationCalendarLoadFailedState) {
                return Padding(
                  padding: EdgeInsets.all(Dimens.spacingSmall),
                  child: ErrorHandlingWidget(
                    reTryFunction: () {
                      bloc.beginLoadCalendarHistory();
                    },
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                    error: state.error.error?.toString() ??
                        "Ocorreu um erro ao carregar calendario. Tente novamente mais tarde.",
                    errorCode: state.error.code?.toString() ?? "",
                    textReturnButton: "back_to_the_previous_page",
                  ),
                );
              }
              return SingleChildScrollView(
                child: WillPopScope(
                    onWillPop: () async {
                      if (filter.type == null) {
                        return true;
                      } else {
                        setState(() {
                          filter.type = null;
                        });
                        return false;
                      }
                    },
                    child: _buildBody(
                        space: Space(),
                        state: state,
                        unit: Unit(),
                        bloc: bloc,
                        onDateSelected: (DateTime date) {
                          setState(() {
                            selectedDay = date;
                          });
                          log(selectedDay.toString());
                        },
                        onHoursSelected: (String hours) {
                          setState(() {
                            selectedHours = hours;
                            log(selectedHours.toString());
                          });
                        },
                        onSubmit: () {})),
              );
            },
          )),
    );
  }

  Widget _buildBody(
      {required Space space,
      required Unit unit,
      required ReservationCalendarState state,
      required ReservationCalendarBloc bloc,
      required Function(DateTime) onDateSelected,
      required Function(String) onHoursSelected,
      required Function onSubmit}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ReservationCalendarHistoryWidget(
        reserveNotificationContext: widget.spaceNotificationContext,
        space: space,
        onDaySelected: (date, Space space) async {
          state.selectedDay = date;
        },
        pastIsEnable: false,
      ),
    ]);
  }

  String _getTitle() {
    switch (filter.type) {
      case ReservationType.maintenance:
        return "${getString(context, "space_reservation_filter")} - ${getString(context, "space_reservation_maintenance")}";
      case ReservationType.raffle:
        return "${getString(context, "space_reservation_filter")} - ${getString(context, "space_reservation_raffle")}";
      case ReservationType.reservation:
        return "${getString(context, "space_reservation_filter")} - ${getString(context, "space_reservation_reservation")}";
      default:
        return getString(context, "space_reservation_agenda");
    }
  }
}
