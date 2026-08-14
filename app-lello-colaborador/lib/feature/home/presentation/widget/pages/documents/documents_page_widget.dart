import 'package:colaborador/core/dependency/application_container.dart';
import 'package:colaborador/feature/home/domain/entity/home_item_enum.dart';
import 'package:colaborador/feature/home/presentation/widget/home_dashboard_item.dart';
import 'package:colaborador/feature/home/presentation/widget/pages/home_page/widgets/home_request_digital_timesheet_utils.dart';
import 'package:colaborador/feature/me/domain/entity/digital_timesheet_status_enum.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_state.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:shared_features/core/circuit_breaker/models/circuit_item_rule.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class DocumentsPageWidget extends StatefulWidget {
  const DocumentsPageWidget({Key? key}) : super(key: key);

  @override
  State<DocumentsPageWidget> createState() => _DocumentsPageWidgetState();
}

class _DocumentsPageWidgetState extends State<DocumentsPageWidget> {
  DigitalTimesheetStatusEnum statusEnum = DigitalTimesheetStatusEnum.declined;
  final SessionBloc sessionBloc =
      ApplicationContainer.instance().resolve<SessionBloc>();

  @override
  void initState() {
    super.initState();
    statusEnum = sessionBloc.getSession!.condominium.digitalTimesheetStatus;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      HomeRequestsDigitalTimesheetUtils.show(context, statusEnum, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  getString(context, "my_documents"),
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
          if (HomeItemEnum.payStub.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.payStub);
          }
          if (HomeItemEnum.vacation.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.vacation);
          }
          if (HomeItemEnum.incomeReport.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.incomeReport);
          }
          if (HomeItemEnum.benefits.checkVisible(sessionBloc)) {
            verifyCards.add(HomeItemEnum.benefits);
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
