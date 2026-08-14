import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_detector_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LocationTimeoutErrorPageArgs {
  final DigitalTimesheetStatusEnum statusEnum;
  final bool isOnline;
  final EmployeeInfo? employee;
  final String? condoRef;
  final Exception? knowException;
  LocationTimeoutErrorPageArgs({
    required this.statusEnum,
    required this.isOnline,
    required this.employee,
    required this.condoRef,
    this.knowException,
  });
}

class LocationTimeoutErrorPage extends StatelessWidget {
  const LocationTimeoutErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Size size = MediaQuery.of(context).size;
    LocationTimeoutErrorPageArgs arguments = ModalRoute.of(context)!
        .settings
        .arguments as LocationTimeoutErrorPageArgs;
    return Theme(
      data: theme,
      child: Scaffold(
        backgroundColor: LelloTheme.palleteOf(theme).error(),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light
              .copyWith(statusBarColor: LelloTheme.palleteOf(theme).error()),
          child: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    width: size.width * 0.85,
                    top: size.height * 0.2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const Icon(
                          Icons.location_off_rounded,
                          color: Colors.white,
                          size: 92,
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        Text(
                          getString(context, "location_capture_error"),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.headline(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).customColor(),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingLarge),
                        Text(
                          getString(
                              context, "face_register_error_location_timeout"),
                          textAlign: TextAlign.center,
                          style: LelloTextStyles.body(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).customColor(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    width: size.width * 0.9,
                    bottom: size.height * 0.1,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: SizedBox(
                        height: 54.0,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                LelloTheme.palleteOf(theme).customColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            getString(context, "try_again"),
                            style: LelloTextStyles.button(theme)!.copyWith(
                              color: LelloTheme.palleteOf(theme).text(),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                              context,
                              ApplicationRoute.faceDetectionView,
                              arguments: FaceDetectorArgs(
                                statusEnum: arguments.statusEnum,
                                isOnline: arguments.isOnline,
                                employee: arguments.employee,
                                condoRef: arguments.condoRef,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
