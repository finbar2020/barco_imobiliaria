import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_summary_list_filter.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/domain/entity/space_available_hours.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_success_page.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_calendar_widget.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';

import '../../../presentation/widget/space_list_widget.dart';

class ReservationCalendarPage extends StatefulWidget {
  const ReservationCalendarPage({super.key});

  @override
  _ReservationCalendarPageState createState() =>
      _ReservationCalendarPageState();
}

class _ReservationCalendarPageState extends State<ReservationCalendarPage> {
  var filter = ReservationSummaryListFilter();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _dropdowHoursOptions = GlobalKey<FormFieldState>();

  final ReservationCalendarBloc bloc =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    SpaceCalendarArguments calendarArguments =
        ModalRoute.of(context)!.settings.arguments as SpaceCalendarArguments;
    Space space = calendarArguments.space!;
    Unit unit = calendarArguments.unit!;

    DateTime? selectedDay;
    var selectedHours;

    return BlocConsumer(
      bloc: bloc,
      listener: (context, state) {
        if (state is ReservationCalendarSuccefullCreatedState) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ReservationSuccessPage();
              },
            ),
          );
        }
      },
      builder: (context, state) {
        return Theme(
          data: theme,
          child: Scaffold(
              key: scaffoldKey,
              appBar: PrimaryAppBar(
                iconColor: theme.primaryColor,
                theme: theme,
                title: _getTitle(),
              ),
              body: SingleChildScrollView(
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
                        theme: theme,
                        space: space,
                        state: state as ReservationCalendarState,
                        unit: unit,
                        bloc: bloc,
                        selectedHours: selectedHours,
                        onDateSelected: (DateTime date) {
                          // setState(() {
                          //   selectedDay = date;
                          // });
                        },
                        onHoursSelected: (String hours) {
                          // setState(() {
                          //   selectedHours = hours;
                          // });
                        },
                        onSubmit: () {
                          print(selectedDay);
                          print(selectedHours);
                        })),
              )),
        );
      },
    );
  }

  Widget _buildBody(
      {required ThemeData theme,
      required Space space,
      required Unit unit,
      dynamic selectedHours,
      required ReservationCalendarState state,
      required ReservationCalendarBloc bloc,
      required Function(DateTime) onDateSelected,
      required Function(String) onHoursSelected,
      required Function onSubmit}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      ReservationCalendarWidget(
        space: space,
        onDaySelected: (date, Space space) async {
          state.selectedDay = date;

          bloc.beginLoadHours(date, unit.id!, space.id!);
          if (state.selectedHours != null) {
            setState(() {
              _dropdowHoursOptions.currentState?.reset();
            });
          }
        },
        pastIsEnable: true,
      ),
      const SizedBox(
        height: 20,
      ),
      Visibility(
        visible: (state is ReservationUnitExceededFailedState),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              "A unidade já excedeu o limite de reservas que foi configurado para esta área.",
              style: LelloTextStyles.error(theme),
            ),
          ),
        ),
      ),
      Visibility(
        visible: (state is ReservationCalendarLoadFailedState),
        child: Center(
          child: Text(
            'Ocorreu um erro ao realizar a sua reserva',
            style: LelloTextStyles.error(theme),
          ),
        ),
      ),
      Visibility(
        visible: (state is ReservationCalendarHoursLoadingState),
        child: const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
      Visibility(
        visible: state.availableHours!.isNotEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
              child: const Text('Horário'),
            ),
            SizedBox(
              height: Dimens.spacingSmall,
            ),
            if (state.availableHours!.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                child: DropdownButtonFormField(
                  key: _dropdowHoursOptions,
                  isExpanded: false,
                  hint: const Text('Selecione'),
                  onSaved: (value) {},
                  value: selectedHours ?? state.availableHours!.first,
                  items: state.availableHours!
                      .map((value) => DropdownMenuItem<SpaceAvailableHours>(
                            value: value,
                            child: Text("De ${value.from} até ${value.until}"),
                          ))
                      .toList(),
                  onChanged: (value) {
                    selectedHours = value;
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            SizedBox(
              height: Dimens.spacingLarge,
            ),
            Visibility(
              visible: (state is ReservationCalendarLoadingState),
              replacement: Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.spacingMedium),
                child: PrimaryButton(
                  buttonColor: theme.primaryColor,
                  onPressed: () async {
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');
                    selectedHours;

                    final reservatedDayFrom =
                        "${formatter.format(state.selectedDay!)} ${selectedHours?.from ?? state.availableHours!.first.from}";

                    final reservatedDayUntil =
                        "${formatter.format(state.selectedDay!)} ${selectedHours?.until ?? state.availableHours!.first.until}";

                    await bloc.beginSendRegistration(
                        space.id!,
                        space,
                        unit.id!,
                        DateTime.parse(reservatedDayFrom),
                        DateTime.parse(reservatedDayUntil));
                  },
                  text: 'Reservar',
                ),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
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
