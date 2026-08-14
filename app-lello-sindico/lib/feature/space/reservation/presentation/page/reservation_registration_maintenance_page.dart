import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_maintenance/reservation_registration_maintenance_state.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationRegistrationMaintenancePage extends StatefulWidget {
  @override
  _ReservationRegistrationMaintenancePageState createState() =>
      _ReservationRegistrationMaintenancePageState();
}

class _ReservationRegistrationMaintenancePageState
    extends State<ReservationRegistrationMaintenancePage> {
  final dateFormat = DateFormat.yMd();
  final timeFormat = DateFormat.jm();

  final Validator _validator = ApplicationContainer.instance().resolve();
  final ReservationRegistrationMaintenanceBloc bloc =
      ApplicationContainer.instance().resolve();

  late ReservationRegistration registration;

  var loaded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    registration =
        ModalRoute.of(context)!.settings.arguments as ReservationRegistration;
    if (!loaded) {
      bloc.beginSetup(registration);
      loaded = true;
    }

    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
              title: "Manutenção",
              theme: theme,
            ),
            body: BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state
                      is ReservationRegistrationMaintenanceRegisteredState) {
                    pushNamedAndPopUntil(
                        context,
                        ApplicationRoute.spaceReservationSuccess,
                        ModalRoute.withName(ApplicationRoute.space),
                        arguments: state.reservation);
                  }
                  if (state
                      is ReservationRegistrationMaintenanceRegisterFailedState) {
                    Navigator.of(context)
                        .pushNamed(ApplicationRoute.spaceReservationFailed);
                  }
                },
                builder: (context, state) {
                  if (state
                      is ReservationRegistrationMaintenanceRegisteringState) {
                    return const Center(child: LoadingWidget());
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [_buildHeader(theme), _buildForm(theme)],
                  );
                })));
  }

  Widget _buildForm(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(getString(context, "date"),
                style: LelloTextStyles.titleSmall(theme)),
            SizedBox(height: Dimens.spacingSmall),
            Text(getString(context, "to"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacingSmall),
            PrimaryTextFormField(
                hint: getString(context, "fill_in"),
                initialValue:
                    dateFormat.format(registration.reservationStartDate!),
                //onSaved: (value) => registration?.dateTo = dateFormat.parse(value),
                textInputType: TextInputType.number,
                validator: (value) =>
                    _validator.validateDate(value ?? "", optional: true),
                formatter: fullDateFormatter(),
                onFieldSubmitted: (_) => _save()),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              text: getString(context, "next"),
              onPressed: () {
                _save();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
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
            subtitle: Text(registration.space?.name ?? "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ],
      ),
    );
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bloc.beginRegister();
    }
  }
}
