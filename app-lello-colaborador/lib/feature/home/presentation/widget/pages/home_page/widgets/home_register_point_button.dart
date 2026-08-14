// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:colaborador/core/analytics/analytics_log_events.dart';
import 'package:colaborador/core/widgets/device_type_error_dialog.dart';
import 'package:colaborador/feature/home/presentation/bloc/register_point_bloc.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/analytics/events/analytics_events_employee.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/access_settings_permission_denied/entity/access_settings_permissions_denied_item.dart';
import 'package:shared_features/feature/access_settings_permission_denied/presentation/page/access_settings_permission_denied_page.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../../../core/dependency/application_container.dart';
import '../../../../../../../core/navigation/application_route.dart';
import '../../../../../../../core/widgets/afastamento_dialog.dart';
import '../../../../../../digital_point/presentation/page/face_detector_page.dart';
import '../../../airplane_mode_dialog.dart';
import 'home_clock_in_range_out_dialog.dart';

class HomeRegisterPointButton extends StatefulWidget {
  final DigitalTimesheetStatusEnum registerPointStatusEnum;
  final bool isOnline;
  final VoidCallback? callbackFunction;

  const HomeRegisterPointButton({
    Key? key,
    required this.registerPointStatusEnum,
    this.isOnline = false,
    this.callbackFunction,
  }) : super(key: key);

  @override
  State<HomeRegisterPointButton> createState() =>
      _HomeRegisterPointButtonState();
}

class _HomeRegisterPointButtonState extends State<HomeRegisterPointButton> {
  final RegisterPointController controller =
      ApplicationContainer.instance().resolve();
  final HomeController homeController =
      ApplicationContainer.instance().resolve<HomeController>();

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color statusColor = DigitalTimesheetStatus.color(
      widget.registerPointStatusEnum,
      controller.sessionBloc,
    );

    return BlocListener(
      bloc: controller.registerPointBloc,
      listener: (context, state) async {
        if (state is OfflineFailureState) {
          AirplaneModeDialog.show(context);
        }
        if (state is NoLocationPermissionState) {
          await Navigator.of(context).pushNamed(
            SharedApplicationRoute.accessSettingsPermissionDenied,
            arguments: AcessSettingsPermissionDeniedPageArgs(
              acessSettingsPermissionsDeniedItem:
                  AcessSettingsPermissionsDeniedItem(
                item: AcessSettingsPermissionsDeniedItemEnum.location,
                isColaboradorApp: true,
              ),
            ),
          );
        }
        if (state is WorkLeaveState) {
          await showDialog(
            context: context,
            builder: (context) {
              return AfastamentoDialog(
                workLeaveDescription: state.description,
              );
            },
          );
        }
        if (state is DeviceTypeFailureState) {
          await showDialog(
            context: context,
            builder: (context) {
              return DeviceTypeDialog(
                onlyTablet: state.onlyTablet,
                onlyPhone: state.onlyPhone,
              );
            },
          );
        }
        if (state is OutOfRangeState) {
          final result = await showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return HomeClockInRangeOutDialog(
                registerPointStatusEnum: widget.registerPointStatusEnum,
                isOnline: widget.isOnline,
              );
            },
          );
          if (result) {
            await Navigator.pushNamed(
              context,
              ApplicationRoute.faceDetectionView,
              arguments: FaceDetectorArgs(
                statusEnum: widget.registerPointStatusEnum,
                isOnline: widget.isOnline,
                condoRef: null,
                employee: null,
              ),
            );
          }
        }
        if (state is RegisterPointFaceCaptureState) {
          await Navigator.pushNamed(
            context,
            ApplicationRoute.faceDetectionView,
            arguments: FaceDetectorArgs(
              statusEnum: widget.registerPointStatusEnum,
              isOnline: widget.isOnline,
              condoRef: null,
              employee: null,
            ),
          );
        }
        if (state is StartRegisterPointState) {
          switch (widget.registerPointStatusEnum) {
            case DigitalTimesheetStatusEnum.notActivated:
              FirebaseRemoteConfig? remoteConfig =
                  controller.sessionBloc.remoteConfig;
              Map<String, dynamic>? pontoDigital;
              try {
                if (remoteConfig != null) {
                  pontoDigital = jsonDecode(
                    remoteConfig.getString(
                      CustomFirebaseRemoteConfig.pontoDigital,
                    ),
                  );
                }
              } catch (_) {}
              Launch.urlUri(
                context,
                UrlsUri.pontoDigital(
                  url: pontoDigital != null
                      ? pontoDigital["link"]
                      : pontoDigital,
                ),
                mode: LaunchMode.externalApplication,
              );
              EmployeeAnalyticsLogEvents.logEvent(
                event:
                    AnalyticsEventsEmployee.homeConhecerPontoDigitalAcessar(),
                referenceValue:
                    controller.session.condominium.reference.toString(),
              );
              break;
            case DigitalTimesheetStatusEnum.approved:
              //multi click wile loading
              if (!controller.isLoading) {
                EmployeeAnalyticsLogEvents.logEvent(
                  event: AnalyticsEventsEmployee
                      .homeRegistrarPontoDigitalAcessar(),
                  referenceValue:
                      controller.session.condominium.reference.toString(),
                );
                controller.checkDistanceAndGo();
              }
              break;
            case DigitalTimesheetStatusEnum.pending:
              break;
            default:
              EmployeeAnalyticsLogEvents.logEvent(
                event:
                    AnalyticsEventsEmployee.homeRegistrarPontoDigitalAcessar(),
                referenceValue:
                    controller.session.condominium.reference.toString(),
              );
              if (homeController.pageController!.page == 0)
                homeController.colaboradorHomeTimerStop();
              await Navigator.pushNamed(
                context,
                ApplicationRoute.faceDetectionView,
                arguments: FaceDetectorArgs(
                  statusEnum: widget.registerPointStatusEnum,
                  isOnline: widget.isOnline,
                  condoRef: null,
                  employee: null,
                ),
              ).then((_) {
                if (homeController.pageController!.page == 0) {
                  homeController.colaboradorHomeTimerStart();
                }
              });

              break;
          }
        }
        if (controller.isLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                getString(context, "please_wait"),
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.all(Dimens.spacingSmall),
        child: InkWell(
          onTap: controller.onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: Dimens.spacingMedium, vertical: Dimens.spacing),
            decoration: BoxDecoration(
              border: Border.all(
                width: 0.5,
                color: statusColor,
              ),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder(
                    bloc: controller.registerPointBloc,
                    builder: (context, state) {
                      if (controller.isLoading) {
                        return SizedBox(
                          height: 32,
                          width: 32,
                          child: CircularProgressIndicator.adaptive(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(statusColor),
                          ),
                        );
                      }
                      return SizedBox(
                        height: 32,
                        width: 32,
                        child: SvgPicture.asset(
                          "assets/ic_register_point.svg",
                          color: statusColor,
                        ),
                      );
                    }),
                SizedBox(
                  width: Dimens.spacing,
                ),
                Flexible(
                  child: Text(
                    DigitalTimesheetStatus.text(
                      context: context,
                      sessionBloc: controller.sessionBloc,
                      statusEnum: widget.registerPointStatusEnum,
                    ),
                    // sessionBloc.getSession?.condominium.workLeaveDescription ?? "",
                    style: LelloTextStyles.titleSmall(theme)
                        ?.copyWith(color: statusColor),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
