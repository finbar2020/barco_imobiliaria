import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/feature/me/presentation/bloc/me_state.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';

class MeEditPhoneInfo extends StatefulWidget {
  final MeController controller;
  final void Function()? cancelOnPressed;
  final bool isPhoneCheck;
  final bool isEmailCheck;

  MeEditPhoneInfo({
    Key? key,
    required this.controller,
    this.cancelOnPressed,
    this.isPhoneCheck = true,
    this.isEmailCheck = false,
  }) : super(key: key);

  @override
  _MeEditPhoneInfoState createState() => _MeEditPhoneInfoState();
}

class _MeEditPhoneInfoState extends State<MeEditPhoneInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder(
      bloc: widget.controller.bloc,
      builder: (context, state) => Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: Dimens.spacingXLarge,
                bottom: Dimens.spacingMedium,
                left: Dimens.spacingMedium,
                right: Dimens.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (widget.isPhoneCheck)
                  SvgPicture.asset("assets/ic_no_edit_phone.svg", width: 85),
                if (widget.isEmailCheck)
                  Icon(Icons.mail_lock,
                      size: 85, color: LelloTheme.palleteOf(theme).grey()),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                    getString(
                        context,
                        widget.isPhoneCheck
                            ? "profile_change_phone_rationale"
                            : "profile_change_email_rationale"),
                    style: LelloTextStyles.body(theme),
                    textAlign: TextAlign.center),
                SizedBox(height: Dimens.spacing),
                Visibility(
                  visible: state is MeEditRequestCodeFailedState,
                  child: Text(
                    getString(context, "request_validation_code_failed"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.error(theme),
                  ),
                ),
                Visibility(
                  visible: state is MeEditNoContactAvailableState,
                  child: Text(
                    getString(
                        context, "registration_phone_email_empty_dialog_description"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.error(theme),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Visibility(
                  visible: !(state is MeEditRequestingCodeState),
                  child: PrimaryButton(
                      text: getString(context, "receive_code"),
                      onPressed: () {
                        widget.controller.validationCode(
                            isPhoneCheck: widget.isPhoneCheck,
                            isEmailCheck: widget.isEmailCheck);
                      }),
                  replacement: Center(child: CircularProgressIndicator()),
                ),
                SizedBox(height: Dimens.spacingMedium),
                Container(
                  height: 54.0,
                  child: SecondaryButton(
                      text: getString(context, "cancel"),
                      onPressed: widget.cancelOnPressed ??
                          () {
                            Navigator.of(context).pop();
                          }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
