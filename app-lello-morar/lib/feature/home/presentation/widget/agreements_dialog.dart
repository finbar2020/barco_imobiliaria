import 'dart:convert';

import 'package:essentials/analytics/events/analytics_events_owner.dart';
import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/analytics/analytics_log_events.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/stores/remote_config_store.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import '../../../agreements/domain/entity/agreement_all_info.dart';
import '../../../agreements/domain/use_case/get_all_info/get_all_info.dart';
import '../../../agreements/presentation/bloc/agreements_bloc.dart';

class AgreementsDialog {
  static String _key = "AGREEMENTS_DIALOG_DATE_CHECK";
  static AgreementAllInfo? agreementsInfo;

  static Future<bool> canShowAgreementsDialog() async {
    final remoteStore =
        ApplicationContainer.instance().resolve<RemoteConfigStore>();
    final sessionBloc = ApplicationContainer.instance().resolve<SessionBloc>();
    final getAvailableUseCase =
        ApplicationContainer.instance().resolve<GetAvailableUseCase>();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (!sessionBloc.checkRback(ApplicationRbac.morarAcordos)) {
      return false;
    }

    if (!sessionBloc.checkConfig("agreement_reference")) {
      return false;
    }

    bool isFirstTime = false;
    String? date = prefs.getString(_key);
    int agreementsDialogShowInterval = _getAgreementsDialogShowInterval(
        remoteConfig: remoteStore.remoteConfig);
    if (date == null || date.isEmpty) {
      await _setDate();
      isFirstTime = true;
    }
    date = prefs.getString(_key);
    final hasValidDate = _checkDateInterval(
      date: date ?? DateTime.now().toString(),
      agreementsDialogShowInterval: agreementsDialogShowInterval,
    );
    if (hasValidDate || isFirstTime) {
      final result = await getAvailableUseCase(
        GetAvailableParams(
          condoId: sessionBloc.state.session!.condominium!.id!,
          unitTitle: sessionBloc.state.session!.unity!.title!,
          onlyQuoteAndRule: true,
        ),
      );
      return result.fold(
        (failure) => false,
        (info) {
          agreementsInfo = info;
          if (agreementsInfo != null && agreementsInfo!.quotes.isNotEmpty) {
            return true;
          }
          return false;
        },
      );
    }
    return false;
  }

  static bool _checkDateInterval({
    required String date,
    required int agreementsDialogShowInterval,
  }) {
    try {
      int difference =
          DateTime.now().difference(DateTime.parse(date)).inMilliseconds;
      if (difference >= agreementsDialogShowInterval) {
        _setDate();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<void> _setDate() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, DateTime.now().toString());
  }

  static int _getAgreementsDialogShowInterval({
    required FirebaseRemoteConfig? remoteConfig,
  }) {
    //a week
    int defaultValue = 604800000;
    try {
      if (remoteConfig == null) {
        return defaultValue;
      }
      int agreementsDialogShowInterval = jsonDecode(remoteConfig
          .getString(CustomFirebaseRemoteConfig.agreementsDialogShowInterval));
      return agreementsDialogShowInterval;
    } catch (e) {
      return defaultValue;
    }
  }

  static Future<void> show({
    required BuildContext context,
    Function? dismissAction,
  }) async {
    try {
      return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) =>
            AgreementsDialogWidget(agreementsInfo: agreementsInfo),
      );
    } catch (e) {
      return;
    }
  }
}

class AgreementsDialogWidget extends StatelessWidget {
  final AgreementAllInfo? agreementsInfo;
  const AgreementsDialogWidget({
    Key? key,
    required this.agreementsInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final agreementsBloc =
        ApplicationContainer.instance().resolve<AgreementsBloc>();
    final SessionBloc sessionBloc = BlocProvider.of(context);
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, false);
        return false;
      },
      child: Dialog(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: Dimens.spacingLarge,
            horizontal: Dimens.spacingLarge,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SvgPicture.asset("assets/ic_agreements.svg",
                    color: Colors.black, height: 20),
              ),
              SizedBox(height: Dimens.spacing),
              Text(
                getString(context, "agreements_dialog_title"),
                textAlign: TextAlign.center,
                style: LelloTextStyles.titleSmall(theme)!.copyWith(
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
                    getString(
                      context,
                      "agreements_dialog_description",
                    ),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  ),
                  SizedBox(height: Dimens.spacingMedium),
                  Text(
                    getString(context, "agreements_dialog_bottom_text"),
                    textAlign: TextAlign.center,
                    style: LelloTextStyles.subtitle(theme)?.copyWith(
                      color: LelloTheme.palleteOf(theme).textLight(),
                    ),
                  )
                ],
              ),
              SizedBox(height: Dimens.spacingLarge),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context, false);
                      OwnerAnalyticsLogEvents.logEvent(
                        event: AnalyticsEventsOwner
                            .comodidadesRecusarAcessoViaDialog(),
                        userId: sessionBloc.state.session?.me?.id ?? "",
                        unitValue: sessionBloc.state.session!.unity?.title
                                ?.toString() ??
                            "",
                        referenceValue: sessionBloc
                                .state.session!.condominium?.reference
                                ?.toString() ??
                            "",
                      );
                    },
                    child: Text(
                      getString(context, "later").toUpperCase(),
                      style: LelloTextStyles.bodyBold(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).text(),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      agreementsBloc.quotasFromParam = agreementsInfo?.quotes;
                      agreementsBloc.ruleFromParam = agreementsInfo?.rule;
                      agreementsBloc.getQuotaAvailable();
                      Navigator.popAndPushNamed(
                        context,
                        ApplicationRoute.agreements,
                        result: true,
                      );
                      OwnerAnalyticsLogEvents.logEvent(
                        event: AnalyticsEventsOwner
                            .acordosAcessarCotasDisponiveis(),
                        userId: sessionBloc.state.session?.me?.id ?? "",
                        unitValue: sessionBloc.state.session!.unity?.title
                                ?.toString() ??
                            "",
                        referenceValue: sessionBloc
                                .state.session!.condominium?.reference
                                ?.toString() ??
                            "",
                      );
                    },
                    child: Text(
                      getString(context, "letsgo").toUpperCase(),
                      style: LelloTextStyles.bodyBold(theme)!.copyWith(
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
}
