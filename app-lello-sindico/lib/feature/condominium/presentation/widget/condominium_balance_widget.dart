import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_bloc.dart';
import 'package:lello/feature/condominium/presentation/bloc/condominium_balance/condominium_balance_state.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class CondominiumBalanceWidget extends StatefulWidget {
  final String? condominiumId;

  const CondominiumBalanceWidget({super.key, this.condominiumId});

  @override
  _CondominiumBalanceWidgetState createState() =>
      _CondominiumBalanceWidgetState();
}

class _CondominiumBalanceWidgetState extends State<CondominiumBalanceWidget> {
  final CondominiumBalanceBloc bloc = ApplicationContainer.instance().resolve();

  @override
  Widget build(BuildContext context) {
    final theme = LelloTheme.dark;
    var themeContext = Theme.of(context);
    SessionBloc sessionBloc = BlocProvider.of(context);
    const radius = 8.0;
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
      builder: (context, state) => Container(
        decoration: ShapeDecoration(
            color: LelloTheme.palleteOf(theme).greyDarker(),
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(radius),
                    bottomLeft: Radius.circular(radius)))),
        child: _buildContent(context, theme, state, themeContext, sessionBloc),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    ThemeData theme,
    CondominiumBalanceState state,
    ThemeData themeContext,
    SessionBloc sessionBloc,
  ) {
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
      child: CircuitBreakerWidget(
        appContainer: ApplicationContainer.instance(),
        reference:
            sessionBloc.state.session?.selectedCondominium?.reference ?? "",
        applicationRbac: ApplicationRbac.sindicoSaldoDetalhes,
        rbacEnabled:
            sessionBloc.checkRback(ApplicationRbac.sindicoSaldoDetalhes),
        child: InkWell(
          onTap: () {
            ManagerAnalyticsLogEvents.logEvent(
                event: AnalyticsEventsManager.clickSaldo(),
                referenceValue:
                    sessionBloc.state.session?.selectedCondominium?.reference ??
                        "");
            Navigator.of(context).pushNamed(ApplicationRoute.balanceDetail);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      getString(context, titleKey),
                      style: LelloTextStyles.bodyBold(theme),
                    ),
                  ),
                  (state is CondominiumBalanceLoadedState && state.isUpdating)
                      ? Text(
                          getString(context, "condominium_balance_updating"),
                          style: LelloTextStyles.bodyBold(theme),
                        )
                      : Container(),
                  SizedBox(width: Dimens.spacingSmall),
                  (state is CondominiumBalanceLoadedState && state.isUpdating)
                      ? SizedBox(
                          height: Dimens.spacingSmall,
                          width: Dimens.spacingSmall,
                          child: CircularProgressIndicator(
                            color: themeContext.primaryColor,
                          ))
                      : Container()
                ],
              ),
              SizedBox(height: Dimens.spacingSmall),
              CircuitBreakerWidget(
                appContainer: ApplicationContainer.instance(),
                reference:
                    sessionBloc.state.session?.selectedCondominium?.reference ??
                        "",
                applicationRbac: ApplicationRbac.sindicoSaldoDetalhes,
                rbacEnabled: sessionBloc
                    .checkRback(ApplicationRbac.sindicoSaldoDetalhes),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          currency,
                          style: style,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/ic_arrow_red.svg",
                          width: 22,
                          color: themeContext.primaryColor,
                        ),
                        SizedBox(width: Dimens.spacingSmall),
                        Text(getString(context, "condominium_balance_details"),
                            style: LelloTextStyles.bodyBold(theme)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
