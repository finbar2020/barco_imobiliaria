import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/resident/domain/entity/resident.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_raffle_data.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_registration.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_bloc.dart';
import 'package:lello/feature/space/reservation/presentation/bloc/reservation_registration_raffle/reservation_registration_raffle_state.dart';
import 'package:lello/feature/unit/domain/entity/unit.dart';
import 'package:shared_features/core/widgets/loading_widget.dart';

class ReservationRegistrationRafflePage extends StatefulWidget {
  @override
  _ReservationRegistrationRafflePageState createState() =>
      _ReservationRegistrationRafflePageState();
}

class _ReservationRegistrationRafflePageState
    extends State<ReservationRegistrationRafflePage> {
  final dateFormat = DateFormat.yMd();
  final timeFormat = DateFormat.jm();

  final currencyFormat = NumberFormat.currency(symbol: "R\$");
  final Validator _validator = ApplicationContainer.instance().resolve();
  final ReservationRegistrationRaffleBloc bloc =
      ApplicationContainer.instance().resolve();
  var showConfirmation = false;

  late ReservationRegistration registration;
  late ReservationRaffleData data;

  var loaded = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    data = ReservationRaffleData();
    super.initState();
  }

  TextEditingController signUpLimitDateController =
      TextEditingController(text: '');
  TextEditingController raffleDateController = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    _validator.context = context;
    registration =
        ModalRoute.of(context)!.settings.arguments as ReservationRegistration;
    if (!loaded) {
      data.raffleDate = registration.reservationStartDate;
      bloc.beginSetup(registration);
      loaded = true;
    }

    if (data.signUpLimitDate != null) {
      signUpLimitDateController.text = dateFormat.format(data.signUpLimitDate!);
    }
    if (data.raffleDate != null) {
      raffleDateController.text = dateFormat.format(data.raffleDate!);
    }

    return Theme(
        data: theme,
        child: Scaffold(
            appBar: PrimaryAppBar(
              title: "Reservar espaço",
              theme: theme,
            ),
            body: WillPopScope(
              onWillPop: () async {
                if (showConfirmation) {
                  setState(() {
                    showConfirmation = false;
                  });
                  return false;
                }
                return true;
              },
              child: BlocConsumer(
                  bloc: bloc,
                  listener: (context, state) {
                    if (state is ReservationRegistrationRaffleRegisteredState) {
                      pushNamedAndPopUntil(
                          context,
                          ApplicationRoute.spaceReservationSuccess,
                          ModalRoute.withName(ApplicationRoute.space),
                          arguments: state.reservation);
                    }
                    if (state
                        is ReservationRegistrationRaffleRegisterFailedState) {
                      Navigator.of(context)
                          .pushNamed(ApplicationRoute.spaceReservationFailed);
                    }
                  },
                  builder: (context, state) {
                    if (state
                            is ReservationRegistrationRaffleRegisteringState ||
                        state is ReservationRegistrationRaffleLoadingState) {
                      return const Center(child: LoadingWidget());
                    }
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(theme),
                          showConfirmation
                              ? _showConfirmation(
                                  theme,
                                  state
                                      as ReservationRegistrationRaffleLoadedState)
                              : _buildForm(
                                  theme,
                                  state
                                      as ReservationRegistrationRaffleLoadedState)
                        ],
                      ),
                    );
                  }),
            )));
  }

  Widget _buildForm(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    return Container(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDates(theme, state),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
                text: getString(context, "space_reservation_confirm_raffle"),
                onPressed: () {
                  _save();
                })
          ],
        ),
      ),
    );
  }

  Widget _buildDates(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(getString(context, "space_reservation_raffle_date"),
            style: LelloTextStyles.bodyBold(theme)),
        SizedBox(height: Dimens.spacingSmall),
        PrimaryTextFormField(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final date =
                  await datePicker(context, selectedDate: data.signUpLimitDate);
              setState(() {
                data.signUpLimitDate = date;
                signUpLimitDateController.text = dateFormat.format(date);
              });
            },
            controller: signUpLimitDateController,
            onSaved: (value) => data.signUpLimitDate = _parseDate(value),
            onFieldSubmitted: (_) => _nextFocus(),
            validator: (value) => _validator.validateDate(value ?? ""),
            textInputType: TextInputType.number,
            formatter: fullDateFormatter(),
            hint: "00/00/0000"),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "space_reservation_raffle_date"),
            style: LelloTextStyles.bodyBold(theme)),
        SizedBox(height: Dimens.spacingSmall),
        PrimaryTextFormField(
            onTap: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              final date =
                  await datePicker(context, selectedDate: data.raffleDate);
              setState(() {
                data.raffleDate = date;
                raffleDateController.text = dateFormat.format(date);
              });
            },
            controller: raffleDateController,
            onSaved: (value) => data.raffleDate = _parseDate(value),
            onFieldSubmitted: (_) => _nextFocus(),
            validator: (value) => _validator.validateDate(value ?? ""),
            textInputType: TextInputType.number,
            formatter: fullDateFormatter(),
            hint: "00/00/0000"),
        SizedBox(height: Dimens.spacingMedium),
        Text(getString(context, "space_reservation_raffle_participants"),
            style: LelloTextStyles.bodyBold(theme)),
        SizedBox(height: Dimens.spacingSmall),
        DropdownButtonFormField(
          onSaved: (value) =>
              data.participantType = value as RaffleParticipantType,
          value: data.participantType,
          items: [
            DropdownMenuItem(
                value: RaffleParticipantType.group,
                child: Text(getString(
                    context, "space_reservation_raffle_select_group"))),
            DropdownMenuItem(
                value: RaffleParticipantType.unit,
                child: Text(getString(
                    context, "space_reservation_raffle_select_unit"))),
            DropdownMenuItem(
                value: RaffleParticipantType.resident,
                child: Text(getString(
                    context, "space_reservation_raffle_select_resident"))),
          ],
          onChanged: (value) {
            setState(() {
              data.participantType = value as RaffleParticipantType;
              switch (data.participantType!) {
                case RaffleParticipantType.group:
                  data.participantResidents = [];
                  data.participantUnits = [];
                  break;
                case RaffleParticipantType.unit:
                  data.participantResidents = [];
                  data.participantGroups = [];
                  break;
                case RaffleParticipantType.resident:
                  data.participantUnits = [];
                  data.participantGroups = [];
                  break;
              }
            });
          },
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: Dimens.spacingMedium),
        _buildList(theme, state),
      ],
    );
  }

  Widget _buildList(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    Widget list;
    switch (data.participantType) {
      case RaffleParticipantType.group:
        list = _buildGroupList(theme, state);
        break;
      case RaffleParticipantType.unit:
        list = _buildUnitList(theme, state);
        break;
      case RaffleParticipantType.resident:
        list = _buildResidentsList(theme, state);
        break;
      default:
        list = Container();
        break;
    }

    return list;
  }

  Widget _buildGroupList(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    final items = state.units.map((e) => e.group).toSet().toList();
    return ListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];
          final title = _getTitle(item);
          return CheckboxListTile(
            title: Text(title, style: LelloTextStyles.body(theme)),
            value: data.participantGroups.contains(item),
            activeColor: theme.primaryColor,
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  data.participantGroups.add(item!);
                } else {
                  data.participantGroups.remove(item);
                }
              });
            },
          );
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length);
  }

  Widget _buildUnitList(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    final items = state.units;
    return ListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];
          final title = _getTitle(item);
          return CheckboxListTile(
            title: Text(title, style: LelloTextStyles.body(theme)),
            value: data.participantUnits.contains(item),
            activeColor: theme.primaryColor,
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  data.participantUnits.add(item);
                } else {
                  data.participantUnits.remove(item);
                }
              });
            },
          );
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length);
  }

  Widget _buildResidentsList(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    final items = state.residents;
    return ListView.builder(
        itemBuilder: (context, index) {
          final item = items[index];
          final title = _getTitle(item);
          return CheckboxListTile(
            title: Text(title, style: LelloTextStyles.body(theme)),
            value: data.participantResidents.contains(item),
            activeColor: theme.primaryColor,
            onChanged: (bool? value) {
              setState(() {
                if (value!) {
                  data.participantResidents.add(item);
                } else {
                  data.participantResidents.remove(item);
                }
              });
            },
          );
        },
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: items.length);
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
          ListTile(
            title: Text(getString(context, "space_reservation_date"),
                style: LelloTextStyles.bodyBold(theme)),
            subtitle: Text(
                registration.reservationStartDate != null
                    ? dateFormat.format(registration.reservationStartDate!)
                    : "-",
                style: LelloTextStyles.subBody(theme)),
          ),
        ],
      ),
    );
  }

  Widget _showConfirmation(
      ThemeData theme, ReservationRegistrationRaffleLoadedState state) {
    var items = [];
    switch (data.participantType!) {
      case RaffleParticipantType.group:
        items = state.units.map((e) => e.group).toSet().toList();
        break;
      case RaffleParticipantType.unit:
        items = state.units;
        break;
      case RaffleParticipantType.resident:
        items = state.residents;
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
                text: getString(context, "space_reservation_create_raffle"),
                onPressed: () {
                  bloc.beginRegister(data);
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

  void _nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  DateTime? _parseDate(String? value) {
    if (value == null || value.isEmpty) return null;
    return dateFormat.parse(value);
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      setState(() {
        showConfirmation = true;
      });
    }
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
