import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/domain/entity/space.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/widget/reservation_calendar_widget.dart';

class ReservationRegistrationDatePage extends StatefulWidget {
  @override
  _ReservationRegistrationDatePageState createState() =>
      _ReservationRegistrationDatePageState();
}

class _ReservationRegistrationDatePageState
    extends State<ReservationRegistrationDatePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ReservationRegistration registration =
        ModalRoute.of(context)!.settings.arguments as ReservationRegistration;
    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
              title: getString(context, "space_reservation_select_date"),
              theme: theme,
            ),
            body: ReservationCalendarWidget(
              onDaySelected: (date, Space space) {
                Navigator.of(context).pushNamed(
                    ApplicationRoute.spaceReservationRegistrationTime,
                    arguments: registration);
              },
              space: registration.space!,
            )));
  }
}
