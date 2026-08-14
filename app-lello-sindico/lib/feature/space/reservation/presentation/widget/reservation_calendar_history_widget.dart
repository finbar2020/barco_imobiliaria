import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/modal/month_picker.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../page/reservation_history_details_page.dart';

class ReservationCalendarHistoryWidget extends StatefulWidget {
  final Space? space;
  final Function(DateTime, Space)? onDaySelected;
  final SpaceCalendarResponse? spaceCalendarResponse;
  final String? reserveNotificationContext;
  final bool pastIsEnable;

  const ReservationCalendarHistoryWidget(
      {super.key,
      this.space,
      this.onDaySelected,
      this.spaceCalendarResponse,
      this.reserveNotificationContext,
      this.pastIsEnable = false});

  @override
  _ReservationCalendarHistoryWidgetState createState() =>
      _ReservationCalendarHistoryWidgetState();
}

class _ReservationCalendarHistoryWidgetState
    extends State<ReservationCalendarHistoryWidget> {
  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  DateTime _focusedDay = DateTime.now();
  final monthFormat = DateFormat.yMMMM();
  final ReservationCalendarBloc bloc =
      ApplicationContainer.instance().resolve();
  final Map<DateTime, String> _events = <DateTime, String>{};

  String reservationTypeSelector(String reservationType) {
    switch (reservationType) {
      case 'R':
        return 'reserva';
      case 'S':
        return 'sorteio';
      case 'B':
        return 'bloqueio';
      default:
        return 'reserva';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        bloc.beginLoadCalendarHistory();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocConsumer<ReservationCalendarBloc, ReservationCalendarState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is ReservationCalendarHistoryLoadedState &&
                  widget.reserveNotificationContext?.isNotEmpty == true) {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  if (widget.reserveNotificationContext?.isNotEmpty == true &&
                      mounted) {
                    var item = state.reservationResponse
                        ?.cast<ReservationResponse?>()
                        .firstWhere(
                            (element) =>
                                element?.id.toString() ==
                                widget.reserveNotificationContext,
                            orElse: () => null);
                    if (item != null) {
                      List<ReservationResponse> reservationList = state
                          .reservationResponse!
                          .where((reserve) =>
                              reserve.id == item.id && reserve.idStatus != 90)
                          .toList();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        DateTime day = DateFormat('d/M/yyyy')
                            .parse(item.startReservationDate!);
                        return ReservationHistoryDetailsPage(
                          day: day,
                          reservationInDay: reservationList,
                        );
                      }));
                    }
                  }
                });
              }
            },
            builder: (context, state) {
              if (state is ReservationCalendarLoadingState ||
                  state is ReservationCalendarLoadState ||
                  state is DeleteSucessState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                );
              }
              if (state is ReservationCalendarLoadFailedState) {
                return const Padding(
                  padding: EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "Ocorreu um erro ao carregar calendario. Tente novamente mais tarde.",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              }
              if (state is ReservationCalendarHistoryLoadedState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildCalendar(theme, state),
                    const Divider(thickness: 1),
                    _buildLegend(theme),
                  ],
                );
              }
              return const SizedBox.shrink();
            }),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Padding(
      padding: EdgeInsets.all(Dimens.spacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10.0,
                width: 10.0,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: Dimens.spacingXSmall),
              Text(
                'Bloqueio',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.caption(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).greyDarker(),
                ),
              ),
            ],
          ),
          SizedBox(width: Dimens.spacingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10.0,
                width: 10.0,
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: Dimens.spacingXSmall),
              Text(
                'Sorteio',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.caption(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).greyDarker(),
                ),
              ),
            ],
          ),
          SizedBox(width: Dimens.spacingMedium),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10.0,
                width: 10.0,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: Dimens.spacingXSmall),
              Text(
                'Reservada',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.caption(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).greyDarker(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme, state) {
    if (state is ReservationCalendarHistoryLoadedState) {
      _events.clear();
      for (ReservationResponse reservation in state.reservationResponse!) {
        var reservationType = reservation.reservationType!;

        var startDateString = reservation.startReservationDate!;
        var startDate = DateFormat('d/M/yyyy').parse(startDateString);

        var endDateString = reservation.endReservationDate!;

        var endDate = DateFormat('d/M/yyyy').parse(endDateString);

        Duration reservedDays = endDate.difference(startDate);

        if (reservedDays == Duration.zero) {
          _events[startDate] = reservationTypeSelector(reservationType);
        } else {
          _events[startDate] = reservationTypeSelector(reservationType);

          for (var j = 0; j < reservedDays.inDays; j++) {
            _events[startDate.add(Duration(days: j + 1))] =
                reservationTypeSelector(reservationType);
          }
        }
      }
    }
    return TableCalendar(
      focusedDay: _focusedDay,
      lastDay: bloc.getLastDay(),
      firstDay: bloc.getFirstDay(),
      onPageChanged: (focusedDay) => _focusedDay = focusedDay,
      onHeaderTapped: (focusedDay) async {
        final date = await showMonthPicker(
          context: context,
          firstDate: bloc.getFirstDay(),
          lastDate: bloc.getLastDay(),
          initialDate: _focusedDay,
        );
        setState(() {
          if (date == null) {
            return;
          }
          //limitar data final
          if (date.compareTo(bloc.getLastDay()) > 0) {
            _focusedDay = bloc.getLastDay();
            return;
          }
          //limitar data inicial
          if (date.compareTo(bloc.getFirstDay()) < 0) {
            _focusedDay = bloc.getFirstDay();
            return;
          }
          _focusedDay = date;
        });
      },
      calendarFormat: CalendarFormat.month,
      onDaySelected: (date, otherDate) {
        List<ReservationResponse> reservationList =
            (state as ReservationCalendarHistoryLoadedState)
                .reservationResponse!
                .where((item) =>
                    DateFormat('d/M/yyyy').parse(item.startReservationDate!) ==
                        DateFormat('d/M/yyyy')
                            .parse(DateFormat("d/M/yyy").format(date)) &&
                    item.idStatus != 90)
                .toList();

        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ReservationHistoryDetailsPage(
            day: date,
            reservationInDay: reservationList,
          );
        }));
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(selectedBuilder: (context, date, _) {
        final today = DateTime.now();
        if (date.day < today.day &&
            date.month <= today.month &&
            date.year <= today.year &&
            !widget.pastIsEnable) {
          return Container(
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            child: Center(
              child: Text(
                '${date.day}',
                style: const TextStyle().copyWith(
                    fontSize: 16.0,
                    color: LelloTheme.palleteOf(theme).textLight()),
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle()
                  .copyWith(fontSize: 16.0, color: theme.primaryColor),
            ),
          ),
        );
      }, outsideBuilder: (context, date, events) {
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle().copyWith(
                  fontSize: 16.0,
                  color: LelloTheme.palleteOf(theme).textLight()),
            ),
          ),
        );
      }, prioritizedBuilder: (context, date, events) {
        final today = DateTime.now();
        if (date.day < today.day &&
            date.month <= today.month &&
            date.year <= today.year &&
            !widget.pastIsEnable) {
          return Container(
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            child: Center(
              child: Text(
                '${date.day}',
                style: const TextStyle().copyWith(
                    fontSize: 16.0,
                    color: LelloTheme.palleteOf(theme).textLight()),
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle().copyWith(
                  fontSize: 16.0, color: LelloTheme.palleteOf(theme).text()),
            ),
          ),
        );
      }, defaultBuilder: (context, date, events) {
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle()
                  .copyWith(fontSize: 16.0, color: theme.primaryColor),
            ),
          ),
        );
      }, todayBuilder: (context, date, events) {
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle()
                  .copyWith(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          ),
        );
      }, markerBuilder: (context, date, holidays) {
        int eventsLength = (state as ReservationCalendarHistoryLoadedState)
            .reservationResponse!
            .where((item) =>
                DateFormat('d/M/yyyy').parse(item.startReservationDate!) ==
                    DateFormat('d/M/yyyy')
                        .parse(DateFormat("d/M/yyy").format(date)) &&
                item.idStatus != 90)
            .toList()
            .length;
        return Stack(children: [
          Builder(
            builder: (context) {
              DateTime newDate = _events.keys.firstWhere(
                  (element) =>
                      DateFormat("yyyy-MM-dd hh:mm:ss").format(element) ==
                      DateFormat("yyyy-MM-dd hh:mm:ss").format(date),
                  orElse: () =>
                      DateTime.now().subtract(const Duration(days: 2)));
              if (newDate != DateTime.now().subtract(const Duration(days: 2)) &&
                  _events[newDate] == "bloqueio") {
                return Container(
                    height: 32.0,
                    width: 32.0,
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LelloTheme.palleteOf(theme).warning(),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
              } else if (newDate !=
                      DateTime.now().subtract(const Duration(days: 2)) &&
                  _events[newDate] == "reserva") {
                return Container(
                    height: 32.0,
                    width: 32.0,
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: theme.primaryColor,
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
              } else if (newDate !=
                      DateTime.now().subtract(const Duration(days: 2)) &&
                  _events[newDate] == "sorteio") {
                return Container(
                    height: 32.0,
                    width: 32.0,
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: LelloTheme.palleteOf(theme).raffle(),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Text(
                      date.day.toString(),
                      style: const TextStyle(color: Colors.white),
                    ));
              }
              return const SizedBox.shrink();
            },
          ),
          if (eventsLength > 0)
            Positioned(
                right: 0,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: LelloTheme.palleteOf(theme).separator(),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    eventsLength >= 100 ? "99" : eventsLength.toString(),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.captionBold(theme)?.copyWith(
                        //  color: theme.colorScheme.background,
                        ),
                  ),
                ))
        ]);
      }),
    );
  }
}
