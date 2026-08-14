import 'package:colaborador/feature/me/presentation/bloc/me_bloc.dart';
import 'package:colaborador/feature/me/presentation/bloc/me_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class MeEditPhoneInfo extends StatefulWidget {
  final MeBloc bloc;
  final bool isPhoneCheck;
  final bool isEmailCheck;

  const MeEditPhoneInfo({
    super.key,
    required this.bloc,
    required this.isPhoneCheck,
    required this.isEmailCheck,
  });

  @override
  _MeEditPhoneInfoState createState() => _MeEditPhoneInfoState();
}

class _MeEditPhoneInfoState extends State<MeEditPhoneInfo> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<MeBloc, MeState>(
      bloc: widget.bloc,
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
                  visible: state is! MeEditRequestingCodeState,
                  replacement: const Center(child: CircularProgressIndicator()),
                  child: PrimaryButton(
                      text: getString(context, "receive_code"),
                      onPressed: () {
                        widget.bloc.beginCodeRequest(
                            isPhoneCheck: widget.isPhoneCheck,
                            isEmailCheck: widget.isEmailCheck);
                      }),
                ),
                SizedBox(height: Dimens.spacingMedium),
                SizedBox(
                  height: 54.0,
                  child: SecondaryButton(
                      text: getString(context, "cancel"),
                      onPressed: () {
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
