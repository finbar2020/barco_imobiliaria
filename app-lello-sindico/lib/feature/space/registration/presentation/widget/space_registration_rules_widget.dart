import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc_impl.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';
import 'package:lello/feature/space/reservation/domain/entity/reservation_rule.dart';
import 'package:sprintf/sprintf.dart';

class SpaceRegistrationRulesWidget extends StatefulWidget {
  final bool shrinkList;

  const SpaceRegistrationRulesWidget({Key? key, this.shrinkList = false})
      : super(key: key);

  @override
  _SpaceRegistrationRulesWidgetState createState() =>
      _SpaceRegistrationRulesWidgetState();
}

class _SpaceRegistrationRulesWidgetState
    extends State<SpaceRegistrationRulesWidget> {
  final _formKey = GlobalKey<FormState>();
  final Validator _validator = ApplicationContainer.instance().resolve();
  late SpaceRegistrationBloc bloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    _validator.context = context;
    return _buildForm(theme);
  }

  Widget _buildHeader(ThemeData theme, SpaceRegistrationState state) {
    final steps = SpaceRegistrationBlocImpl.stepOrder;
    final currentStep = steps.indexOf(state.step!);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
          sprintf(getString(context, "register_payment_step"),
              [currentStep + 1, steps.length - 1]),
          style: LelloTextStyles.caption(theme)),
      subtitle: Text(getString(context, "space_registration_rules_title"),
          style: LelloTextStyles.subtitleBold(theme)),
      trailing:
          StepIndicator(numberOfSteps: steps.length, currentStep: currentStep),
    );
  }

  Widget _buildForm(ThemeData theme) {
    return BlocBuilder<SpaceRegistrationBloc, SpaceRegistrationState>(
      bloc: bloc,
      builder: (context, state) => Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: widget.shrinkList,
          physics: widget.shrinkList ? NeverScrollableScrollPhysics() : null,
          padding: EdgeInsets.all(Dimens.spacingMedium).copyWith(top: 0),
          children: [
            _buildHeader(theme, state),
            _buildYesNoFormItem(theme,
                title: getString(context, "space_registration_block_settlers"),
                groupValue: bloc.state.data.reservationRule.blockedForSettlers,
                onChanged: (value) =>
                    bloc.state.data.reservationRule.blockedForSettlers = value),
            _buildYesNoFormItem(theme,
                title:
                    getString(context, "space_registration_block_defaulters"),
                groupValue:
                    bloc.state.data.reservationRule.blockedForDefaulters,
                onChanged: (value) => bloc
                    .state.data.reservationRule.blockedForDefaulters = value),
            _buildFormItem(theme,
                title: getString(context, "space_registration_rule_article"),
                field: PrimaryTextFormField(
                  onSaved: (value) {
                    bloc.state.data.reservationRule.blockageArticle =
                        value ?? "";
                  },
                  onFieldSubmitted: (_) => _nextFocus(),
                  textInputType: TextInputType.multiline,
                )),
            SizedBox(height: Dimens.spacingMedium),
            Text(getString(context, "space_registration_rule_open_hour"),
                style: LelloTextStyles.bodyBold(theme)),
            Row(
              children: [
                Expanded(
                  child: _buildFormItem(theme,
                      title: getString(context, "from"),
                      field: PrimaryTextFormField(
                          initialValue: _timeToString(
                              bloc.state.data.reservationRule.openHour),
                          onSaved: (value) {
                            bloc.state.data.reservationRule.openHour =
                                _parseTime(value!);
                          },
                          onFieldSubmitted: (_) => _nextFocus(),
                          validator: (value) =>
                              _validator.validateTime(value ?? ""),
                          textInputType: TextInputType.number,
                          formatter: timeFormatter(),
                          hint: "00:00")),
                ),
                SizedBox(width: Dimens.spacingMedium),
                Expanded(
                  child: _buildFormItem(theme,
                      title: getString(context, "to"),
                      field: PrimaryTextFormField(
                          initialValue: _timeToString(
                              bloc.state.data.reservationRule.closeHour),
                          onSaved: (value) {
                            bloc.state.data.reservationRule.closeHour =
                                _parseTime(value!);
                          },
                          onFieldSubmitted: (_) => _nextFocus(),
                          validator: (value) =>
                              _validator.validateTime(value ?? ""),
                          textInputType: TextInputType.number,
                          formatter: timeFormatter(),
                          hint: "00:00")),
                )
              ],
            ),
            SizedBox(height: Dimens.spacing),
            _buildFormItem(theme,
                title: getString(
                    context, "space_registration_rule_default_duration"),
                field: PrimaryTextFormField(
                    initialValue: _timeToString(
                        bloc.state.data.reservationRule.defaultDuration),
                    onSaved: (value) {
                      bloc.state.data.reservationRule.defaultDuration =
                          _parseTime(value!);
                    },
                    onFieldSubmitted: (_) => _nextFocus(),
                    validator: (value) => _validator.validateTime(value ?? ""),
                    textInputType: TextInputType.number,
                    formatter: timeFormatter(),
                    hint: "00:00")),
            _buildFormItem(theme,
                title: getString(context,
                    "space_registration_rule_time_between_reservations"),
                field: PrimaryTextFormField(
                    initialValue: _timeToString(bloc
                        .state.data.reservationRule.timeBetweenReservations),
                    onSaved: (value) {
                      bloc.state.data.reservationRule.timeBetweenReservations =
                          _parseTime(value!);
                    },
                    onFieldSubmitted: (_) => _nextFocus(),
                    validator: (value) => _validator.validateTime(value ?? ""),
                    textInputType: TextInputType.number,
                    formatter: timeFormatter(),
                    hint: "00:00")),
            SizedBox(height: Dimens.spacingMedium),
            _buildLimitation(theme, state),
            SizedBox(height: Dimens.spacingMedium),
            _buildFormItem(theme,
                title: getString(
                    context, "space_registration_rule_total_reservations"),
                field: PrimaryTextFormField(
                  enabled: state.data.reservationRule.limitation != null &&
                      state.data.reservationRule.limitation !=
                          ReservationLimitation.none,
                  initialValue: state.data.reservationRule.limit.toString(),
                  onSaved: (value) {
                    bloc.state.data.reservationRule.limit =
                        value?.isNotEmpty == true ? int.parse(value ?? "0") : 0;
                  },
                  onFieldSubmitted: (_) => _nextFocus(),
                  textInputType: TextInputType.number,
                )),
            _buildFormItem(theme,
                title: getString(
                    context, "space_registration_rule_range_maximum"),
                field: PrimaryTextFormField(
                  initialValue: state
                      .data.reservationRule.reservationRangeMaximum
                      .toString(),
                  onSaved: (value) {
                    bloc.state.data.reservationRule.reservationRangeMaximum =
                        value?.isNotEmpty == true ? int.parse(value ?? "0") : 0;
                  },
                  onFieldSubmitted: (_) => _nextFocus(),
                  textInputType: TextInputType.number,
                  hint: getString(context, "fill_in"),
                )),
            _buildFormItem(theme,
                title: getString(
                    context, "space_registration_rule_range_minimum"),
                field: PrimaryTextFormField(
                  initialValue: state
                      .data.reservationRule.reservationRangeMinimum
                      .toString(),
                  onSaved: (value) {
                    bloc.state.data.reservationRule.reservationRangeMinimum =
                        value?.isNotEmpty == true ? int.parse(value ?? "0") : 0;
                  },
                  onFieldSubmitted: (_) => _nextFocus(),
                  hint: getString(context, "fill_in"),
                  textInputType: TextInputType.number,
                )),
            _buildYesNoFormItem(theme,
                title: getString(
                    context, "space_registration_rule_send_email_manager"),
                groupValue: bloc.state.data.reservationRule.sendEmailToManager,
                onChanged: (value) =>
                    bloc.state.data.reservationRule.sendEmailToManager = value),
            _buildYesNoFormItem(theme,
                title: getString(
                    context, "space_registration_rule_send_email_resident"),
                groupValue: bloc.state.data.reservationRule.sendEmailToResident,
                onChanged: (value) => bloc
                    .state.data.reservationRule.sendEmailToResident = value),
            SizedBox(height: Dimens.spacingMedium),
            PrimaryButton(
              onPressed: () {
                _save();
              },
              text: getString(context, "next"),
            ),
            SizedBox(height: Dimens.spacing),
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).maybePop();
              },
              text: getString(context, "back"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLimitation(ThemeData theme, SpaceRegistrationState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(getString(context, "space_registration_rule_limitation"),
            style: LelloTextStyles.bodyBold(theme)),
        RadioListTile(
            title: Text(
                getString(context, "space_registration_rule_limitation_none"),
                style: LelloTextStyles.body(theme)),
            value: ReservationLimitation.none,
            groupValue: state.data.reservationRule.limitation,
            onChanged: (value) => setState(() {
                  state.data.reservationRule.limitation =
                      value as ReservationLimitation;
                })),
        RadioListTile(
            title: Text(
                getString(context, "space_registration_rule_limitation_day"),
                style: LelloTextStyles.body(theme)),
            value: ReservationLimitation.day,
            groupValue: state.data.reservationRule.limitation,
            onChanged: (value) => setState(() {
                  state.data.reservationRule.limitation =
                      value as ReservationLimitation;
                })),
        RadioListTile(
            title: Text(
                getString(context, "space_registration_rule_limitation_month"),
                style: LelloTextStyles.body(theme)),
            value: ReservationLimitation.month,
            groupValue: state.data.reservationRule.limitation,
            onChanged: (value) => setState(() {
                  state.data.reservationRule.limitation =
                      value as ReservationLimitation;
                })),
        RadioListTile(
            title: Text(
                getString(context, "space_registration_rule_limitation_year"),
                style: LelloTextStyles.body(theme)),
            value: ReservationLimitation.year,
            groupValue: state.data.reservationRule.limitation,
            onChanged: (value) => setState(() {
                  state.data.reservationRule.limitation =
                      value as ReservationLimitation;
                })),
      ],
    );
  }

  Widget _buildFormItem(ThemeData theme, {String? title, Widget? field}) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        title ?? "",
        style: LelloTextStyles.bodyBold(theme),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Dimens.spacingSmall),
        child: field ?? Container(),
      ),
    );
  }

  Widget _buildYesNoFormItem(ThemeData theme,
      {String? title, bool? groupValue, Function(bool)? onChanged}) {
    return ListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        title ?? "",
        style: LelloTextStyles.bodyBold(theme),
      ),
      subtitle: Padding(
        padding: EdgeInsets.only(top: Dimens.spacingSmall),
        child: Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(getString(context, "no"),
                    style: LelloTextStyles.body(theme)),
                value: false,
                groupValue: groupValue,
                onChanged: (bool? value) {
                  setState(() {
                    onChanged?.call(value!);
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(getString(context, "yes"),
                    style: LelloTextStyles.body(theme)),
                value: true,
                groupValue: groupValue,
                onChanged: (bool? value) {
                  setState(() {
                    onChanged?.call(value!);
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  int _parseTime(String time) {
    final value = time.replaceAll(":", "");
    return int.parse(value);
  }

  String? _timeToString(int? time) {
    final data = time?.toString().padLeft(4, "0");
    if (data == null) return data;

    return "${data.substring(0, 2)}:${data.substring(2)}";
  }

  void _nextFocus() {
    FocusScope.of(context).nextFocus();
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bloc.nextStep();
    }
  }
}
