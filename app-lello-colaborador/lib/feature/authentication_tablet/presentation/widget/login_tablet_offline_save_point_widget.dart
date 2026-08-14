import 'package:colaborador/core/custom_cached_network_image/custom_cached_network_image.dart';
import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/authentication_tablet/domain/entity/employee_info.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/digital_point/presentation/page/face_detector_page.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../core/bloc/inactivity/inactivity_cubit.dart';

class LoginTabletLoginOfflineSavePointWidget extends StatefulWidget {
  final EmployeeInfo employee;
  final String condoRef;
  final Function(LoginTabletSteps newStep) changeStep;
  const LoginTabletLoginOfflineSavePointWidget({
    Key? key,
    required this.employee,
    required this.changeStep,
    required this.condoRef,
  }) : super(key: key);

  @override
  State<LoginTabletLoginOfflineSavePointWidget> createState() =>
      _LoginTabletLoginOfflineSavePointWidgetState();
}

class _LoginTabletLoginOfflineSavePointWidgetState
    extends State<LoginTabletLoginOfflineSavePointWidget> {
  AuthenticationStore authenticationStore =
      ApplicationContainer.instance().resolve();

  final InactivityCubit inactivityCubit =
      ApplicationContainer.instance().resolve<InactivityCubit>();

  bool acceptTerms = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        widget.changeStep(LoginTabletSteps.employees);
        return false;
      },
      child: BlocProvider(
        create: (context) => authenticationStore.bloc,
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
            bloc: authenticationStore.bloc,
            listener: (context, state) {
              if (state is AuthenticatedState) {
                _showHome();
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: IgnorePointer(
                  ignoring: state is AuthenticatingState,
                  child: Padding(
                    padding: EdgeInsets.all(Dimens.spacingMedium),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                widget.changeStep(LoginTabletSteps.employees);
                              },
                              child: Icon(
                                Icons.arrow_back_ios_rounded,
                                color: LelloTheme.palleteOf(theme).hubText(),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Dimens.spacing),
                        SvgPicture.asset("assets/ic_attention_triangle.svg",
                            width: 92, height: 92),
                        SizedBox(height: Dimens.spacing),
                        Text(
                          getString(context, "register_tablet_offline"),
                          style: LelloTextStyles.title(theme)!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                          getString(
                              context, "register_tablet_offline_subtitle"),
                          style: LelloTextStyles.body(theme)!.copyWith(
                            fontWeight: FontWeight.normal,
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        Text(
                          getString(context, "register_tablet_offline_info"),
                          style: LelloTextStyles.bodyBold(theme)!.copyWith(
                            color: LelloTheme.palleteOf(theme).hubText(),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: Dimens.spacingXLarge),
                        Card(
                          elevation: 2.0,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(10000.0),
                                      child: CustomCachedNetworkImage(
                                        link: widget.employee.pictureLink,
                                        errorImageAssetsPath:
                                            "assets/user_placeholder.svg",
                                        isAnonymous: true,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Dimens.spacing),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getString(context,
                                                  "login_tablet_sign_name"),
                                              style: LelloTextStyles.bodyBold(
                                                      theme)
                                                  ?.copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .hubText(),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              widget.employee.nameFormatted,
                                              style: LelloTextStyles.body(theme)
                                                  ?.copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .hubText(),
                                              ),
                                              softWrap: true,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: Dimens.spacing),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              getString(context,
                                                  "login_tablet_sign_cpf"),
                                              style: LelloTextStyles.bodyBold(
                                                      theme)
                                                  ?.copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .hubText(),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              widget.employee.cpfFormatted,
                                              style: LelloTextStyles.body(theme)
                                                  ?.copyWith(
                                                color:
                                                    LelloTheme.palleteOf(theme)
                                                        .hubText(),
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: Dimens.spacingMedium),
                        if (widget.employee.statusEnum !=
                            DigitalTimesheetStatusEnum.approved)
                          Column(
                            children: [
                              Text(getString(
                                  context, "register_tablet_offline_no_photo"))
                            ],
                          )
                        else
                          Column(
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: acceptTerms,
                                    onChanged: (value) {
                                      setState(() {
                                        acceptTerms = !acceptTerms;
                                      });
                                    },
                                  ),
                                  Expanded(
                                    child: Text(
                                      getString(context,
                                          "register_tablet_offline_accept_terms"),
                                      style:
                                          LelloTextStyles.body(theme)!.copyWith(
                                        fontWeight: FontWeight.normal,
                                        color: LelloTheme.palleteOf(theme)
                                            .hubText(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimens.spacingMedium),
                              PrimaryButton(
                                  text: getString(
                                      context, "register_tablet_offline_btn"),
                                  onPressed: acceptTerms
                                      ? () async {
                                          await Navigator.pushNamed(
                                            context,
                                            ApplicationRoute.faceDetectionView,
                                            arguments: FaceDetectorArgs(
                                              statusEnum:
                                                  DigitalTimesheetStatusEnum
                                                      .pending,
                                              isOnline: false,
                                              employee: widget.employee,
                                              condoRef: widget.condoRef,
                                            ),
                                          );
                                          widget.changeStep(
                                              LoginTabletSteps.employees);
                                        }
                                      : null),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  void _showHome() {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(SharedApplicationRoute.home, (_) => false);
  }
}
