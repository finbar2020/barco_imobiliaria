import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/presentation/failure_message.dart';
import 'package:lello/feature/payment/domain/entity/payment_approval_type.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_bloc.dart';
import 'package:lello/feature/payment/presentation/approval/bloc/payment_approval_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:lello/feature/session/presentation/bloc/session_state.dart';

class PaymentApprovalFormWidget extends StatefulWidget {
  const PaymentApprovalFormWidget({super.key});

  @override
  PaymentApprovalFormWidgetState createState() =>
      PaymentApprovalFormWidgetState();
}

class PaymentApprovalFormWidgetState extends State<PaymentApprovalFormWidget> {
  CodeValidationSource source = CodeValidationSource.phone;
  late PaymentApprovalBloc bloc;
  late SessionBloc sessionBloc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bloc = BlocProvider.of(context);
    sessionBloc = BlocProvider.of(context);
    final state = bloc.state;
    String? error;
    if (state is PaymentApprovalFailedState) {
      error = FailureMessage.get(context, state.error!);
    }
    if (state is PaymentApprovalCodeFailedState) {
      error = FailureMessage.get(context, state.error!);
    }
    if (state is PaymentApprovalBiometricsFailureState) {
      error = getString(context, "error_biometric_failure");
    }
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(Dimens.spacingMedium),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAction(theme),
              SizedBox(height: Dimens.spacing),
              Visibility(
                  visible: state.entity?.type == PaymentApprovalType.cancel,
                  child: _buildReason(theme)),
              SizedBox(height: Dimens.spacingMedium),
              _buildCodeOption(theme),
              Visibility(
                visible: error != null,
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacing),
                  child: Text(error ?? "",
                      style: LelloTextStyles.error(theme),
                      textAlign: TextAlign.center),
                ),
              ),
              SizedBox(height: Dimens.spacing),
              PrimaryButton(
                  text: source == CodeValidationSource.biometria
                      ? "Autenticar"
                      : getString(context, "receive_code"),
                  onPressed: () {
                    bloc.beginRequestValidationCode(source);
                  }),
              SizedBox(height: Dimens.spacing),
              SecondaryButton(
                  text: getString(context, "cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAction(ThemeData theme) {
    var padding = EdgeInsets.only(top: Dimens.spacingSmall);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(getString(context, "payment_approval_action"),
            style: LelloTextStyles.bodyBold(theme)),
        CustomRadioListTile(
          title: getString(context, "payment_approval_approve"),
          value: PaymentApprovalType.approve,
          groupValue: bloc.state.entity?.type,
          padding: padding,
          onChanged: (PaymentApprovalType? value) {
            if (value == null) return;
            setState(() {
              bloc.state.entity?.type = value;
            });
          },
        ),
        CustomRadioListTile(
          title: getString(context, "payment_approval_suspend"),
          value: PaymentApprovalType.suspend,
          groupValue: bloc.state.entity?.type,
          padding: padding,
          onChanged: (PaymentApprovalType? value) {
            if (value == null) return;
            setState(() {
              bloc.state.entity?.type = value;
            });
          },
        ),
        CustomRadioListTile(
          title: getString(context, "payment_approval_cancel"),
          value: PaymentApprovalType.cancel,
          groupValue: bloc.state.entity?.type,
          padding: padding,
          onChanged: (PaymentApprovalType? value) {
            if (value == null) return;
            setState(() {
              bloc.state.entity?.type = value;
            });
          },
        ),
      ],
    );
  }

  Widget _buildReason(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(getString(context, "payment_approval_reason"),
              style: LelloTextStyles.bodyBold(theme)),
          SizedBox(height: Dimens.spacingSmall),
          TextFormField(
            initialValue: bloc.state.entity?.reason,
            onChanged: (value) => bloc.state.entity?.reason = value,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: getString(context, "fill_in")),
          )
        ],
      );

  Widget _buildCodeOption(ThemeData theme) {
    return BlocBuilder(
      bloc: bloc,
      builder: (context, state) {
        final phone =
            state is SessionLoadedState ? state.session?.me?.phone : "";
        final email =
            state is SessionLoadedState ? state.session?.me?.email : "";
        String phoneFormatted = formatPhoneNumber(phone: phone ?? "");
        final authEnabled = bloc.getCanAutenticate();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(getString(context, "payment_approval_code_source"),
                style: LelloTextStyles.bodyBold(theme)),
            SizedBox(height: Dimens.spacingSmall),
            CustomRadioListTile(
              title:
                  '${getString(context, "payment_approval_sms")} - $phoneFormatted',
              value: CodeValidationSource.phone,
              groupValue: source,
              onChanged: (CodeValidationSource? value) {
                setState(() {
                  source = value!;
                });
              },
            ),
            CustomRadioListTile(
              title: '${getString(context, "payment_approval_email")} - $email',
              value: CodeValidationSource.email,
              groupValue: source,
              onChanged: (CodeValidationSource? value) {
                setState(() {
                  source = value!;
                });
              },
            ),
            if (authEnabled)
              CustomRadioListTile(
                title: getString(context, "payment_approval_biometric"),
                value: CodeValidationSource.biometria,
                groupValue: source,
                onChanged: (CodeValidationSource? value) {
                  setState(() {
                    source = value!;
                  });
                },
              ),
          ],
        );
      },
    );
  }
}

String formatPhoneNumber({required String phone}) {
  String numericPhone = phone.replaceAll(RegExp(r'\D'), '');

  if (numericPhone.length == 10 || numericPhone.length == 11) {
    return '(${numericPhone.substring(0, 2)}) ${numericPhone.substring(2, 7)}-${numericPhone.substring(7)}';
  } else {
    return phone;
  }
}
