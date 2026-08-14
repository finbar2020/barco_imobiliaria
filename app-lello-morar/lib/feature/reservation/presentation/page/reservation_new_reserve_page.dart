import 'package:essentials/essentials.dart';
import 'package:essentials/ui/widget/error_handling_widget/error_handling_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:morar/core/app_review/app_review.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/feature/reservation/presentation/controller/reservation_controller.dart';
import 'package:morar/feature/reservation/presentation/widget/reservation_success_dialog.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

import '../../../../core/dependency/application_container.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../home/domain/entity/unity.dart';
import '../../../session/presentation/bloc/session_bloc.dart';
import '../../domain/entity/space.dart';
import '../bloc/reservation_bloc.dart';
import '../bloc/reservation_state.dart';
import '../widget/reservation_bottom_sheet_widget.dart';
import '../widget/reservation_card_widget.dart';

class ReservationNewReservePage extends StatefulWidget {
  const ReservationNewReservePage({super.key});

  @override
  State<ReservationNewReservePage> createState() =>
      _ReservationNewReservePageState();
}

class _ReservationNewReservePageState extends State<ReservationNewReservePage> {
  Environment env = ApplicationContainer.instance().resolve<Environment>();
  final controller =
      ApplicationContainer.instance().resolve<ReservationController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final ReservationBloc bloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    final pallete = LelloTheme.palleteOf(theme);
    final chipTheme = Theme.of(context).copyWith(
      chipTheme: ChipThemeData(
        showCheckmark: false,
        selectedColor: pallete.grey(),
        shadowColor: pallete.backgroundDark(),
        selectedShadowColor: pallete.backgroundDark(),
        secondarySelectedColor: pallete.backgroundDark(),
        backgroundColor: pallete.background(),
      ),
      splashColor: pallete.grey().withOpacity(0.2),
      highlightColor: pallete.grey().withOpacity(0.1),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        secondary: pallete.grey(),
        primary: pallete.grey(),
        shadow: pallete.hubText(),
        tertiary: pallete.grey(),
        surface: pallete.text(),
        outline: pallete.separator(),
        secondaryContainer: pallete.grey(),
      ),
    );

    return BlocConsumer<ReservationBloc, ReservationState>(
      listener: (context, state) {},
      bloc: bloc,
      builder: (context, state) {
        if (state is ReservationEmptyState) {
          return Column(
            children: [
              Expanded(
                child: Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        if (state is LoadingSpaceState) {
          return Column(
            children: [
              Expanded(
                child: LoadingWidget(),
              ),
            ],
          );
        }
        if (state is FailureSpaceState) {
          return Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(Dimens.spacingMedium),
                  child: ErrorHandlingWidget(
                    reTryFunction: () {
                      bloc.getSpaces();
                    },
                    backFunction: () => Navigator.pop(context, true),
                    isProduction: env.isProduction,
                    error: "",
                    errorCode: "",
                  ),
                ),
              ),
            ],
          );
        }
        if (state is LoadedSpaceState ||
            state is LoadingCalendarState ||
            state is LoadedCalendarState ||
            state is FailureCalendarState ||
            state is LoadingDialogState ||
            state is LoadedDialogState ||
            state is FailureDialogState ||
            state is ReservationSendSuccessState) {
          if (controller.spaces.isEmpty) {
            controller.spaces = state.spaces;
          }
          return controller.filteredSpaces.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      if (controller.shouldShowFilter)
                        Wrap(
                          spacing: 8.0,
                          children: [
                            Theme(
                              data: chipTheme,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  if (controller.hasFreeArea)
                                    ChoiceChip(
                                      selected: controller.isFreeAreaSelected,
                                      elevation: 8.0,
                                      pressElevation: 7.0,
                                      selectedColor:
                                          LelloTheme.palleteOf(theme).grey(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      label: Row(
                                        children: [
                                          SvgPicture.asset(controller
                                                  .isFreeAreaSelected
                                              ? 'assets/icon_spaces_filter_free_white.svg'
                                              : 'assets/icon_spaces_filter_free.svg'),
                                          SizedBox(width: Dimens.spacingXSmall),
                                          Text(
                                            getString(
                                                context, "space_filter_free"),
                                            style: controller.isFreeAreaSelected
                                                ? TextStyle(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .background(),
                                                  )
                                                : TextStyle(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .textLight(),
                                                  ),
                                          ),
                                        ],
                                      ),
                                      onSelected: (bool value) {
                                        setState(() {
                                          controller.isFreeAreaSelected = value;
                                        });
                                      },
                                    ),
                                  if (controller.hasPaidArea)
                                    SizedBox(width: Dimens.spacing),
                                  if (controller.hasPaidArea)
                                    FilterChip(
                                      selectedColor:
                                          LelloTheme.palleteOf(theme).grey(),
                                      selected: controller.isPaidAreaSelected,
                                      elevation: 8.0,
                                      pressElevation: 7.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      label: Row(
                                        children: [
                                          SvgPicture.asset(controller
                                                  .isPaidAreaSelected
                                              ? 'assets/icon_spaces_filter_paid_white.svg'
                                              : 'assets/icon_spaces_filter_paid.svg'),
                                          SizedBox(width: Dimens.spacingXSmall),
                                          Text(
                                            getString(
                                                context, "space_filter_paid"),
                                            style: controller.isPaidAreaSelected
                                                ? TextStyle(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .background())
                                                : TextStyle(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .textLight()),
                                          ),
                                        ],
                                      ),
                                      onSelected: (bool value) {
                                        setState(() {
                                          controller.isPaidAreaSelected = value;
                                        });
                                      },
                                    ),
                                  if (controller.hasMovingArea)
                                    SizedBox(width: Dimens.spacing),
                                  if (controller.hasMovingArea)
                                    FilterChip(
                                      selected: controller.isMovingAreaSelected,
                                      selectedShadowColor:
                                          LelloTheme.palleteOf(theme).grey(),
                                      shadowColor:
                                          LelloTheme.palleteOf(theme).grey(),
                                      elevation: 8.0,
                                      pressElevation: 7.0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
                                      ),
                                      backgroundColor:
                                          LelloTheme.palleteOf(theme)
                                              .background(),
                                      selectedColor:
                                          LelloTheme.palleteOf(theme).grey(),
                                      label: Row(
                                        children: [
                                          SvgPicture.asset(controller
                                                  .isMovingAreaSelected
                                              ? 'assets/icon_spaces_filter_moving_white.svg'
                                              : 'assets/icon_spaces_filter_moving.svg'),
                                          SizedBox(width: Dimens.spacingXSmall),
                                          Text(
                                            getString(
                                                context, "space_filter_moving"),
                                            style: controller
                                                    .isMovingAreaSelected
                                                ? TextStyle(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .background(),
                                                  )
                                                : TextStyle(
                                                    color: LelloTheme.palleteOf(
                                                            theme)
                                                        .textLight(),
                                                  ),
                                          ),
                                        ],
                                      ),
                                      onSelected: (bool value) {
                                        setState(() {
                                          controller.isMovingAreaSelected =
                                              value;
                                        });
                                      },
                                    ),
                                ],
                              ),
                            )
                          ],
                        ),
                      SizedBox(height: Dimens.spacing),
                      if (controller.filteredSpaces.isNotEmpty)
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(
                              children: [
                                ...List.generate(
                                  controller.filteredSpaces.length,
                                  (index) {
                                    String reference = sessionBloc.state.session
                                            ?.condominium?.reference
                                            .toString() ??
                                        "";
                                    String rbac = getRbacForSpaceType(
                                        controller.filteredSpaces[index]);
                                    return AnimatedOpacity(
                                      opacity: 1.0,
                                      duration: Duration(milliseconds: 50000),
                                      child: CircuitBreakerWidget(
                                        appContainer:
                                            ApplicationContainer.instance(),
                                        reference: reference,
                                        applicationRbac: rbac,
                                        rbacEnabled:
                                            sessionBloc.checkRback(rbac),
                                        child: ReservationCardWidget(
                                          model:
                                              controller.filteredSpaces[index],
                                          onTap: () {
                                            if (_checkCanReserveSpace(
                                                controller
                                                    .filteredSpaces[index],
                                                sessionBloc
                                                    .state.session!.unity!)) {
                                              bloc.getCalendar(
                                                controller
                                                    .filteredSpaces[index].id!,
                                                DateTime.now(),
                                                DateTime.now().add(
                                                  Duration(days: 365),
                                                ),
                                              );
                                              _showCalendar(
                                                context: context,
                                                bloc: bloc,
                                                space: controller
                                                    .filteredSpaces[index],
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) =>
                                                    _buildErrorDialog(
                                                        theme, context),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset("assets/ic_billet_alert.svg"),
                      SizedBox(height: Dimens.spacing),
                      Text(
                        getString(context, "reserves_condominium_error"),
                        style: TextStyle(
                          color: LelloTheme.palleteOf(theme).text(),
                        ),
                      ),
                    ],
                  ),
                );
        }
        return Container();
      },
    );
  }

  _showCalendar(
      {required ReservationBloc bloc,
      required Space space,
      required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.9,
              child: ReservationBottomSheetWidget(
                bloc: bloc,
                space: space,
              ),
            )).then(
      (value) {
        {
          ReservationState curentState = bloc.state;
          if (curentState is ReservationSendSuccessState) {
            bloc.getSpaces();
            bloc.animateToTab(1);
            showDialog(
                context: context,
                builder: (context) => ReservationSuccessDialog(
                      bloc: bloc,
                      reserva: curentState.reservation,
                      space: curentState.space,
                      condominium: curentState.session?.condominium,
                      unity: curentState.session?.unity,
                    )).then((value) => AppReview.call(context: context));
          }
        }
      },
    );
  }

  Widget _buildErrorDialog(ThemeData theme, BuildContext context) {
    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: SvgPicture.asset("assets/ic_billet_alert.svg"),
            ),
            SizedBox(height: Dimens.spacing),
            Text(
              "${getString(context, "chat_error_title")}!",
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLightest(),
              ),
            ),
            Text(
              getString(context, "reserves_not_possible_make"),
              textAlign: TextAlign.center,
              style: LelloTextStyles.subtitle(theme)!.copyWith(
                color: LelloTheme.palleteOf(theme).textLightest(),
              ),
            ),
            InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: FlavorConfig.config.supportEmail),
                ).then((value) {
                  return Flushbar(
                    duration: Duration(seconds: 1),
                    message: getString(context, "email_copied"),
                  )..show(context);
                });
              },
              child: Text(FlavorConfig.config.supportEmail,
                  textAlign: TextAlign.center,
                  style: LelloTextStyles.subtitle(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLightest(),
                      decoration: TextDecoration.underline,
                      decorationColor:
                          LelloTheme.palleteOf(theme).textLightest())),
            ),
            SizedBox(height: Dimens.spacingLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    getString(context, "later").toUpperCase(),
                    style: LelloTextStyles.subBody(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).text(),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    _openWhatsapp(context);
                  },
                  child: Row(children: [
                    SvgPicture.asset(
                      "assets/ic_whats_red.svg",
                      color: theme.primaryColor,
                    ),
                    SizedBox(width: Dimens.spacingSmall),
                    Text(
                      getString(
                              context, "registration_lello_warning_no_data_btn")
                          .toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool _checkCanReserveSpace(Space space, Unity unit) {
    if (space.reservationRule.blockedForDefaulters!) {
      if (unit.compliant == false) return false;
    }
    if (space.reservationRule.blockedForSettlers!) {
      if (unit.agreement == true) return false;
    }
    return true;
  }

  Future<void> _openWhatsapp(BuildContext context) async {
    String message = "Oi, pode me ajudar?";
    Launch.whatsApp(context, FlavorConfig.config.supportMoradorWhatsAppNumber,
        message: message);
  }

  String getRbacForSpaceType(Space filteredSpaces) {
    if (filteredSpaces.reservationRule.chargeable == false &&
        filteredSpaces.type!.id != "M") {
      return ApplicationRbac.morarReservasAreasNovasReservasGratuitas;
    } else if (filteredSpaces.reservationRule.chargeable == true) {
      return ApplicationRbac.morarReservasAreasNovasReservasPagas;
    } else if (filteredSpaces.type!.id == "M") {
      return ApplicationRbac.morarReservasMudancasNovasReservas;
    } else {
      return "";
    }
  }
}
