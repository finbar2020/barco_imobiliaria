import 'package:essentials/analytics/analytics_log_events.dart';
import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/core/navigation/application_route.dart';
import 'package:lello/feature/payment/domain/entity/payment_screens.dart';
import 'package:lello/feature/payment/presentation/list/page/payment_list_page.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class PaymentMainPageArgs {
  String? paymentNotificationContext;
  FeaturesRoutesEnum? route;
  PaymentMainPageArgs({
    this.paymentNotificationContext,
    this.route,
  });
}

// ignore: must_be_immutable
class PaymentMainPage extends StatelessWidget {
  bool redirect = false;

  PaymentMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    PaymentMainPageArgs? arguments =
        ModalRoute.of(context)!.settings.arguments as PaymentMainPageArgs?;
    return Theme(
      data: theme,
      child: Scaffold(
        appBar: PrimaryAppBar(
            theme: theme, title: getString(context, "lello_hub_outcome")),
        body: _buildList(context, theme, arguments),
      ),
    );
  }

  Future<AccessToken?> _getAccessToken(GetToken getToken) async {
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> _getUserType(GetToken getToken) async {
    final token = await _getAccessToken(getToken);
    return token?.selectedRole ?? "";
  }

  Widget _buildList(
      BuildContext context, ThemeData theme, PaymentMainPageArgs? arguments) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final GetToken getToken = ApplicationContainer.instance().resolve();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      if (arguments?.route != null && redirect == false) {
        redirect = true;
        if (arguments?.route == FeaturesRoutesEnum.DESPESAS_PAGAMENTO_NOVO) {
          Navigator.of(context).pushNamed(ApplicationRoute.paymentList);
        } else {
          Navigator.of(context).pushNamed(ApplicationRoute.paymentPendency);
        }
      }
    });
    return ListView(
      children: [
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoDespesasEnviarMalote,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.sindicoDespesasEnviarMalote),
          child: Column(
            children: [
              _buildListItem(getString(context, "payments_send_payment"),
                  "assets/ic_send_payment.svg", theme, onTap: () async {
                String reference = sessionBloc
                        .state.session!.selectedCondominium?.reference
                        .toString() ??
                    "";

                AnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.enviarPagamentoAcessar(),
                    userType: await _getUserType(getToken),
                    referenceValue: reference,
                    userId: sessionBloc.state.session?.me?.id ?? "",
                    appOrigin: AppOriginEnum.manager,
                    otherParameters: {
                      "tela": enumToString(PaymentScreens.paymentMainPage)!,
                    });

                // ManagerAnalyticsLogEvents.logEvent(
                //     event: AnalyticsEventsManager.enviarPagamentoAcessar(),
                //     referenceValue: reference);

                await Navigator.of(context)
                    .pushNamed(ApplicationRoute.paymentSendDocuments);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoDespesasHistoricoPagamento,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.sindicoDespesasHistoricoPagamento),
          child: Column(
            children: [
              _buildListItem(getString(context, "payments_history"),
                  "assets/ic_payments_history.svg", theme, onTap: () async {
                String reference = sessionBloc
                        .state.session!.selectedCondominium?.reference
                        .toString() ??
                    "";

                AnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.historicoPagamentoAcessar(),
                    userType: await _getUserType(getToken),
                    referenceValue: reference,
                    userId: sessionBloc.state.session?.me?.id ?? "",
                    appOrigin: AppOriginEnum.manager,
                    otherParameters: {
                      "tela": enumToString(PaymentScreens.paymentMainPage)!,
                    });

                // ManagerAnalyticsLogEvents.logEvent(
                //     event: AnalyticsEventsManager.historicoPagamentoAcessar(),
                //     referenceValue: reference);

                await Navigator.of(context)
                    .pushNamed(ApplicationRoute.paymentHistory);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoDespesasConsultarPagamento,
          rbacEnabled: sessionBloc
              .checkRback(ApplicationRbac.sindicoDespesasConsultarPagamento),
          child: Column(
            children: [
              _buildListItem(getString(context, "payments_view_payment"),
                  "assets/ic_view_payments.svg", theme, onTap: () {
                ManagerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsManager.enviarPagamentoFinalizado(),
                    referenceValue: sessionBloc
                            .state.session?.selectedCondominium?.reference ??
                        "");
                Navigator.of(context).pushNamed(ApplicationRoute.paymentList);
              }),
              const Divider(),
            ],
          ),
        ),
        CircuitBreakerWidget(
          appContainer: ApplicationContainer.instance(),
          reference:
              sessionBloc.state.session?.selectedCondominium?.reference ?? "",
          applicationRbac: ApplicationRbac.sindicoDespesasAprovacaoPendente,
          rbacEnabled: sessionBloc.checkRback(
                  ApplicationRbac.sindicoDespesasAprovacaoPendente) ||
              sessionBloc.checkRback(
                  ApplicationRbac.sindicoDespesasAprovacaoPendenteWrite),
          child: Column(
            children: [
              _buildListItem(
                getString(context, "payments_pending_payment_approval"),
                "assets/ic_pending_payments.svg",
                theme,
                onTap: () async {
                  String reference = sessionBloc
                      .state.session!.selectedCondominium?.reference
                      .toString() ??
                      "";

                  AnalyticsLogEvents.logEvent(
                      event: AnalyticsEventsManager
                          .aprovacaoPendenteAcessar(),
                      userType: await _getUserType(getToken),
                      referenceValue: reference,
                      userId: sessionBloc.state.session?.me?.id ?? "",
                      appOrigin: AppOriginEnum.manager,
                      otherParameters: {
                        "tela":
                        enumToString(PaymentScreens.paymentMainPage)!,
                      });

                  Navigator.of(context)
                      .pushNamed(ApplicationRoute.paymentPendency);
                },
              ),
              const Divider(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(String title, String asset, ThemeData theme,
      {VoidCallback? onTap}) {
    return Opacity(
      opacity: onTap == null ? 0.5 : 1,
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.only(
            left: Dimens.spacingLarge,
            right: Dimens.spacingLarge,
            top: Dimens.spacingSmall,
            bottom: Dimens.spacingSmall),
        leading: SvgPicture.asset(asset, width: 24),
        title: Text(
          title,
          style: LelloTextStyles.bodyBold(theme),
        ),
        trailing: onTap == null
            ? SvgPicture.asset("assets/ic_coming_soon.svg")
            : null,
      ),
    );
  }
}
