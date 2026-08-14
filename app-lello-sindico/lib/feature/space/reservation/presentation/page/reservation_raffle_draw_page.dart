import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_raffle_draw_bloc/reservation_raffle_draw_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationRaffleDrawPage extends StatefulWidget {
  const ReservationRaffleDrawPage({super.key});

  @override
  _ReservationRaffleDrawPageState createState() =>
      _ReservationRaffleDrawPageState();
}

class _ReservationRaffleDrawPageState extends State<ReservationRaffleDrawPage> {
  final dateFormat = DateFormat.yMd();

  final ReservationRaffleDrawBloc bloc =
      ApplicationContainer.instance().resolve();
  var loaded = false;
  Reservation? reservation;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    reservation = ModalRoute.of(context)!.settings.arguments as Reservation;
    if (!loaded) {
      bloc.beginLoad(reservation!.id!, reservation!.space!.id!);
      loaded = true;
    }

    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(title: "Reservar espaço", theme: theme),
            body: BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state is ReservationRaffleDrawSucceededState) {
                    pushNamedAndPopUntil(
                        context,
                        ApplicationRoute.spaceReservationDrawRaffleSuccess,
                        ModalRoute.withName(
                            ApplicationRoute.spaceReservationCalendar),
                        arguments: state.result);
                  }
                },
                builder: (context, state) {
                  if (state is ReservationRaffleDrawLoadingState ||
                      state is ReservationRaffleDrawingState) {
                    return const Center(child: LoadingWidget());
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(
                            theme, state as ReservationRaffleDrawState),
                        _buildBody(theme, state)
                      ],
                    ),
                  );
                })));
  }

  Widget _buildHeader(ThemeData theme, ReservationRaffleDrawState state) {
    final data = state.data;
    return Container(
      padding: EdgeInsets.all(Dimens.spacing),
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(getString(context, "space_reservation_area"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(data?.space?.name ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
          ListTile(
            title: Text(getString(context, "space_reservation_date"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(
                data?.date != null ? dateFormat.format(data!.date!) : "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(ThemeData theme, ReservationRaffleDrawState state) {
    var items = [];
    switch (state.data!.participantType!) {
      case RaffleParticipantType.group:
        items = state.data!.participantGroups;
        break;
      case RaffleParticipantType.unit:
        items = state.data!.participantUnits;
        break;
      case RaffleParticipantType.resident:
        items = state.data!.participantResidents;
        break;
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) {
            return Text(
                getString(
                    context, "space_reservation_raffle_participants_list"),
                style: LelloTextStyles.bodyBold(theme));
          }
          var i = index - 1;
          if (i >= items.length) {
            return PrimaryButton(
                text: getString(context, "space_reservation_do_raffle"),
                onPressed: () {
                  bloc.beginDraw();
                });
          }
          final item = items[i];
          return ListTile(
              title: Text(_getTitle(item), style: LelloTextStyles.body(theme)));
        },
        padding: EdgeInsets.all(Dimens.spacingMedium),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length + 2);
  }

  String _getTitle(dynamic item) {
    if (item is Resident) {
      return "${item.name} - ${item.unit?.group ?? ""} - ${item.unit?.title ?? ""}";
    }
    if (item is Unit) {
      return "${getString(context, "units_unit")} ${item.title}";
    }
    if (item is String) return item;
    return "-";
  }
}
