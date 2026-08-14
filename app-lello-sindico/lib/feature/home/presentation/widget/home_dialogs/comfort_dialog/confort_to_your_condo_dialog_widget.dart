import 'package:essentials/analytics/events/analytics_events_manager.dart';
import 'package:essentials/enum/app_origin_enum.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:lello/core/analytics/analytics_log_events.dart';
import 'package:lello/core/dependency/application_container.dart';
import 'package:lello/core/navigation/application_rbac.dart';
import 'package:lello/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/controller/circuit_breaker_controller.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/comfort_page_origin_enum.dart';
import 'package:shared_features/feature/comfort/presentation/comfort_partners/pages/comfort_page.dart';
import 'package:shared_features/feature/notifications/domain/entities/features_routes_enum.dart';
import 'package:shared_features/shared_features.dart';

class ComfortToYourCondoDialogWidget extends StatelessWidget {
  const ComfortToYourCondoDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final CircuitBreakerController circuitBreakController =
        ApplicationContainer.instance().resolve();
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.all(Dimens.spacingMedium),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset("assets/ic_comfort_to_your_condo.svg"),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "comfort_to_your_condo_dialog_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitle(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.spacing),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: getString(context,
                              "comfort_to_your_condo_dialog_description_1"),
                          style: LelloTextStyles.body(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                        TextSpan(
                          text: getString(context,
                              "comfort_to_your_condo_dialog_description_2"),
                          style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                        TextSpan(
                          text: getString(context,
                              "comfort_to_your_condo_dialog_description_3"),
                          style: LelloTextStyles.body(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                        TextSpan(
                          text: getString(context,
                              "comfort_to_your_condo_dialog_description_4"),
                          style: LelloTextStyles.body(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                        TextSpan(
                          text: getString(
                              context, "comfort_to_your_condo_concierge"),
                          style: LelloTextStyles.bodyBold(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                        TextSpan(
                          text: getString(context,
                              "comfort_to_your_condo_dialog_description_5"),
                          style: LelloTextStyles.body(theme)?.copyWith(
                              color: LelloTheme.palleteOf(theme).textLight()),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      ManagerAnalyticsLogEvents.logEvent(
                          event: AnalyticsEventsManager
                              .comodidadesRecusarAcessoDialog(),
                          userId: sessionBloc.state.session?.me?.id ?? "",
                          userType: await _getUserType,
                          referenceValue: sessionBloc.state.session
                                  ?.selectedCondominium?.reference ??
                              "");
                    },
                    child: Text(
                      getString(context,
                              "comfort_to_your_condo_dialog_button_later")
                          .toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      Navigator.pushNamed(
                        context,
                        SharedApplicationRoute.comfort,
                        arguments: ComfortPageArgs(
                          appOriginEnum: AppOriginEnum.manager,
                          reference: sessionBloc.state.session
                                  ?.selectedCondominium?.reference ??
                              "",
                          accessRouteOrigin: ComfortPageOriginEnum.toYourCondoDialog,
                          comfortNotificationContext: "PARA_SEU_CONDOMINIO",
                          route: FeaturesRoutesEnum.COMODIDADES_CATEGORIA,
                          checkFavorites: (circuitBreakController.checkVisible(
                              applicationRbac:
                                  ApplicationRbac.sindicoComodidadesFavoritos,
                              reference: sessionBloc.state.session
                                      ?.selectedCondominium?.reference ??
                                  "")),
                          checkOffers: (circuitBreakController.checkVisible(
                              applicationRbac:
                                  ApplicationRbac.sindicoComodidadesOfertas,
                              reference: sessionBloc.state.session
                                      ?.selectedCondominium?.reference ??
                                  "")),
                          checkRequest: (circuitBreakController.checkVisible(
                              applicationRbac: ApplicationRbac
                                  .sindicoComodidadesSolicitacoes,
                              reference: sessionBloc.state.session
                                      ?.selectedCondominium?.reference ??
                                  "")),
                          checkYourCondo: (circuitBreakController.checkVisible(
                              applicationRbac: ApplicationRbac
                                  .sindicoComodidadesSeuCondominio,
                              reference: sessionBloc.state.session
                                      ?.selectedCondominium?.reference ??
                                  "")),
                        ),
                      );
                      ManagerAnalyticsLogEvents.logEvent(
                          event: AnalyticsEventsManager
                              .comodidadesVamosLaDialog(),
                          userId: sessionBloc.state.session?.me?.id ?? "",
                          userType: await _getUserType,
                          referenceValue: sessionBloc.state.session
                                  ?.selectedCondominium?.reference ??
                              "");
                    },
                    child: Text(
                      getString(
                              context, "comfort_to_your_condo_dialog_button_go")
                          .toUpperCase(),
                      style: LelloTextStyles.subBody(theme)!.copyWith(
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<AccessToken?> get _getAccessToken async {
    GetToken getToken = ApplicationContainer.instance().resolve<GetToken>();
    final token = await getToken.call(GetTokenParams(role: null));
    return token.getOrElse(() => null);
  }

  Future<String> get _getUserType async {
    final token = await _getAccessToken;
    return token?.selectedRole ?? "";
  }
}
