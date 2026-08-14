import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/core/navigation/application_rbac.dart';
import 'package:morar/core/navigation/application_route.dart';
import 'package:morar/core/widgets/custom_app_bar.dart';
import 'package:morar/feature/preferences/presentation/pages/notification/pages/notifications_preferences.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/core/circuit_breaker/widget/circuit_breaker_widget.dart';

class PreferencesMenuPage extends StatefulWidget {
  const PreferencesMenuPage({
    Key? key,
  }) : super(key: key);

  @override
  _PreferencesMenuPageState createState() => _PreferencesMenuPageState();
}

class _PreferencesMenuPageState extends State<PreferencesMenuPage> {
  late SessionBloc sessionBloc;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    sessionBloc = BlocProvider.of(context);
    return Scaffold(
      appBar: CustomAppBar(title: "preferences"),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            color: LelloTheme.palleteOf(theme).backgroundDark(),
            width: double.infinity,
            height: Dimens.spacingLarge,
            child: Center(
              child: Text(
                '${sessionBloc.state.session?.condominium?.name ?? ''} - ${sessionBloc.state.session?.unity?.title ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: LelloTextStyles.body(theme)!
                    .copyWith(color: LelloTheme.palleteOf(theme).hubText()),
              ),
            ),
          ),
          Column(
            children: [
              CircuitBreakerWidget(
                reference:
                    sessionBloc.state.session?.condominium?.reference ?? "",
                appContainer: ApplicationContainer.instance(),
                applicationRbac: ApplicationRbac.morarPreferenciasPapelzero,
                rbacEnabled: sessionBloc
                    .checkRback(ApplicationRbac.morarPreferenciasPapelzero),
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(
                        context, ApplicationRoute.preferencesZeroPaper);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50.0,
                          child: SvgPicture.asset(
                              "assets/ic_preferences_zero_paper.svg"),
                        ),
                        SizedBox(width: Dimens.spacing),
                        Text(
                          getString(context, "preferences_zero_paper_campaign"),
                          style: LelloTextStyles.subtitle(theme)!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF494949),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (sessionBloc
                  .checkRback(ApplicationRbac.morarPreferenciasNotificacoes))
                Divider(),
              CircuitBreakerWidget(
                reference:
                    sessionBloc.state.session?.condominium?.reference ?? "",
                appContainer: ApplicationContainer.instance(),
                applicationRbac: ApplicationRbac.morarPreferenciasNotificacoes,
                rbacEnabled: sessionBloc
                    .checkRback(ApplicationRbac.morarPreferenciasNotificacoes),
                child: InkWell(
                  onTap: () {
                    PreferencesNotificationPage.show(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 50.0,
                          child: SvgPicture.asset(
                              "assets/ic_preferences_notification.svg"),
                        ),
                        SizedBox(width: Dimens.spacing),
                        Text(
                          getString(context, "notification"),
                          style: LelloTextStyles.subtitle(theme)!.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF494949),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: sessionBloc.iSPreferencesPersonalizationActive,
                child: Column(
                  children: [
                    Divider(),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(
                            context, ApplicationRoute.preferencesHome);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 50.0,
                              child: Icon(
                                Icons.star_border_outlined,
                                color: Color(0xFF494949),
                                size: 30.0,
                              ),
                            ),
                            SizedBox(width: Dimens.spacing),
                            Text(
                              getString(context, "preferences_cards_tile"),
                              style: LelloTextStyles.subtitle(theme)!.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF494949),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
