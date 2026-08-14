import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_time.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_time/reservation_registration_time_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationRegistrationTimePage extends StatefulWidget {
  @override
  _ReservationRegistrationTimePageState createState() =>
      _ReservationRegistrationTimePageState();
}

class _ReservationRegistrationTimePageState
    extends State<ReservationRegistrationTimePage> {
  final ReservationRegistrationTimeBloc bloc =
      ApplicationContainer.instance().resolve();
  final timeFormat = DateFormat.jm();
  final dateFormat = DateFormat.yMd();

  var loaded = false;
  late ReservationRegistration registration;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    registration =
        ModalRoute.of(context)!.settings.arguments as ReservationRegistration;

    if (!loaded) {
      bloc.beginLoad(registration);
      loaded = true;
    }

    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
              title: getString(context, "space_reservation_select_time"),
              theme: theme,
            ),
            body: BlocBuilder(
              bloc: bloc,
              builder: (context, state) =>
                  _buildList(theme, state as ReservationRegistrationTimeState),
            )));
  }

  Widget _buildList(ThemeData theme, ReservationRegistrationTimeState state) {
    if (state is ReservationRegistrationTimeLoadingState) {
      return const Center(child: LoadingWidget());
    }
    return ListView.builder(
        itemBuilder: (context, index) {
          if (index == 0) return _buildHeader(theme, state);

          final item = state.data[index - 1];
          return Padding(
            padding: EdgeInsets.all(Dimens.spacing),
            child: SecondaryButton(
              text:
                  "${timeFormat.format(item.from!.toLocal())} ${getString(context, "time_to")} ${timeFormat.format(item.to!.toLocal())}",
              onPressed: () {
                _onTimeSelected(item, state);
              },
            ),
          );
        },
        itemCount: (state.data.length) + 1);
  }

  Widget _buildHeader(ThemeData theme, ReservationRegistrationTimeState state) {
    return Column(
      children: [
        state.data.isEmpty != false ? _buildNoItem(theme, state) : Container()
      ],
    );
  }

  Widget _buildNoItem(ThemeData theme, ReservationRegistrationTimeState state) {
    return Center(
      child: Text(
        getString(context, "space_reservation_no_available_time"),
        textAlign: TextAlign.center,
        style: LelloTextStyles.subBody(theme),
      ),
    );
  }

  void _onTimeSelected(
      ReservationTime time, ReservationRegistrationTimeState state) {
    Navigator.of(context).pushNamed(
        ApplicationRoute.spaceReservationRegistration,
        arguments: registration);
  }
}
