import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/sub_user/domain/use_cases/insert_sub_user/insert_sub_user_failures.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_edit_controller.dart';
import '../../../../../generated/l10n.dart';

class SendInviteErrorPage extends StatefulWidget {
  const SendInviteErrorPage({
    this.failure,
    Key? key,
  }) : super(key: key);

  final Failure? failure;

  @override
  State<SendInviteErrorPage> createState() => _SendInviteErrorPageState();
}

class _SendInviteErrorPageState extends State<SendInviteErrorPage> {
  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<SubUserEditController>();
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);

        return true;
      },
      child: Theme(
        data: theme,
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).warning(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(child: SizedBox(height: 100.0)),
                  SvgPicture.asset("assets/ic_blocked_info.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text(
                    getString(context, "facial_biometric_error_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor()),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Expanded(
                    child: Text(
                      getMessage(context),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor()),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 54.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "close"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  String getMessage(BuildContext context) {
    if (widget.failure is InsertSubUserConflictFailure) {
      return S.of(context).subUserAlreadyRegistered;
    }
    return getString(context, "residents_invite_error_subtitle");
  }
}
