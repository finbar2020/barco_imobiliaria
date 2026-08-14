import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/widget/step_indicator.dart';
import 'package:lello/feature/account/domain/entity/account.dart';
import 'package:lello/feature/space/domain/entity/reservation_payment_method.dart';
import 'package:lello/feature/space/domain/entity/reservation_value_type.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_bloc.dart';
import 'package:lello/feature/space/registration/presentation/bloc/registration/space_registration_state.dart';
import 'package:sprintf/sprintf.dart';

class SpaceRegistrationChargingWidget extends StatefulWidget {
  final bool shrinkList;

  const SpaceRegistrationChargingWidget({Key? key, this.shrinkList = false})
      : super(key: key);

  @override
  _SpaceRegistrationChargingWidgetState createState() =>
      _SpaceRegistrationChargingWidgetState();
}

class _SpaceRegistrationChargingWidgetState
    extends State<SpaceRegistrationChargingWidget> {
  final _formKey = GlobalKey<FormState>();

  final Validator _validator = ApplicationContainer.instance().resolve();
  final formatCurrency = NumberFormat.currency(symbol: "");
  late SpaceRegistrationBloc bloc;

  final valueController = TextEditingController();
  TextInputFormatter? valueFormatter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    _validator.context = context;
    return _buildForm(theme);
  }

  Widget _buildHeader(ThemeData theme, SpaceRegistrationState state) {
    final steps = SpaceRegistrationBloc.stepOrder;
    final currentStep = steps.indexOf(state.step!);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
          sprintf(getString(context, "register_payment_step"),
              [currentStep + 1, steps.length - 1]),
          style: LelloTextStyles.caption(theme)),
      subtitle: Text(getString(context, "space_registration_charge_title"),
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
                title:
                    getString(context, "space_registration_charge_chargeable"),
                groupValue: state.data.reservationRule.chargeable,
                onChanged: (value) =>
                    state.data.reservationRule.chargeable = value),
            _buildCharging(theme, state),
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

  Widget _buildCharging(ThemeData theme, SpaceRegistrationState state) {
    return Visibility(
      visible: state.data.reservationRule.chargeable == true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildFormItem(theme,
              title: getString(
                  context, "space_reservation_cancellation_limit_days"),
              field: PrimaryTextFormField(
                  initialValue:
                      state.data.reservationRule.cancellationLimit.toString(),
                  onSaved: (value) {
                    state.data.reservationRule.cancellationLimit =
                        int.parse(value ?? "0");
                  },
                  validator: (value) => _validator.validateRequired(value),
                  textInputType: TextInputType.number,
                  hint: getString(context, "fill_in"))),
          Text(
              getString(
                  context, "space_registration_charge_days_before_usage"),
              style: LelloTextStyles.caption(theme)),
          SizedBox(height: Dimens.spacingSmall),
          _buildFormItem(
            theme,
            title: getString(context, "space_registration_charge_account"),
            field: DropdownButtonFormField(
              onSaved: (value) {
                state.data.reservationRule.account =
                    value as Account? ?? Account();
              },
              items: state.accounts
                  .map((e) => DropdownMenuItem(child: Text(e.name!), value: e))
                  .toList(),
              onChanged: (value) {
                state.data.reservationRule.account =
                    value as Account? ?? Account();
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: Dimens.spacing),
          Text(getString(context, "space_registration_charge_payment_method"),
              style: LelloTextStyles.bodyBold(theme)),
          RadioListTile(
              title: Text(
                  _getPaymentMethodTitle(ReservationPaymentMethod.quota),
                  style: LelloTextStyles.body(theme)),
              value: ReservationPaymentMethod.quota,
              groupValue: state.data.reservationRule.paymentMethod,
              onChanged: (value) => setState(() {
                    state.data.reservationRule.paymentMethod =
                        value as ReservationPaymentMethod;
                  })),
          RadioListTile(
              title: Text(
                  _getPaymentMethodTitle(ReservationPaymentMethod.billet),
                  style: LelloTextStyles.body(theme)),
              value: ReservationPaymentMethod.billet,
              groupValue: state.data.reservationRule.paymentMethod,
              onChanged: (value) => setState(() {
                    state.data.reservationRule.paymentMethod =
                        value as ReservationPaymentMethod;
                  })),
          SizedBox(height: Dimens.spacing),
          Text(
              getString(
                  context, "space_registration_charge_payment_value_type"),
              style: LelloTextStyles.bodyBold(theme)),
          RadioListTile(
              title: Text(_getPaymentValueTitle(ReservationValueType.value),
                  style: LelloTextStyles.body(theme)),
              value: ReservationValueType.value,
              groupValue: state.data.reservationRule.valueType,
              onChanged: (value) => setState(() {
                    state.data.reservationRule.valueType =
                        value as ReservationValueType;
                  })),
          RadioListTile(
              title: Text(
                  _getPaymentValueTitle(ReservationValueType.percentage),
                  style: LelloTextStyles.body(theme)),
              value: ReservationValueType.percentage,
              groupValue: state.data.reservationRule.valueType,
              onChanged: (value) => setState(() {
                    state.data.reservationRule.valueType =
                        value as ReservationValueType;
                  })),
          SizedBox(height: Dimens.spacing),
          _buildFormItem(theme,
              title: getString(
                  context, "space_registration_charge_payment_value"),
              field: PrimaryTextFormField(
                  initialValue:
                      formatCurrency.format(state.data.reservationRule.price),
                  formatter: currencyFormatter(showSymbol: false),
                  onSaved: (value) {
                    state.data.reservationRule.price =
                        formatCurrency.parse(value as String) as double;
                  },
                  validator: (value) => _validator.validateRequired(value),
                  textInputType: TextInputType.number,
                  hint: getString(context, "fill_in"))),
        ],
      ),
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

  String _getPaymentMethodTitle(ReservationPaymentMethod method) {
    switch (method) {
      case ReservationPaymentMethod.quota:
        return getString(context, "space_reservation_payment_quota");
      case ReservationPaymentMethod.billet:
        return getString(context, "space_reservation_payment_billet");
    }
  }

  String _getPaymentValueTitle(ReservationValueType type) {
    switch (type) {
      case ReservationValueType.percentage:
        return getString(
            context, "space_reservation_payment_quota_percentage");
      case ReservationValueType.value:
        return getString(context, "space_reservation_payment_money");
    }
  }

  void _save() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      bloc.nextStep();
    }
  }
}
