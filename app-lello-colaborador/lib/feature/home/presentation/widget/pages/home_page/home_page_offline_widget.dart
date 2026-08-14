import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/digital_point/domain/entity/digital_point.dart';

import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/digital_point_unsychronized_widget.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_digital_timesheet_utils.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';

class HomePageOfflineWidget extends StatefulWidget {
  final List<DigitalPointEntity> digitalPoints;
  const HomePageOfflineWidget({
    Key? key,
    required this.digitalPoints,
  }) : super(key: key);

  @override
  State<HomePageOfflineWidget> createState() => _HomePageOfflineWidgetState();
}

class _HomePageOfflineWidgetState extends State<HomePageOfflineWidget> {
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();
  DigitalTimesheetStatusEnum statusEnum = DigitalTimesheetStatusEnum.declined;

  @override
  void initState() {
    super.initState();
    statusEnum = sessionBloc.getSession!.condominium.digitalTimesheetStatus;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeRequestsDigitalTimesheetUtils.show(context, statusEnum, false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
      child: widget.digitalPoints.isNotEmpty
          ? DigitalPointsUnsynchronizedWidget(
              digitalPoints: widget.digitalPoints,
            )
          : Container(),
    );
  }
}
