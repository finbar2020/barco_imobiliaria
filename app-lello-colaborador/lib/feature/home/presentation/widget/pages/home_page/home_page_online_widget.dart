// ignore_for_file: use_build_context_synchronously

import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/core/navigation/application_route.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/controllers/home_controller.dart';
import 'package:colaborador/feature/home/presentation/controllers/register_point_controller.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_digital_timesheet_utils.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class HomePageOnlineWidget extends StatefulWidget {
  final HomeController controller;
  final RegisterPointController registerController;

  const HomePageOnlineWidget({
    Key? key,
    required this.controller,
    required this.registerController,
  }) : super(key: key);

  @override
  State<HomePageOnlineWidget> createState() => _HomePageOnlineWidgetState();
}

class _HomePageOnlineWidgetState extends State<HomePageOnlineWidget> {
  DigitalTimesheetStatusEnum statusEnum = DigitalTimesheetStatusEnum.declined;
  final CircuitBreakerController circuitBreakController =
      ApplicationContainer.instance().resolve();
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();

  @override
  void initState() {
    super.initState();
    statusEnum = widget.controller.session!.condominium.digitalTimesheetStatus;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeRequestsDigitalTimesheetUtils.show(context, statusEnum, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimens.spacingSmall),
        child: Column(
          children: [
            Visibility(
              visible: widget
                  .controller.sessionBloc.iSPreferencesPersonalizationActive,
              child: Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    widget.controller.animate.value = false;
                    Navigator.pushNamed(
                        context, ApplicationRoute.preferencesHome);
                  },
                  child: ValueListenableBuilder<bool>(
                    valueListenable: widget.controller.animate,
                    builder: (BuildContext context, bool value, child) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10.0, top: 10),
                        child: AvatarGlow(
                          animate: value,
                          glowColor: value ? theme.primaryColor : Colors.white,
                          glowRadiusFactor: 0.5,
                          child: Icon(
                            Icons.star_border_outlined,
                            size: 30.0,
                            color: LelloTheme.palleteOf(theme).grey(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: Dimens.spacing),
            StreamBuilder<List<CircuitItemRule>>(
                stream: circuitBreakController.ruleStream.stream,
                builder: (context, snapshot) {
                  var verifyCards = widget.controller.mostAccessedCards
                      .where((element) => element.checkVisible(sessionBloc))
                      .toList();
                  return GridView.count(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    childAspectRatio:
                        (MediaQuery.of(context).size.width / 2.4) / 100,
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
                }),
          ],
        ),
      ),
    );
  }

  // Widget _buildUserInfo() {
  //   return Row(
  //     children: [
  //       Expanded(
  //         flex: 3,
  //         child: buildGreetings(widget.session.me),
  //       ),
  //       Expanded(
  //         flex: 1,
  //         child: GestureDetector(
  //
  //           child: const NotificationIcon(),
  //         ),
  //       )
  //     ],
  //   );
  // }

  // Widget buildGreetings(Me me) {
  //   ThemeData theme = Theme.of(context);
  //   return Padding(
  //     padding: EdgeInsets.all(Dimens.spacingSmall),
  //     child: Text(
  //       "${getString(context, 'home_page_hi')}, ${me.firstNameFormatted}!",
  //       style: LelloTextStyles.titleSmall(theme),
  //     ),
  //   );
  // }
}
