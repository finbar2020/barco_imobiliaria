import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_state.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_registration_setup_widget.dart';

class ReservationRegistrationPage extends StatefulWidget {
  @override
  _ReservationRegistrationPageState createState() =>
      _ReservationRegistrationPageState();
}

class _ReservationRegistrationPageState
    extends State<ReservationRegistrationPage> {
  var loaded = false;
  final ReservationRegistrationBloc bloc =
      ApplicationContainer.instance().resolve();

  late ReservationRegistration registration;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (!loaded) {
      registration =
          ModalRoute.of(context)!.settings.arguments as ReservationRegistration;
      bloc.beginSetup(registration);
      loaded = true;
    }
    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
              title: "Reservar espaço",
              theme: theme,
            ),
            body: SingleChildScrollView(
              child: BlocProvider.value(
                value: bloc,
                child: BlocConsumer(
                    bloc: bloc,
                    listener: (context, state) {
                      if (state is ReservationRegistrationFormState) {
                        _showForm(state);
                      }
                    },
                    builder: (context, state) {
                      return ReservationRegistrationSetupWidget();
                    }),
              ),
            )));
  }

  void _showForm(ReservationRegistrationFormState state) {
    // switch (state?.registration?.type) {
    // 	case ReservationType.maintenance:
    // 		Navigator.of(context).pushNamed(ApplicationRoute.spaceReservationRegistrationMaintenance, arguments: state.registration );
    // 		break;
    // 	case ReservationType.raffle:
    // 		Navigator.of(context).pushNamed(ApplicationRoute.spaceReservationRegistrationRaffle, arguments: state.registration );
    // 		break;
    // 	case ReservationType.reservation:
    // 		Navigator.of(context).pushNamed(ApplicationRoute.spaceReservationRegistrationReservation, arguments: state.registration );
    // 		break;
    // }
  }
}
