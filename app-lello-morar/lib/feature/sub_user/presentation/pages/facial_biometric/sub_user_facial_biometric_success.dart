import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/feature/sub_user/domain/entity/sub_user.dart';
import 'package:morar/feature/sub_user/presentation/controllers/sub_user_controller.dart';

import '../../../../../core/dependency/application_container.dart';

class SubUserFacialSuccessPageArgs {
  final SubUserController controller;
  final SubUser subUser;

  SubUserFacialSuccessPageArgs(
      {required this.controller, required this.subUser});
}

class SubUserFacialBiometricSuccessPage extends StatefulWidget {
  const SubUserFacialBiometricSuccessPage({Key? key}) : super(key: key);

  @override
  State<SubUserFacialBiometricSuccessPage> createState() =>
      _SubUserFacialBiometricSuccessPageState();
}

class _SubUserFacialBiometricSuccessPageState
    extends State<SubUserFacialBiometricSuccessPage> {
  @override
  Widget build(BuildContext context) {
    final controller =
        ApplicationContainer.instance().resolve<SubUserController>();
    final theme = Theme.of(context);
    var arguments = ModalRoute.of(context)!.settings.arguments;
    final SubUserFacialSuccessPageArgs args =
        arguments as SubUserFacialSuccessPageArgs;
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).success(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_success.svg",
                    width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "facial_biometric_success_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor())),
                SizedBox(height: Dimens.spacingMedium),
                Text(
                  '${controller.session.condominium?.name ?? ''} - ${controller.session.unity?.title ?? ''}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor()),
                ),
                SizedBox(height: Dimens.spacingLarge),
                Text(
                  getString(context, "facial_biometric_success_subtitle"),
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                      fontWeight: FontWeight.w400,
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
                getString(context, "conclude"),
                style: LelloTextStyles.button(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).text()),
              ),
              onPressed: () {
                controller.getSubUsers();
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.subUserEdit,
                    arguments: args.controller);
              },
            ),
          ),
        ),
      ),
    );
  }
}
