import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/widgets/loading_widget.dart';
import 'package:morar/feature/reservation/domain/entity/space.dart';
import 'package:morar/feature/reservation/domain/entity/space_available_hours.dart';
import 'package:morar/feature/reservation/domain/entity/space_calendar_response.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_bloc.dart';
import 'package:morar/feature/reservation/presentation/bloc/reservation_state.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_dialog.dart';
import 'package:shared_features/core/modal/month_picker.dart';

class ReservationBottomSheetWidget extends StatefulWidget {
  final ReservationBloc bloc;
  final Space space;
  const ReservationBottomSheetWidget(
      {Key? key, required this.bloc, required this.space})
      : super(key: key);

  @override
  _ReservationBottomSheetWidgetState createState() =>
      _ReservationBottomSheetWidgetState();
}

class _ReservationBottomSheetWidgetState
    extends State<ReservationBottomSheetWidget> {
  SpaceAvailableHours? _horarioSelecionado;
  late ReservationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = widget.bloc;
  }

  Map<DateTime, String> _events = Map<DateTime, String>();
  List<DateTime> bloqueados = [];
  List<DateTime> reservados = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocConsumer(
      listener: (context, state) {
        if (state is ReservationSendSuccessState) {
          Navigator.pop(context);
        }
      },
      bloc: bloc,
      builder: (context, state) {
        if (state is LoadingCalendarState) {
          return Column(
            children: [
              Expanded(
                child: LoadingWidget(),
              ),
            ],
          );
        }
        if (state is FailureCalendarState) {
          return _buildError(theme);
        }
        if (state is FailureDialogState) {
          _getMarkedsCalendar(state.calendarResponse);
          return _buildLoadedBody(
            context: context,
            theme: theme,
            loadedHours: state.loadedHours,
            loadedMonth: state.loadedMonth,
            hours: state.hours,
            calendarResponse: state.calendarResponse,
            selectedDate: state.selectedDate,
            stateCreatedAt: null,
          );
        }
        if (state is LoadedDialogState) {
          _getMarkedsCalendar(state.calendarResponse);
          return _buildLoadedBody(
            context: context,
            theme: theme,
            loadedHours: state.loadedHours,
            loadedMonth: state.loadedMonth,
            hours: state.hours,
            calendarResponse: state.calendarResponse,
            selectedDate: state.reserveDate,
            stateCreatedAt: null,
          );
        }
        if (state is LoadedCalendarState) {
          _getMarkedsCalendar(state.calendarResponse);

          var error = state.error;

          if (state.error != null && (error is KnownFailure)) {
            String messageKey = "reserves_reserve_not_possible";
            if (error.code != null) {
              messageKey = error.code!;
            }
            Future.delayed(
                Duration.zero,
                () => showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => _buildAlertDialog(
                          theme: theme,
                          keyMessage: messageKey,
                          bloc: bloc,
                          state: state),
                    ));
            bloc.clearError(state);
          }
          return _buildLoadedBody(
            context: context,
            theme: theme,
            loadedHours: state.loadedHours,
            loadedMonth: state.loadedMonth,
            hours: state.hours,
            calendarResponse: state.calendarResponse,
            selectedDate: state.selectedDate,
            stateCreatedAt: state.stateCreatedAt,
          );
        }
        if (state is LoadingDialogState) {
          _getMarkedsCalendar(state.calendarResponse);
          return _buildLoadedBody(
            context: context,
            theme: theme,
            loadedHours: state.loadedHours,
            loadedMonth: state.loadedMonth,
            hours: state.hours,
            calendarResponse: state.calendarResponse,
            selectedDate: state.selectedDate,
            stateCreatedAt: null,
          );
        }
        return Container();
      },
    );
  }

  Padding _buildLoadedBody({
    required BuildContext context,
    required ThemeData theme,
    required bool loadedHours,
    required bool loadedMonth,
    required List<SpaceAvailableHours> hours,
    required SpaceCalendarResponse calendarResponse,
    required DateTime selectedDate,
    required DateTime? stateCreatedAt,
  }) {
    if (!loadedHours) {
      _horarioSelecionado = null;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Center(
                child: IconButton(
              icon: Icon(Icons.keyboard_arrow_down),
              color: LelloTheme.palleteOf(theme).textOpaque(),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
            SizedBox(height: Dimens.spacing),
            Text(
              widget.space.name!,
              style: LelloTextStyles.titleSmall(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textOpaque(),
              ),
            ),
            SizedBox(height: Dimens.spacingSmall),
            Text(
              getString(context, "reserve_choose_date"),
              style: LelloTextStyles.subtitle(theme),
            ),
            SizedBox(height: Dimens.spacingSmall),
            ReservationCalendar(
              calendarResponse: calendarResponse,
              selectedDate: selectedDate,
              bloc: bloc,
              space: widget.space,
              loadedMonth: loadedMonth,
              events: _events,
            ),
            Divider(thickness: 1),
            SizedBox(height: Dimens.spacingSmall),
            Row(
              children: [
                // Flexible: cada item da legenda pode encolher (com
                // reticências) em vez de estourar a largura.
                Flexible(
                  child: _buildLegendItem(
                    theme,
                    getString(context, "blockade"),
                    LelloTheme.palleteOf(theme).warning(),
                  ),
                ),
                SizedBox(width: Dimens.spacing),
                Flexible(
                  child: _buildLegendItem(
                    theme,
                    getString(context, "space_reserved_a"),
                    theme.primaryColor,
                  ),
                ),
                SizedBox(width: Dimens.spacing),
                Flexible(
                  child: _buildLegendItem(
                    theme,
                    getString(context, "space_reservation_vacancy"),
                    LelloTheme.palleteOf(theme).separator(),
                  ),
                ),
              ],
            ),
            Visibility(
              visible: loadedHours && hours.isNotEmpty,
              replacement: loadedHours == false
                  ? Column(
                      children: [
                        SizedBox(height: Dimens.spacingSmall),
                        Center(
                          child: CircularProgressIndicator(),
                        ),
                      ],
                    )
                  : Container(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Dimens.spacingLarge),
                    child: Text(
                      getString(context, "available_hours"),
                      style: LelloTextStyles.subtitle(theme),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingSmall),
                  loadedHours
                      ? IgnorePointer(
                          ignoring: hours.isEmpty,
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            decoration: BoxDecoration(
                              color: LelloTheme.palleteOf(theme).customColor(),
                              border: Border.all(
                                width: 1.0,
                                color: LelloTheme.palleteOf(theme).separator(),
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                            ),
                            child: DropdownButton(
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down),
                                underline: SizedBox.shrink(),
                                hint: Text(
                                    getString(context, "choose_an_option")),
                                value: _horarioSelecionado,
                                items: hours.map((dropDownStringItem) {
                                  return DropdownMenuItem<SpaceAvailableHours>(
                                    value: dropDownStringItem,
                                    child: Text(
                                      "das ${dropDownStringItem.from.substring(0, 5)}h às ${dropDownStringItem.until.substring(0, 5)}h",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  );
                                }).toList(),
                                onTap: () {
                                  FocusScope.of(context)
                                      .requestFocus(new FocusNode());
                                },
                                onChanged: (value) {
                                  setState(() {
                                    _horarioSelecionado = value;
                                  });
                                }),
                          ),
                        )
                      : Column(
                          children: [
                            SizedBox(height: Dimens.spacingSmall),
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                          ],
                        ),
                  SizedBox(height: Dimens.spacingMedium),
                  _buildButton(context, theme, selectedDate, stateCreatedAt),
                  SizedBox(height: Dimens.spacingSmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildButton(BuildContext context, ThemeData theme,
      DateTime selectedDate, DateTime? stateCreatedAt) {
    return Container(
      height: 54.0,
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: theme.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Text(
          getString(context, "reserve_button_title"),
          style: LelloTextStyles.button(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).customColor(),
          ),
        ),
        onPressed: () {
          if (DateTime.now().day != stateCreatedAt?.day) {
            Navigator.of(context).pop();
          } else if (_horarioSelecionado != null) {
            bloc.postSpace(
              widget.space,
              selectedDate,
              _horarioSelecionado!,
            );
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => ReservationDialog(
                bloc: bloc,
              ),
            );
          }
        },
      ),
    );
  }

  _buildAlertDialog(
      {required ThemeData theme,
      String? keyMessage,
      required ReservationBloc bloc,
      required LoadedCalendarState state}) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              "${getString(context, "chat_error_title")}!",
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLightest(),
              ),
            ),
            Text(
              _getMessage(keyMessage),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLightest(),
              ),
            ),
            SizedBox(height: Dimens.spacingLarge),
            InkWell(
              onTap: () {
                bloc.clearError(state);
                Navigator.pop(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      getString(context, "ok"),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildLegendItem(ThemeData theme, String title, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 10.0,
          width: 10.0,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: Dimens.spacingXSmall),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: LelloTextStyles.caption(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).greyDarker(),
            ),
          ),
        ),
      ],
    );
  }

  Column _buildError(ThemeData theme) {
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
                  SizedBox(
                    height: Dimens.spacingMedium,
                  ),
                  Text(
                    getString(context, "error_unknown"),
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLightest(),
                    ),
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

  void _getMarkedsCalendar(SpaceCalendarResponse calendarResponse) {
    for (var i = 0; i < calendarResponse.lockedDays!.length; i++) {
      String date = calendarResponse.lockedDays![i];
      date =
          "${date.substring(6, date.length)}-${date.substring(3, 5)}-${date.substring(0, 2)}";
      DateTime tempDate = DateTime.parse(date);

      _events[tempDate] = 'bloqueio';
    }

    for (var i = 0; i < calendarResponse.alreadyReservatedDays!.length; i++) {
      String date = calendarResponse.alreadyReservatedDays![i];
      date =
          "${date.substring(6, date.length)}-${date.substring(3, 5)}-${date.substring(0, 2)}";
      DateTime tempDate = DateTime.parse(date);

      _events[tempDate] = 'reserva';
    }
  }

  String _getMessage(String? keyMessage) {
    if (keyMessage == null) return getString(context, "reserve_limit_date");

    if (getString(context, keyMessage).isNotEmpty == true)
      return getString(context, keyMessage);

    if (keyMessage.isNotEmpty == true) return keyMessage;

    return getString(context, "reserve_limit_date");
  }
}

class ReservationCalendar extends StatefulWidget {
  final SpaceCalendarResponse calendarResponse;
  final DateTime selectedDate;
  final ReservationBloc bloc;
  final Space space;
  final bool loadedMonth;
  final Map<DateTime, String> events;
  ReservationCalendar({
    Key? key,
    required this.calendarResponse,
    required this.selectedDate,
    required this.bloc,
    required this.space,
    required this.loadedMonth,
    required this.events,
  }) : super(key: key);

  @override
  _ReservationCalendarState createState() => _ReservationCalendarState();
}

class _ReservationCalendarState extends State<ReservationCalendar> {
  final theme = LelloTheme.light;
  DateTime _focusedDay = DateTime.now();
  DateTime firstDay = DateTime.now();
  DateTime? selected = DateTime.now();
  List<DateTime> meses = [];
  var calendarDate = DateTime.now();
  late Map<DateTime, String> _events;

  @override
  void initState() {
    super.initState();

    //aways add current month
    meses.add(DateTime(DateTime.now().year, DateTime.now().month, 1));

    //limit dropdown by max date
    var auxDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 1);
    while (
        auxDate.isBefore(widget.space.reservationRule.getMaxReservationDate)) {
      meses.add(auxDate);
      auxDate = DateTime(auxDate.year, auxDate.month + 1, 1);
    }
    _events = widget.events;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IgnorePointer(
          ignoring: widget.loadedMonth == false,
          child: TableCalendar(
            availableGestures: AvailableGestures.none,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarFormat: CalendarFormat.month,
            headerVisible: true,
            onHeaderTapped: (focusedDay) async {
              final date = await showMonthPicker(
                context: context,
                firstDate: firstDay,
                lastDate: widget.space.reservationRule.getMaxReservationDate,
                initialDate: _focusedDay,
              );
              setState(() {
                if (date == null) {
                  return;
                }
                if (date.compareTo(
                        widget.space.reservationRule.getMaxReservationDate) >
                    0) {
                  _focusedDay =
                      widget.space.reservationRule.getMaxReservationDate;
                  return;
                }
                if (date.compareTo(firstDay) < 0) {
                  _focusedDay = firstDay;
                  return;
                }
                _focusedDay = date;
              });
            },
            focusedDay: _focusedDay,
            firstDay: firstDay,
            lastDay: widget.space.reservationRule.getMaxReservationDate,
            selectedDayPredicate: (day) {
              return isSameDay(selected, day);
            },
            onPageChanged: (date) {
              _focusedDay = date;
            },
            onDaySelected: (date, event) {
              setState(() {
                if (widget.calendarResponse.lockedDays!
                    .contains(DateFormat("dd/MM/yyyy").format(date))) {
                  widget.bloc.clearHours(date);
                } else if (widget.calendarResponse.alreadyReservatedDays!
                    .contains(DateFormat("dd/MM/yyyy").format(date))) {
                  widget.bloc.clearHours(date);
                } else if (date.isBefore(
                    widget.space.reservationRule.getMinReservationDate)) {
                  widget.bloc.clearHours(date);
                } else {
                  widget.bloc.getHours(
                    widget.bloc.state.session!.condominium!.id!,
                    widget.space.id!,
                    date,
                  );
                }
                selected = date;
                _focusedDay = event;
              });
            },
            daysOfWeekStyle: DaysOfWeekStyle(
              dowTextFormatter: (date, locale) =>
                  DateFormat.EEEE(locale).format(date)[0].toUpperCase(),
              weekendStyle: LelloTextStyles.body(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
              weekdayStyle: LelloTextStyles.body(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).grey(),
              ),
            ),
            calendarStyle: CalendarStyle(
                canMarkersOverflow: true,
                weekendTextStyle: LelloTextStyles.body(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
                outsideTextStyle: LelloTextStyles.body(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).grey(),
                ),
                todayTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0,
                  color: LelloTheme.palleteOf(theme).text(),
                )),
            startingDayOfWeek: StartingDayOfWeek.sunday,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, events) => Container(
                  height: 32.0,
                  width: 32.0,
                  margin: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  )),
              selectedBuilder: (context, date, events) => Container(
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
                    style: TextStyle(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    ),
                  )),
              todayBuilder: (context, date, events) => Container(
                  height: 32.0,
                  width: 32.0,
                  margin: const EdgeInsets.all(5.0),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  )),
              markerBuilder: (context, date, events) {
                DateTime newDate = _events.keys.firstWhere(
                    (element) =>
                        DateFormat("yyyy-MM-dd hh:mm:ss").format(element) ==
                        DateFormat("yyyy-MM-dd hh:mm:ss").format(date),
                    orElse: () => DateTime.now().subtract(Duration(days: 2)));
                if (newDate != DateTime.now().subtract(Duration(days: 2)) &&
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
                        style: TextStyle(
                          color: LelloTheme.palleteOf(theme).customColor(),
                        ),
                      ));
                } else if (newDate !=
                        DateTime.now().subtract(Duration(days: 2)) &&
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
                        style: TextStyle(
                          color: LelloTheme.palleteOf(theme).customColor(),
                        ),
                      ));
                }
                return null;
              },
            ),
          ),
        ),
      ],
    );
  }
}
