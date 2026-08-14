import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/widget/hex_color.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_response.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_calendar/reservation_calendar_state.dart';
import 'package:lello/feature/space/reservation/presentation/page/reservation_deleted_page.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class ReservationHistoryDetailsPage extends StatefulWidget {
  final List<ReservationResponse> reservationInDay;
  final DateTime day;

  const ReservationHistoryDetailsPage(
      {super.key, required this.reservationInDay, required this.day});

  @override
  _ReservationHistoryDetailsPageState createState() =>
      _ReservationHistoryDetailsPageState();
}

class _ReservationHistoryDetailsPageState
    extends State<ReservationHistoryDetailsPage> {
  final ReservationCalendarBloc bloc =
      ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: PrimaryAppBar(
          iconColor: theme.primaryColor,
          theme: theme,
          title: 'Agenda de reserva'),
      body: Theme(
        data: theme,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildHeader(widget.day, theme),

            widget.reservationInDay.isEmpty
                ? const Center(
                    child: Text('Este dia não possuí nenhum tipo de reserva'),
                  )
                : BlocConsumer(
                    bloc: bloc,
                    listener: (context, state) {
                      if (state is DeleteSucessState) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ReservationDeletedPage(),
                          ),
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is ReservationCalendarLoadingState) {
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
                      if (state is ReservationCalendarLoadFailedState) {
                        return const Padding(
                          padding: EdgeInsets.all(25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Ocorreu um erro ao deletar a reserva. Tente novamente mais tarde.",
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return Expanded(
                        child: ListView.builder(
                          itemCount: widget.reservationInDay.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildReservationByType(
                                    widget.reservationInDay[index],
                                    theme,
                                    context,
                                    bloc,
                                    sessionBloc,
                                    widget.day,
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: PrimaryButton(
                buttonColor: theme.primaryColor,
                text: "Voltar para a agenda",
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
            // Padding(
            //   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            //   child:
            // )
          ],
        ),
      ),
    );
  }
}

Widget _buildReservationByType(
  reservation,
  ThemeData theme,
  BuildContext context,
  ReservationCalendarBloc bloc,
  SessionBloc sessionBloc,
  DateTime date,
) {
  print("ID STATUS => ${reservation.idStatus}");
  switch (reservation.reservationType) {
    case 'R':
      return _buildReservationArea(
        reservation,
        theme,
        context,
        bloc,
        sessionBloc,
        date,
      );
    case 'M':
      return _buildMoving(
        reservation,
        theme,
        context,
        bloc,
        sessionBloc,
        date,
      );
    case 'B':
      return _buildBlockedArea(reservation, theme);
    case 'S':
      return _buildRaffle(reservation, theme);
    default:
      print("Tipo de reserva não identificado");
      return Container();
  }
}

Widget _buildRaffle(ReservationResponse reservation, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildReservationType(reservation, theme),
      SizedBox(
        height: Dimens.spacingMedium,
      ),
      buildReservationTypeName(reservation, theme),
      const SizedBox(
        height: 15,
      ),
      buildReservationDate(reservation, theme),
      const SizedBox(
        height: 15,
      ),
      Text(
        'Unidades participantes do sorteio',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(
        height: 10,
      ),
      Text(reservation.unitName ?? "-"),
      const Divider(
        height: 32,
      )
    ],
  );
}

Widget _buildBlockedArea(reservation, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildReservationType(reservation, theme),
      SizedBox(
        height: Dimens.spacingMedium,
      ),
      buildReservationTypeName(reservation, theme),
      const SizedBox(
        height: 10,
      ),
      buildReservationDate(reservation, theme),
      const SizedBox(
        height: 10,
      ),
      Text(
        'Observações',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(
        height: 10,
      ),
      Text('${reservation.observations ?? "-"} '),
      const Divider(
        height: 32,
      )
    ],
  );
}

Widget _buildReservationArea(
  ReservationResponse reservation,
  ThemeData theme,
  BuildContext context,
  ReservationCalendarBloc bloc,
  SessionBloc sessionBloc,
  DateTime date,
) {
  DateTime startDate =
      DateFormat('d/M/yyyy HH:mm:ss').parse(reservation.startReservationDate!);

  String addZero(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  DateTime endDate =
      DateFormat('d/M/yyyy HH:mm:ss').parse(reservation.endReservationDate!);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      buildReservationType(reservation, theme),
      SizedBox(
        height: Dimens.spacingMedium,
      ),
      buildReservationTypeName(reservation, theme),
      const SizedBox(height: 10),
      Text(
        'Unidade',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),

      Text(reservation.unitName ?? "-"),
      //buildReservationDate(reservation),
      const SizedBox(height: 10),
      Text(
        'Hora de início',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),

      Text('${addZero(startDate.hour)}:${addZero(startDate.minute)} '),
      const SizedBox(height: 10),
      Text(
        'Hora de término',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),
      Text('${addZero(endDate.hour)}:${addZero(endDate.minute)} '),
      const SizedBox(height: 10),
      // if (DateTime.parse(reservation.canCancelUntil.replaceAll("/", "-"))
      //     .isBefore(DateTime.now()))
      if (DateFormat.yMd()
              .parse(reservation.canCancelUntil!)
              .isAfter(DateTime.now()) &&
          (date.isAfter(DateTime.now()) ||
              (date.day == DateTime.now().day &&
                  date.month == DateTime.now().month)))
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoReservasWrite,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoReservasWrite),
          child: SizedBox(
            height: 36.0,
            width: 145.0,
            child: PrimaryButton(
              text: getString(context, "cancel"),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => _buildDeleteDialog(
                    context: context,
                    bloc: bloc,
                    theme: theme,
                    reservationId: reservation.id.toString(),
                    reservationType: reservation.reservationType!,
                  ),
                );
              },
            ),
          ),
        ),
      const Divider(height: 32)
    ],
  );
}

Widget _buildMoving(
  ReservationResponse reservation,
  ThemeData theme,
  BuildContext context,
  ReservationCalendarBloc bloc,
  SessionBloc sessionBloc,
  DateTime date,
) {
  DateTime startDate =
      DateFormat('d/M/yyyy HH:mm:ss').parse(reservation.startReservationDate!);

  String addZero(int value) {
    return value < 10 ? "0$value" : "$value";
  }

  DateTime endDate =
      DateFormat('d/M/yyyy HH:mm:ss').parse(reservation.endReservationDate!);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Área reservada',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),
      const Text('Mudança'),
      const SizedBox(height: 10),
      Text(
        'Unidade',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),

      Text(reservation.unitName ?? "-"),
      //buildReservationDate(reservation),
      const SizedBox(height: 10),
      Text(
        'Hora de início',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),

      Text('${addZero(startDate.hour)}:${addZero(startDate.minute)} '),
      const SizedBox(height: 10),
      Text(
        'Hora de término',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(height: 5),
      Text('${addZero(endDate.hour)}:${addZero(endDate.minute)} '),
      const SizedBox(height: 10),
      // if (DateTime.parse(reservation.canCancelUntil.replaceAll("/", "-"))
      //     .isBefore(DateTime.now()))
      if (DateFormat.yMd()
              .parse(reservation.canCancelUntil!)
              .isAfter(DateTime.now()) &&
          (date.isAfter(DateTime.now()) ||
              (date.day == DateTime.now().day &&
                  date.month == DateTime.now().month)))
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoReservasWrite,
          rbacEnabled:
              sessionBloc.checkRback(ApplicationRbac.sindicoReservasWrite),
          child: SizedBox(
            height: 36.0,
            width: 145.0,
            child: PrimaryButton(
              text: getString(context, "cancel"),
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) => _buildDeleteDialog(
                    context: context,
                    bloc: bloc,
                    theme: theme,
                    reservationId: reservation.id.toString(),
                    reservationType: reservation.reservationType!,
                  ),
                );
              },
            ),
          ),
        ),
      const Divider(height: 32)
    ],
  );
}

Dialog _buildDeleteDialog({
  required BuildContext context,
  required ReservationCalendarBloc bloc,
  required ThemeData theme,
  required String reservationId,
  required String reservationType,
}) {
  return Dialog(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Cancelar Reserva",
            style: LelloTextStyles.titleSmall(theme),
          ),
          SizedBox(height: Dimens.spacingMedium),
          Text(
            "Tem certeza que deseja cancelar esta reserva?",
            style: LelloTextStyles.body(theme),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimens.spacingMedium),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "VOLTAR",
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: HexColor("#333333"),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    bloc.deleteReservation(reservationId, reservationType);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "CONFIRMAR",
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

Column buildReservationTypeName(
    ReservationResponse reservation, ThemeData theme) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Área ${reservatinoTypeName(reservation)}',
        style: LelloTextStyles.bodyBold(theme),
      ),
      const SizedBox(
        height: 5,
      ),
      Text('${reservation.area}'),
    ],
  );
}

Widget buildReservationDate(ReservationResponse reservation, ThemeData theme) {
  switch (reservation.reservationType) {
    case 'R':
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'De',
                style: LelloTextStyles.bodyBold(theme),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('${reservation.startReservationDate}'),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Até',
                style: LelloTextStyles.bodyBold(theme),
              ),
              const SizedBox(
                height: 10,
              ),
              Text('${reservation.endReservationDate}'),
            ],
          ),
        ],
      );
    case 'B':
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'De',
                style: LelloTextStyles.bodyBold(theme),
              ),
              Text('${reservation.startReservationDate}'),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Até',
                style: LelloTextStyles.bodyBold(theme),
              ),
              Text('${reservation.endReservationDate}'),
            ],
          ),
        ],
      );
    case 'S':
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data do sorteio',
            style: LelloTextStyles.bodyBold(theme),
          ),
          Text('${reservation.reservationTypeDate}'),
        ],
      );
    default:
      return Container();
  }
}

Widget buildHeader(DateTime date, ThemeData theme) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${monthSelector(date.month)} de ${date.year}',
          style: LelloTextStyles.title(theme),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          'Dia ${date.day}, ${weekDaySelector(date.weekday)}',
          style: LelloTextStyles.subtitle(theme),
        ),
      ],
    ),
  );
}

Widget buildReservationType(ReservationResponse reservation, ThemeData theme) {
  print(reservation);
  return Row(
    children: [
      Container(
        height: 25,
        width: 25,
        decoration: BoxDecoration(
            color: reservationColor(reservation),
            borderRadius: BorderRadius.circular(15)),
      ),
      const SizedBox(
        width: 10,
      ),
      Text(
        reservatinoType(reservation),
        style: LelloTextStyles.bodyBold(theme),
      ),
    ],
  );
}

Color reservationColor(ReservationResponse reservation) {
  switch (reservation.reservationType) {
    case 'R':
      return Colors.red;
    case 'B':
      return Colors.orange;
    case 'S':
      return Colors.blue;
    default:
      return Colors.white;
  }
}

String weekDaySelector(int weekday) {
  switch (weekday) {
    case 1:
      return 'segunda-feira';
    case 2:
      return 'terça-feira';
    case 3:
      return 'quarta-feira';
    case 4:
      return 'quinta-feira';
    case 5:
      return 'sexta-feira';
    case 6:
      return 'Sábado';
    case 7:
      return 'Domingo';
    default:
      return "";
  }
}

String reservatinoTypeName(ReservationResponse reservation) {
  print('asasdasdds');
  switch (reservation.reservationType) {
    case 'R':
      return 'reservada';
    case 'B':
      return "bloqueada";
    case 'S':
      return "sorteada";
    default:
      return "";
  }
}

String reservatinoType(ReservationResponse reservation) {
  print('asasdasdds');
  switch (reservation.reservationType) {
    case 'R':
      return 'Reserva';
    case 'B':
      return "Bloqueio";
    case 'S':
      return "Sorteio";
    default:
      return "";
  }
}

String monthSelector(int month) {
  switch (month) {
    case 1:
      return 'Janeiro';
    case 2:
      return 'Fevereiro';
    case 3:
      return 'Março';
    case 4:
      return 'Abril';
    case 5:
      return 'Maio';
    case 6:
      return 'Junho';
    case 7:
      return 'Julho';
    case 8:
      return 'Agosto';
    case 9:
      return 'Setembro';
    case 10:
      return 'Outubro ';
    case 11:
      return 'Novembro';
    case 12:
      return 'Dezembro';
    default:
      return "";
  }
}
