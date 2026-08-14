import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_detector_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class FaceRegisterErrorPageArgs {
  final DigitalTimesheetStatusEnum statusEnum;
  final bool isOnline;
  final Exception? knowException;
  final EmployeeInfo? employee;
  final String? condoRef;

  FaceRegisterErrorPageArgs(
      {required this.statusEnum,
      required this.isOnline,
      required this.employee,
      required this.condoRef,
      this.knowException});
}

class FaceRegisterErrorPage extends StatelessWidget {
  const FaceRegisterErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    FaceRegisterErrorPageArgs arguments =
        ModalRoute.of(context)!.settings.arguments as FaceRegisterErrorPageArgs;
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).error(),
        body: Padding(
          padding: EdgeInsets.all(Dimens.spacingLarge),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/ic_error.svg", width: 92, height: 92),
                SizedBox(height: Dimens.spacingLarge),
                Text(getString(context, "face_register_error_title"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    )),
                SizedBox(height: Dimens.spacing),
                _konwExceptionWidget(context, arguments.knowException)
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SizedBox(
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
                style: LelloTextStyles.button(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(
                    context, ApplicationRoute.faceDetectionView,
                    arguments: FaceDetectorArgs(
                      statusEnum: arguments.statusEnum,
                      isOnline: arguments.isOnline,
                      employee: arguments.employee,
                      condoRef: arguments.condoRef,
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _konwExceptionWidget(BuildContext context, Exception? knowException) {
    String? msg;
    if (knowException == null) {
      return Container();
    }
    switch (knowException.runtimeType) {
      case LocationServiceDisabledException:
        msg =
            getString(context, "face_register_error_location_service_disabled");
        break;
      case TimeoutException:
        msg = getString(context, "face_register_error_location_timeout");
        break;
      case TlsException:
        msg = (knowException as TlsException).message;
        break;
    }

    final theme = Theme.of(context);
    if (msg == null || msg.isEmpty) {
      return Text(getString(context, "face_register_error_subtitle"),
          textAlign: TextAlign.center,
          style: LelloTextStyles.body(theme)!.copyWith(
            color: LelloTheme.palleteOf(theme).customColor(),
          ));
    }

    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        Text(msg,
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).customColor(),
            )),
      ],
    );
  }
}
