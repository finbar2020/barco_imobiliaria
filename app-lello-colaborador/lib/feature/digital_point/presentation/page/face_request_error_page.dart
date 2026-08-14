import 'dart:async';
import 'dart:io';

import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_detector_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class FaceRequestErrorPageArgs {
  final DigitalTimesheetStatusEnum statusEnum;
  final bool isOnline;
  final EmployeeInfo? employee;
  final String? condoRef;
  final Exception? knowException;
  FaceRequestErrorPageArgs({
    required this.statusEnum,
    required this.isOnline,
    required this.knowException,
    required this.employee,
    this.condoRef,
  });
}

class FaceRequestErrorPage extends StatelessWidget {
  const FaceRequestErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    FaceRequestErrorPageArgs arguments =
        ModalRoute.of(context)!.settings.arguments as FaceRequestErrorPageArgs;
    return Theme(
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
                _knowExceptionWidget(arguments.knowException),
                SizedBox(height: Dimens.spacingLarge),
                Text(_knowExceptionTitle(context, arguments.knowException),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.headline(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    )),
                SizedBox(height: Dimens.spacing),
                Text(_knowExceptionSubtitle(context, arguments.knowException),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).customColor(),
                    )),
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
                      condoRef: arguments.condoRef,
                      employee: arguments.employee,
                    ));
              },
            ),
          ),
        ),
      ),
    );
  }

  String _knowExceptionTitle(BuildContext context, [Exception? knowException]) {
    if (knowException == null) {
      return getString(context, "face_request_error_title");
    }
    switch (knowException.runtimeType) {
      case LocationServiceDisabledException:
        return getString(context, "face_request_error_title");
      case TimeoutException:
        return getString(context, "face_request_error_title");
      case FormatException:
        return getString(context, "face_register_error_no_face_title");
      case ProcessException:
        return getString(context, "face_request_error_title");
      default:
        return getString(context, "face_request_error_title");
    }
  }

  String _knowExceptionSubtitle(BuildContext context,
      [Exception? knowException]) {
    if (knowException == null) {
      return getString(context, "face_request_error_subtitle");
    }
    switch (knowException.runtimeType) {
      case LocationServiceDisabledException:
        return getString(context, "face_request_error_subtitle");
      case TimeoutException:
        return getString(context, "face_request_error_subtitle");
      case FormatException:
        return getString(context, "face_register_error_no_face_subtitle");
      case ProcessException:
        return getString(context, "face_request_error_subtitle");
      default:
        return getString(context, "face_request_error_subtitle");
    }
  }

  Widget _knowExceptionWidget([Exception? knowException]) {
    Widget image = SvgPicture.asset("assets/ic_attention.svg",
        color: Colors.white, width: 92, height: 92);

    if (knowException == null) {
      return image;
    }
    switch (knowException.runtimeType) {
      case LocationServiceDisabledException:
        return image;
      case TimeoutException:
        return image;
      case FormatException:
        return const Icon(
          Icons.face_retouching_off,
          color: Colors.white,
          size: 92,
        );
      default:
        return image;
    }
  }

  Widget _konwExceptionWidget(BuildContext context, Exception? knowException) {
    String? msg;
    if (knowException == null) {
      return Container();
    }
    switch (knowException.runtimeType) {
      case LocationServiceDisabledException:
        msg = "face_register_error_location_service_disabled";
        break;
      case TimeoutException:
        msg = "face_register_error_location_timeout";
        break;
      case FormatException:
        msg = "face_register_error_no_face";
        break;
    }

    if (msg == null) {
      return Container();
    }

    final theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(height: Dimens.spacing),
        Text(getString(context, msg),
            textAlign: TextAlign.center,
            style: LelloTextStyles.body(theme)!.copyWith(
              color: LelloTheme.palleteOf(theme).customColor(),
            )),
      ],
    );
  }
}
