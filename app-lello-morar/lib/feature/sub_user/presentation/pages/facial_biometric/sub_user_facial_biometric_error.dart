import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';

import '../../../../../core/dependency/application_container.dart';
import '../service/sub_user_service_on_page.dart';

class SubUserFacialBiometricErrorPageArgs {
  final SubUserController controller;
  final SubUser subUser;
  final String? message;
  final String? code;

  SubUserFacialBiometricErrorPageArgs({
    required this.controller,
    required this.subUser,
    this.message,
    this.code,
  });
}

class SubUserFacialBiometricErrorPage extends StatefulWidget {
  const SubUserFacialBiometricErrorPage({Key? key}) : super(key: key);

  @override
  State<SubUserFacialBiometricErrorPage> createState() =>
      _SubUserFacialBiometricErrorPageState();
}

class _SubUserFacialBiometricErrorPageState
    extends State<SubUserFacialBiometricErrorPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments;
    final controller =
        ApplicationContainer.instance().resolve<SubUserController>();
    final SubUserFacialBiometricErrorPageArgs args =
        arguments as SubUserFacialBiometricErrorPageArgs;
    return WillPopScope(
      onWillPop: () async {
        controller.getSubUsers();
        Navigator.pushReplacementNamed(
            context, ApplicationRoute.subUserServiceOn,
            arguments: SubUserServiceOnPageArgs(
              subUser: args.subUser,
            ));
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
                      arguments.message ??
                          getString(context, "facial_biometric_error_subtitle"),
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          color: LelloTheme.palleteOf(theme).customColor()),
                    ),
                  ),
                  if (arguments.code != null)
                    SizedBox(height: Dimens.spacingSmall),
                  if (arguments.code != null)
                    Text(
                      "code: ${arguments.code!}",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.subtitle(theme)!.copyWith(
                          fontSize: 8,
                          color: LelloTheme.palleteOf(theme).customColor()),
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
                  getString(context, "try_again"),
                  style: LelloTextStyles.button(theme)!
                      .copyWith(color: LelloTheme.palleteOf(theme).text()),
                ),
                onPressed: () async {
                  Navigator.pushReplacementNamed(
                    context,
                    ApplicationRoute.subUserServiceOn,
                    arguments: SubUserServiceOnPageArgs(
                      subUser: args.subUser,
                    ),
                  );

                  await controller.getFacialBiometric();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
