import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/launcher_url/launcher_url.dart';

class RentSellDialogWidget extends StatelessWidget {
  const RentSellDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final SessionBloc sessionBloc = BlocProvider.of(context);
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
                child: SvgPicture.asset(
                  "assets/ic_rent_sell_dialog.svg",
                  height: 50.0,
                ),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "rent_sell_dialog_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.subtitleBold(theme)!.copyWith(
                  color: LelloTheme.palleteOf(theme).text(),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: Dimens.spacing),
                  Text(
                    getString(context, "rent_sell_dialog_text_description"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.body(theme)!.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimens.spacingMedium),
              PrimaryButton(
                buttonColor: theme.primaryColor,
                onPressed: () {
                  var restSellConfig = sessionBloc.getRemoteConfigForLinks(
                      CustomFirebaseRemoteConfig.rentSellLink);
                  Navigator.pop(context);
                 UrlLauncherNative.openUrl(
                      restSellConfig?.link ??
                          "https://www.lelloimoveis.com.br/anunciar-imovel",
                      );
                  OwnerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsOwner.lelloImoveisAcessar(),
                    userId: sessionBloc.state.session?.me?.id ?? "",
                    unitValue:
                        sessionBloc.state.session!.unity?.title?.toString() ??
                            "",
                    referenceValue: sessionBloc
                            .state.session!.condominium?.reference
                            ?.toString() ??
                        "",
                  );
                },
                text: getString(context, "rent_sell_dialog_check_out"),
              ),
              SizedBox(height: Dimens.spacingMedium),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  OwnerAnalyticsLogEvents.logEvent(
                    event: AnalyticsEventsOwner.lelloImoveisRecusarAcesso(),
                    userId: sessionBloc.state.session?.me?.id ?? "",
                    unitValue:
                        sessionBloc.state.session!.unity?.title?.toString() ??
                            "",
                    referenceValue: sessionBloc
                            .state.session!.condominium?.reference
                            ?.toString() ??
                        "",
                  );
                },
                child: Text(
                  getString(context, "later"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
