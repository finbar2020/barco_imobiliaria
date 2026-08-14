import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_bloc.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_state.dart';
import 'package:lello/feature/home/presentation/controllers/home_analytics_timer_controller.dart';
import 'package:lello/feature/me/domain/entity/me.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class CondominiumBalanceWidgetC extends StatefulWidget {
  final String? condominiumId;

  const CondominiumBalanceWidgetC({Key? key, this.condominiumId})
      : super(key: key);

  @override
  _CondominiumBalanceWidgetCState createState() =>
      _CondominiumBalanceWidgetCState();
}

class _CondominiumBalanceWidgetCState extends State<CondominiumBalanceWidgetC> {
  final CondominiumBalanceBloc bloc = ApplicationContainer.instance().resolve();

  bool showBalance = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final SessionBloc sessionBloc = BlocProvider.of(context);
    return BlocConsumer<CondominiumBalanceBloc, CondominiumBalanceState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is CondominiumBalanceLoadedState) {
          if (state.remoteFail) {
            Flushbar(
              message: getString(context, "condominium_balance_failed"),
              duration: const Duration(seconds: 4),
            ).show(context);
          }
        }
      },
      builder: (context, state) =>
          _buildContent(context, theme, state, sessionBloc),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    CondominiumBalanceState state,
    SessionBloc sessionBloc,
  ) {
    HomeAnalyticsTimerController homeAnalyticsTimerController =
        ApplicationContainer.instance().resolve();
    final formatCurrency = NumberFormat.currency(symbol: "R\$");
    final titleKey = state is CondominiumBalanceLoadingState
        ? "please_wait"
        : state is CondominiumBalanceFailedState
            ? "error"
            : "condominium_balance_title";
    final currency = state is CondominiumBalanceLoadedState
        ? formatCurrency.format(state.balance.balance)
        : state is CondominiumBalanceFailedState
            ? getString(context, "condominium_balance_failed")
            : getString(context, "loading");
    final style = state is CondominiumBalanceLoadedState
        ? LelloTextStyles.headline(theme)
        : LelloTextStyles.subBody(theme);
    return Padding(
      padding: EdgeInsets.all(Dimens.spacingMedium),
      child: Column(
        children: [
          Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _getGreetings(context, sessionBloc.state.session?.me),
                style: LelloTextStyles.title(theme),
              )),
          SizedBox(height: Dimens.spacing),
          Container(
            padding: EdgeInsets.all(Dimens.spacing),
            decoration: const BoxDecoration(
                color: Color(0xFFE9E6E6),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    (state is CondominiumBalanceLoadedState && state.isUpdating)
                        ? Text(
                            getString(context, "condominium_balance_updating"),
                            style: LelloTextStyles.bodyBold(theme))
                        : Container(),
                    SizedBox(width: Dimens.spacingSmall),
                    (state is CondominiumBalanceLoadedState && state.isUpdating)
                        ? SizedBox(
                            height: Dimens.spacingSmall,
                            width: Dimens.spacingSmall,
                            child: CircularProgressIndicator(
                              color: theme.primaryColor,
                            ))
                        : Container()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          showBalance ? currency : "R\$ *****",
                          style: style,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          showBalance = !showBalance;
                        });
                        ManagerAnalyticsLogEvents.logEvent(
                            event: AnalyticsEventsManager.clickMascaraSaldo(),
                            referenceValue: sessionBloc.state.session
                                    ?.selectedCondominium?.reference ??
                                "");
                      },
                      child: Icon(
                        showBalance
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        size: 40.0,
                        color: const Color(0xFF626262),
                      ),
                    ),
                  ],
                ),
                Text(getString(context, titleKey),
                    style: LelloTextStyles.bodyBold(theme)!
                        .copyWith(color: const Color(0xFF626262))),
              ],
            ),
          ),
          SizedBox(height: Dimens.spacing),
          CircuitBreakerWidget(
            appContainer: ApplicationContainer.instance(),
            reference:
                sessionBloc.state.session?.selectedCondominium?.reference ?? "",
            applicationRbac: ApplicationRbac.sindicoSaldoDetalhes,
            rbacEnabled:
                sessionBloc.checkRback(ApplicationRbac.sindicoSaldoDetalhes),
            child: InkWell(
              onTap: () {
                homeAnalyticsTimerController.sindicoHomeTimerStop();
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.clickSaldo(),
                    referenceValue: sessionBloc
                            .state.session?.selectedCondominium?.reference ??
                        "");
                Navigator.of(context)
                    .pushNamed(ApplicationRoute.balanceDetail)
                    .then((_) =>
                        homeAnalyticsTimerController.sindicoHomeTimerStart(1));
              },
              child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    getString(context, "payroll_details"),
                    style: LelloTextStyles.body(theme)!
                        .copyWith(color: theme.primaryColor),
                  )),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreetings(BuildContext context, Me? me) {
    var firstName = me != null && me.name?.split(" ")[0] != null
        ? me.name?.split(" ")[0]
        : "...";
    var greeting =
        "${getString(context, "hi")} ${firstName![0].toUpperCase()}${firstName.substring(1).toLowerCase()}";
    return greeting;
  }
}
