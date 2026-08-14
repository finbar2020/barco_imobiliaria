import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_change_calendar/reservation_change_calendar_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

class ReservationChangeCalendarPage extends StatefulWidget {
  const ReservationChangeCalendarPage({Key? key}) : super(key: key);

  @override
  _ReservationChangeCalendarPageState createState() =>
      _ReservationChangeCalendarPageState();
}

class _ReservationChangeCalendarPageState
    extends State<ReservationChangeCalendarPage> {
  ReservationChangeCalendarBloc bloc =
      ApplicationContainer.instance().resolve();

  Unit? selectedUnit;
  String? selectedHour;
  //TODO: REFATORAR PRA CHAMADA DE UNITS/HORARIOS NO BLOC
  List<String> horas = [
    "09:00 ás 10:00",
    "08:00 ás 11:00",
    "09:00 ás 20:00",
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: PrimaryAppBar(
          theme: theme,
          title: getString(context, "space_change_scheduled"),
        ),
        body: BlocBuilder(
          bloc: bloc,
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 25.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: _buildCalendar(theme),
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: _buildLegend(theme),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Center(
                      child: Text(
                        "Selecione um dia disponível para continuar",
                        style: LelloTextStyles.bodyBold(theme),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingLarge),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('Qual unidade desejada?'),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    _buildUnitsDropDown(
                        state as ReservationChangeCalendarState),
                    SizedBox(height: Dimens.spacing),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text('Horário'),
                    ),
                    SizedBox(height: Dimens.spacingSmall),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: DropdownButtonFormField(
                        isExpanded: false,
                        hint: const Text('Selecione'),
                        onSaved: (value) {
                          setState(() {
                            selectedHour = value as String;
                          });
                        },
                        value: selectedHour,
                        items: horas
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            // selectedUnit = value;
                          });
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(height: Dimens.spacingXLarge),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: PrimaryButton(
                          theme: theme,
                          text: "Reservar",
                          onPressed: () {},
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUnitsDropDown(ReservationChangeCalendarState state) {
    if (state is ListUnitsLoadingState ||
        state is ReservationChangeCalendarEmptyState) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: CircularProgressIndicator(),
            ),
            SizedBox(height: Dimens.spacingSmall),
            const Center(
              child: Text("Por favor, aguarde."),
            ),
          ],
        ),
      );
    }
    if (state is ListUnitsFailedState) {
      return const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
                "Ocorreu um erro ao carregar essa informação. Tente novamente mais tarde."),
          ),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: DropdownButtonFormField(
        isExpanded: false,
        hint: const Text('Selecione'),
        onSaved: (value) {
          setState(() {
            selectedUnit = value as Unit;
          });
        },
        value: selectedUnit,
        items: state.unitsList!
            .map((value) => DropdownMenuItem(
                  value: value,
                  child: Text(value.title ?? ""),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedUnit = value as Unit;
          });
        },
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    //TODO: CRIAR MARCACAO DE DATA RESERVADA/BLOQUEADA

    // if (state is ReservationCalendarHistoryLoadedState) {
    //   for (var i = 0; i < state.reservationResponse.length; i++) {
    //     print(state.reservationResponse[i].startReservationDate);

    //     var startDateString = state.reservationResponse[i].startReservationDate;
    //     var startDate = DateFormat('d/M/yyyy').parse(startDateString);

    //     var endDateString = state.reservationResponse[i].endReservationDate;

    //     var endDate = DateFormat('d/M/yyyy').parse(endDateString);

    //     Duration reservedDays = endDate.difference(startDate);

    //     if (reservedDays == Duration.zero) {
    //       _holidays[startDate] = [
    //         reservationTypeSelector(
    //             state.reservationResponse[i].reservationType)
    //       ];
    //     } else {
    //       _holidays[startDate] = [
    //         reservationTypeSelector(
    //             state.reservationResponse[i].reservationType)
    //       ];

    //       for (var i = 0; i < reservedDays.inDays; i++) {
    //         _holidays[startDate.add(Duration(days: i + 1))] = [
    //           reservationTypeSelector(
    //               state.reservationResponse[i].reservationType)
    //         ];
    //       }
    //     }
    //   }
    // }

    return TableCalendar(
      focusedDay: DateTime.now(),
      lastDay: DateTime.now().lastDayOfMonth(),
      firstDay: DateTime.now().firstDayOfMonth(),
      // onCalendarCreated: (first, last, format) {
      //TODO: CHAMADA PARA O BLC

      // if (state is ReservationCalendarLoadState) {
      //   bloc.beginLoadCalendarHistory(
      //       _calendarController.focusedDay.firstDayOfMonth(),
      //       _calendarController.focusedDay.lastDayOfMonth());
      // }
      // },
      availableCalendarFormats: const {
        CalendarFormat.month: 'Month',
      },
      onDaySelected: (date, event) {
        //TODO: chamar para página de cancelar reserva quando tiver reservada

        // List<ReservationResponse> reservationList =
        //     (state as ReservationCalendarHistoryLoadedState)
        //         .reservationResponse
        //         .where((item) =>
        //             DateFormat('d/M/yyyy').parse(item.startReservationDate) ==
        //             DateFormat('d/M/yyyy')
        //                 .parse(DateFormat("d/M/yyy").format(date)))
        //         .toList();

        // Navigator.push(context,
        //     MaterialPageRoute(builder: (BuildContext context) {
        //   return ReservationHistoryDetailsPage(
        //     day: date,
        //     reservationInDay: reservationList,
        //   );
        // }));
      },
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
      ),
      calendarBuilders: CalendarBuilders(selectedBuilder: (context, date, _) {
        final today = DateTime.now();
        if (date.day < today.day &&
            date.month <= today.month &&
            date.year <= today.year) {
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
            date.year <= today.year) {
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
        return Positioned(
          left: 0,
          right: 0,
          bottom: 2.0,
          child: Divider(
            thickness: 2.0,
            height: 4,
            color: _getColor(
                theme, 'bloqueio'), //TODO: Analisar como marcar calendario
          ),
        );
      }),
    );
  }

  Color _getColor(ThemeData theme, String type) {
    switch (type) {
      case 'bloqueio':
        return LelloTheme.palleteOf(theme).warning();
      case 'sorteio':
        return LelloTheme.palleteOf(theme).raffle();
      case 'reserva':
        return theme.primaryColor;
      default:
        return LelloTheme.palleteOf(theme).secondary();
    }
  }

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

  Widget _buildLegend(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: Dimens.spacingSmall),
                child: Container(
                  height: 4.0,
                  width: 25.0,
                  color: Colors.orange,
                ),
              ),
              const Text('Bloqueio')
            ],
          ),
          const SizedBox(width: 20),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  height: 4.0,
                  width: 25.0,
                  color: Colors.red,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: Dimens.spacingMedium,
                ),
                child: const Text('Reservada'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
