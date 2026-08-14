import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/shared_features.dart';

import '../../../../../../me/domain/entity/digital_timesheet_status_enum.dart';
import 'home_register_point_button.dart';
import 'home_timer_widget.dart';
import 'home_user_info_widget.dart';

class DigitalPointHeader extends StatelessWidget {
  final VoidCallback? callback;
  final bool isHomePage;
  final NotificationController notificationController;
  DigitalPointHeader({
    Key? key,
    required this.callback,
    this.isHomePage = false,
    required this.notificationController,
  }) : super(key: key);

  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();

  @override
  Widget build(BuildContext context) {
    DigitalTimesheetStatusEnum statusEnum =
        sessionBloc.getSession?.condominium.digitalTimesheetStatus ??
            DigitalTimesheetStatusEnum.declined;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
      child: Column(
        children: [
          if (isHomePage)
            HomeUserInfoWidget(
              me: sessionBloc.getSession!.me,
              reference: sessionBloc.getSession!.condominium.reference,
              notificationController: notificationController,
              circuitBreakerController: circuitBreakController,
            ),
          const HomeTimerWidget(),
          CircuitBreakerWidget(
            appContainer: ApplicationContainer.instance(),
            reference: sessionBloc.getSession!.condominium.reference,
            applicationRbac:
                HomeItemEnum.registerDigitalPoint.getCircuitBreakRbacString,
            rbacEnabled:
                HomeItemEnum.registerDigitalPoint.checkRbac(sessionBloc),
            child: HomeRegisterPointButton(
              registerPointStatusEnum: sessionBloc.canRegisterPoint
                  ? statusEnum
                  : DigitalTimesheetStatusEnum.notActivated,
              isOnline: false,
              callbackFunction: callback,
            ),
          ),
        ],
      ),
    );
  }
}
