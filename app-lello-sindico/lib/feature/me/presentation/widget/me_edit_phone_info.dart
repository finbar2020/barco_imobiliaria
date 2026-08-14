import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/me/presentation/bloc/me_bloc.dart';
import 'package:lello/feature/me/presentation/bloc/me_state.dart';
import 'package:lello/feature/me/presentation/controller/me_controller.dart';
import 'package:lello/feature/me/presentation/page/me_code_validation_page.dart';

class MeEditPhoneInfoWidget extends StatefulWidget {
  final bool isChangingEmail;
  final bool isChangingPhone;
  const MeEditPhoneInfoWidget(
      {super.key,
      required this.isChangingEmail,
      required this.isChangingPhone});

  @override
  MeEditPhoneInfoState createState() => MeEditPhoneInfoState();
}

class MeEditPhoneInfoState extends State<MeEditPhoneInfoWidget> {
  @override
  Widget build(BuildContext context) {
    final controller = ApplicationContainer.instance().resolve<MeController>();
    final theme = Theme.of(context);

    return BlocConsumer<MeBloc, MeState>(
      bloc: controller.meBloc,
      listener: (context, state) {
        if (state is MeEditValidateCodeState) {
          Navigator.pushReplacementNamed(
                  context, ApplicationRoute.meCodeValidation,
                  result: true)
              .then((value) {
            if (value is MeCodeValidationPageResult) {
              switch (value) {
                case MeCodeValidationPageResult.cancel:
                  controller.cancelValidation();
                  break;
                case MeCodeValidationPageResult.restart:
                  controller.resendToken();
                default:
                  break;
              }
            }
          });
        }
      },
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
                if (widget.isChangingPhone)
                  SvgPicture.asset("assets/ic_no_edit_phone.svg", width: 85),
                if (widget.isChangingEmail)
                  Icon(Icons.mail_lock,
                      size: 85, color: LelloTheme.palleteOf(theme).grey()),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                    getString(
                        context,
                        widget.isChangingPhone
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
                      buttonColor: theme.primaryColor,
                      text: getString(context, "receive_code"),
                      onPressed: () async {
                        await controller.requestValidationCode(
                          isChangingPhone: widget.isChangingPhone,
                          isChangingEmail: widget.isChangingEmail,
                        );
                      }),
                ),
                SizedBox(height: Dimens.spacingMedium),
                SecondaryButton(
                  text: getString(context, "cancel"),
                  onPressed: () {
                    controller.cancelValidation();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
