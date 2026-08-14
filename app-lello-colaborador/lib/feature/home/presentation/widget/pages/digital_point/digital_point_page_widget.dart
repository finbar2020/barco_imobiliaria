// ignore_for_file: use_build_context_synchronously

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';

import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_digital_timesheet_utils.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:flutter/material.dart';

import 'package:essentials/essentials.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class DigitalPointPageWidget extends StatefulWidget {
  final RegisterPointController registerController;
  const DigitalPointPageWidget({
    Key? key,
    required this.registerController,
  }) : super(key: key);

  @override
  State<DigitalPointPageWidget> createState() => _DigitalPointPageWidgetState();
}

class _DigitalPointPageWidgetState extends State<DigitalPointPageWidget> {
  DigitalTimesheetStatusEnum statusEnum = DigitalTimesheetStatusEnum.declined;
  late SessionBloc sessionBloc;

  @override
  void initState() {
    super.initState();
    statusEnum =
        widget.registerController.session.condominium.digitalTimesheetStatus;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeRequestsDigitalTimesheetUtils.show(context, statusEnum, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    sessionBloc = BlocProvider.of(context);
    return Material(
      color: LelloTheme.palleteOf(theme).customColor(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Dimens.spacing),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  getString(context, "digital_point"),
                  overflow: TextOverflow.ellipsis,
                  style: LelloTextStyles.titleSmall(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              ),
              _buildBody(sessionBloc, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(SessionBloc sessionBloc, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [SizedBox(height: Dimens.spacing), _buildDashboard()],
    );
  }

  Widget _buildDashboard() {
    return StreamBuilder<List<CircuitItemRule>>(
        stream: circuitBreakController.ruleStream.stream,
        builder: (context, snapshot) {
          List<HomeItemEnum> verifyCards = [];
          if (HomeItemEnum.registerDigitalPoint.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.registerDigitalPoint);
          }
          if (HomeItemEnum.timeSheet.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.timeSheet);
          }
          if (HomeItemEnum.proof.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.proof);
          }
          if (HomeItemEnum.sickNote.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.sickNote);
          }

          return GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            childAspectRatio: (MediaQuery.of(context).size.width / 2.4) / 100,
            children: verifyCards.map(
              (e) {
                var reference = "";
                var currentState = sessionBloc.state;
                if (currentState is SessionLoadedState) {
                  reference = currentState.session.condominiumReference;
                }
                return CircuitBreakerWidget(
                  appContainer: ApplicationContainer.instance(),
                  reference: reference,
                  applicationRbac: e.getCircuitBreakRbacString,
                  rbacEnabled: e.checkRbac(sessionBloc),
                  child: HomeDashboardItem(
                    homeItem: e,
                  ),
                );
              },
            ).toList(),
          );
        });
  }
}
