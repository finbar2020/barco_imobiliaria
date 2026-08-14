import 'dart:async';

import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/domain/entity/space_calendar_response.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

import '../../../../../core/modal/month_picker.dart';

class ReservationCalendarWidget extends StatefulWidget {
  final Space space;
  final Function(DateTime, Space) onDaySelected;
  final SpaceCalendarResponse? spaceCalendarResponse;

  final bool pastIsEnable;

  const ReservationCalendarWidget(
      {Key? key,
      required this.space,
      required this.onDaySelected,
      this.spaceCalendarResponse,
      this.pastIsEnable = false})
      : super(key: key);

  @override
  ReservationCalendarWidgetState createState() =>
      ReservationCalendarWidgetState();
}

class ReservationCalendarWidgetState extends State<ReservationCalendarWidget> {
  final Map<DateTime, String> _events = <DateTime, String>{};

  final _refreshKey = GlobalKey<RefreshIndicatorState>();
  final Completer<void> _refreshCompleter = Completer<void>();
  final monthFormat = DateFormat.yMMMM();
  final ReservationCalendarBloc bloc =
      ApplicationContainer.instance().resolve();

  DateTime _focusedDay = DateTime.now();
  DateTime? selected;

  bool showTip = true;

  @override
  void initState() {
    super.initState();
    bloc.beginLoad(widget.space.id!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      key: _refreshKey,
      onRefresh: () async {
        bloc.beginLoad(widget.space.id!);
        return _refreshCompleter.future;
      },
      child: SingleChildScrollView(
        child: BlocConsumer<ReservationCalendarBloc, ReservationCalendarState>(
            bloc: bloc,
            listener: (context, state) {},
            builder: (context, state) {
              if (state is ReservationCalendarLoadingState) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height / 2.0,
                  child: const Center(
                    child: LoadingWidget(),
                  ),
                );
              }
              return Column(
                children: [
                  _buildCalendar(theme, state),
                  const Divider(thickness: 1),
                  const SizedBox(height: 10),
                  _buildLegend(theme),
                  SizedBox(
                    height: Dimens.spacingLarge,
                  ),
                  Visibility(
                      replacement: Container(),
                      visible: showTip,
                      child: Center(
                        child: Text(
                          'Selecione um dia disponivel para continuar',
                          style: LelloTextStyles.subtitleBold(theme),
                        ),
                      )),
                ],
              );
            }),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  left: Dimens.spacingMedium, right: Dimens.spacingSmall),
              child: Container(
                height: 10.0,
                width: 10.0,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const Text('Bloqueio')
          ],
        ),
        SizedBox(width: Dimens.spacingMedium),
        if (widget.space.type!.id != "M")
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 10.0,
                  width: 10.0,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              const Text('Sorteio'),
              SizedBox(width: Dimens.spacingMedium),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 10.0,
                width: 10.0,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                right: Dimens.spacingMedium,
              ),
              child: const Text('Reservada'),
            ),
          ],
        ),
      ],
    );
  }

  bool _validateDate(DateTime date) {
    final today = DateTime.now();
    if (widget.pastIsEnable) return true;
    if (date.month == today.month &&
        date.day >= today.day &&
        date.year >= today.year) return true;
    if (date.month > today.month && date.year >= today.year) return true;
    return false;
  }

  Widget _buildCalendar(ThemeData theme, ReservationCalendarState state) {
    if (state is ReservationCalendarLoadedState) {
      for (var i = 0; i < state.data!.lockedDays!.length; i++) {
        DateTime tempDate =
            DateFormat("dd/MM/yyyy").parse(state.data!.lockedDays![i]);

        _events[tempDate] = 'bloqueio';
      }

      for (var i = 0; i < state.data!.alreadyReservatedDays!.length; i++) {
        DateTime tempDate = DateFormat("dd/MM/yyyy")
            .parse(state.data!.alreadyReservatedDays![i]);

        _events[tempDate] = 'reserva';
      }
      for (var i = 0; i < state.data!.raffledDays!.length; i++) {
        DateTime tempDate =
            DateFormat("dd/MM/yyyy").parse(state.data!.raffledDays![i]);

        _events[tempDate] = 'sorteio';
      }

      if (state.data!.freeToReserveDays!.isNotEmpty) {}
    }

    return TableCalendar(
      focusedDay: _focusedDay,
      firstDay: DateTime.now().firstDayOfMonth(),
      lastDay: bloc.getLastDay(),
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
          //prevents user from selecting a date outside the range
          if (date.compareTo(bloc.getLastDay()) > 0) {
            _focusedDay = bloc.getLastDay();
            return;
          }
          if (date.compareTo(bloc.getFirstDay()) < 0) {
            _focusedDay = bloc.getFirstDay();
            return;
          }
          _focusedDay = date;
        });
      },
      selectedDayPredicate: (day) {
        return isSameDay(selected, day);
      },
      calendarFormat: CalendarFormat.month,
      onPageChanged: (date) {
        _focusedDay = date;
      },

      //? não é necessário pois o calendário já bloqueia os dias anteriores
      // enabledDayPredicate: (date) {
      //   if (date.isBefore(bloc.getFirstDay()) &&
      //       !isSameDay(bloc.getFirstDay(), date)) {
      //     return false;
      //   }
      //   return true;
      // },
      onDaySelected: (date, event) async {
        String dateFormatted = DateFormat("dd/MM/yyyy").format(date);
        setState(() {
          showTip = false;
        });

        if (state.data == null) {
          //exibir dialod de erro
          await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Erro'),
                content: const Text(
                    'Ocorreu um erro ao carregar as informações do calendário'),
                actions: [
                  TextButton(
                    onPressed: () {
                      //print curent route stack
                      Navigator.popUntil(
                          context,
                          ModalRoute.withName(ApplicationRoute
                              .spaceReservationRegistrationSpace));
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            },
          );
          return;
        }

        if ((state.data?.alreadyReservatedDays ?? []).contains(dateFormatted)) {
          return await showDialog(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'O dia selecionado já está reservado, por favor selecione outro',
                          // getString(context, "register_payment_confirmation_title"),
                          textAlign: TextAlign.left,
                          style: LelloTextStyles.subtitle(theme)),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Entendi'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (state.data!.lockedDays!.contains(dateFormatted)) {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'Existe um bloqueio para esse dia, por favor selecione outro',
                          // getString(context, "register_payment_confirmation_title"),
                          textAlign: TextAlign.left,
                          style: LelloTextStyles.subtitle(theme)),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Entendi'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (state.data!.raffledDays!.contains(dateFormatted)) {
          return showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text(
                          'O dia selecionado será reservado mediante sorteio. Para inscrever a unidade, acesse o reserva de áreas pelo portal',
                          // getString(context, "register_payment_confirmation_title"),
                          textAlign: TextAlign.left,
                          style: LelloTextStyles.subtitle(theme)),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Entendi'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else if (state.data!.freeToReserveDays!.contains(dateFormatted)) {
          setState(() {
            selected = date;
            _focusedDay = event;
          });
          widget.onDaySelected.call(date, widget.space);
        }
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarBuilders: CalendarBuilders(disabledBuilder: (context, date, _) {
        return Container(
            height: 32.0,
            width: 32.0,
            margin: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
            child: Text(
              date.day.toString(),
              style: TextStyle(color: LelloTheme.palleteOf(theme).textLight()),
            ));
      }, selectedBuilder: (context, date, _) {
        return Container(
          margin: const EdgeInsets.all(5.0),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle()
                  .copyWith(fontSize: 16.0, color: Colors.white),
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
                  .copyWith(fontSize: 16.0, color: Colors.black),
            ),
          ),
        );
      }, todayBuilder: (context, date, events) {
        return Container(
          padding: const EdgeInsets.only(top: 5.0, left: 6.0),
          child: Center(
            child: Text(
              '${date.day}',
              style: const TextStyle().copyWith(fontSize: 16.0),
            ),
          ),
        );
      }, markerBuilder: (context, date, holidays) {
        DateTime newDate = _events.keys.firstWhere(
            (element) =>
                DateFormat("yyyy-MM-dd hh:mm:ss").format(element) ==
                DateFormat("yyyy-MM-dd hh:mm:ss").format(date),
            orElse: () => DateTime.now().subtract(const Duration(days: 2)));
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
        return null;
      }),
    );
  }
}
