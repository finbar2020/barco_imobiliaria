import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_type.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration/reservation_registration_state.dart';

class ReservationRegistrationSetupWidget extends StatefulWidget {
  @override
  _ReservationRegistrationSetupWidgetState createState() =>
      _ReservationRegistrationSetupWidgetState();
}

class _ReservationRegistrationSetupWidgetState
    extends State<ReservationRegistrationSetupWidget> {
  final dateFormat = DateFormat.yMd();
  final timeFormat = DateFormat.jm();

  ReservationType? type;
  late ReservationRegistrationBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildHeader(theme, bloc.state),
        _buildForm(theme, bloc.state)
      ],
    );
  }

  Widget _buildForm(ThemeData theme, ReservationRegistrationState state) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(getString(context, "space_reservation_goal"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          DropdownButtonFormField(
            value: type,
            items: [
              DropdownMenuItem(
                  child: Text(
                      getString(context, "space_reservation_reservation")),
                  value: ReservationType.reservation),
              DropdownMenuItem(
                  child: Text(
                      getString(context, "space_reservation_maintenance")),
                  value: ReservationType.maintenance)
            ],
            onChanged: (value) {
              setState(() {
                type = value as ReservationType;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: Dimens.spacingMedium),
          PrimaryButton(
            text: getString(context, "next"),
            onPressed: () {
              bloc.setType(type!);
            },
          )
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, ReservationRegistrationState state) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacing),
      decoration: BoxDecoration(
          color: LelloTheme.palleteOf(theme).separator(),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              bottomRight: Radius.circular(8.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(getString(context, "space_reservation_area"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(state.registration?.space?.name ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ],
      ),
    );
  }
}
