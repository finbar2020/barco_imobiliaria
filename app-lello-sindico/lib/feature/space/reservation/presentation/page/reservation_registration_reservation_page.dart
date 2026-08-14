import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/space/domain/entity/reservation_payment_method.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration_data.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_reservation/reservation_registration_reservation_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationRegistrationReservationPage extends StatefulWidget {
  @override
  _ReservationRegistrationReservationPageState createState() =>
      _ReservationRegistrationReservationPageState();
}

class _ReservationRegistrationReservationPageState
    extends State<ReservationRegistrationReservationPage> {
  final dateFormat = DateFormat.yMd();
  final timeFormat = DateFormat.jm();

  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  final Validator _validator = ApplicationContainer.instance().resolve();
  final ReservationRegistrationReservationBloc bloc =
      ApplicationContainer.instance().resolve();

  late ReservationRegistration registration;
  late ReservationRegistrationData data;

  var loaded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    data = ReservationRegistrationData();
    super.initState();
  }

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
              title: getString(context, "space_reserve_space"),
              theme: theme,
            ),
            body: BlocConsumer(
                bloc: bloc,
                listener: (context, state) {
                  if (state
                      is ReservationRegistrationReservationRegisteredState) {
                    pushNamedAndPopUntil(
                        context,
                        ApplicationRoute.spaceReservationSuccess,
                        ModalRoute.withName(ApplicationRoute.space),
                        arguments: state.reservation);
                  }
                  if (state
                      is ReservationRegistrationReservationRegisterFailedState) {
                    Navigator.of(context)
                        .pushNamed(ApplicationRoute.spaceReservationFailed);
                  }
                },
                builder: (context, state) {
                  if (state
                          is ReservationRegistrationReservationRegisteringState ||
                      state is ReservationRegistrationReservationLoadingState) {
                    return const Center(child: LoadingWidget());
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildHeader(theme),
                        _buildForm(theme,
                            state as ReservationRegistrationReservationState)
                      ],
                    ),
                  );
                })));
  }

  Widget _buildForm(
      ThemeData theme, ReservationRegistrationReservationState state) {
    if (state is ReservationRegistrationReservationLoadFailedState) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Text(getString(context, "space_reservation_what_unit"),
            style: LelloTextStyles.bodyBold(theme)),
        SizedBox(height: Dimens.spacingSmall),
        Text(getString(context, "error_unknown"),
            style: LelloTextStyles.error(theme)),
        SizedBox(height: Dimens.spacingSmall)
      ]);
    }
    if (state is ReservationRegistrationReservationLoadedState) {
      return Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(getString(context, "space_reservation_what_unit"),
                  style: LelloTextStyles.bodyBold(theme)),
              SizedBox(height: Dimens.spacingSmall),
              DropdownButtonFormField(
                  validator: _validator.validateExisting,
                  value: data.unit,
                  items: (state.units)
                      .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                              "${getString(context, "units_unit")} ${e.title}")))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      data.unit = value as Unit;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              SizedBox(height: Dimens.spacingMedium),
              _buildTime(theme, state),
              _buildPrice(theme, state),
              _buildCancellation(theme, state),
              SizedBox(height: Dimens.spacingMedium),
              PrimaryButton(
                text: getString(context, "space_reservation_confirm"),
                onPressed: () {
                  _save();
                },
              )
            ],
          ),
        ),
      );
    }
    return Container();
  }

  Widget _buildTime(
      ThemeData theme, ReservationRegistrationReservationLoadedState state) {
    final rule = state.rule;
    if (rule.allDay!) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(getString(context, "space_reservation_time"),
            style: LelloTextStyles.bodyBold(theme)),
        Row(
          children: const [],
        ),
      ],
    );
  }

  Widget _buildPrice(
      ThemeData theme, ReservationRegistrationReservationLoadedState state) {
    final rule = state.rule;
    if (!rule.chargeable!) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "space_reservation_price"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(
              state.rule.price != null
                  ? currencyFormat.format(state.rule.price)
                  : "-",
              style: LelloTextStyles.subtitle(theme)),
        ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "space_reservation_payment_method"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(
              _getPaymentMethodTile(state.rule.paymentMethod!) ?? "-",
              style: LelloTextStyles.subtitle(theme)),
        ),
      ],
    );
  }

  Widget _buildCancellation(
      ThemeData theme, ReservationRegistrationReservationLoadedState state) {
    final rule = state.rule;
    if (rule.cancellationLimit == null) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ListTile(
        //   contentPadding: EdgeInsets.zero,
        //   title: Text(
        //       getString(context, "space_reservation_cancellation_limit_days"),
        //       style: LelloTextStyles.bodyBold(theme)),
        //   subtitle: Text(
        //       state.registration.date != null
        //           ? dateFormat.format(state.registration.date
        //               .subtract(Duration(days: rule.cancellationLimit)))
        //           : "-",
        //       style: LelloTextStyles.subtitle(theme)),
        // ),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(getString(context, "space_reservation_expiration_days"),
              style: LelloTextStyles.bodyBold(theme)),
          subtitle: Text(rule.expirationDays?.toString() ?? "-",
              style: LelloTextStyles.subtitle(theme)),
        ),
      ],
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
          // ListTile(
          //   title: Text(getString(context, "space_reservation_date"),
          //       style: LelloTextStyles.bodyBold(theme)),
          //   subtitle: Text(
          //       registration?.date != null
          //           ? dateFormat.format(registration?.date)
          //           : "-",
          //       style: LelloTextStyles.subBody(theme)),
          // ),
        ],
      ),
    );
  }

  String? _getPaymentMethodTile(ReservationPaymentMethod method) {
    switch (method) {
      case ReservationPaymentMethod.quota:
        return getString(context, "space_reservation_payment_quota");
      case ReservationPaymentMethod.billet:
        return getString(context, "space_reservation_payment_billet");
    }
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bloc.beginRegister(data);
    }
  }
}
