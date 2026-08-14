import 'package:colaborador/core/dependency/application_container.dart';

import 'package:colaborador/feature/authentication_tablet/presentation/bloc/authentication_tablet_bloc.dart';
import 'package:colaborador/feature/authentication_tablet/presentation/widget/login_tablet_loaded_widget.dart';
import 'package:colaborador/feature/session/presentation/bloc/session_bloc.dart';
import 'package:essentials/essentials.dart' hide Image;
import 'package:flutter/material.dart';
import 'package:shared_features/shared_features.dart';

class LoginTabletCondominiumStepWidget extends StatelessWidget {
  final String condominiumName;
  final Function(LoginTabletSteps newStep) changeStep;
  final String condoRef;
  const LoginTabletCondominiumStepWidget({
    Key? key,
    required this.condominiumName,
    required this.condoRef,
    required this.changeStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Environment env = ApplicationContainer.instance().resolve<Environment>();
    final SessionBloc sessionBloc =
        ApplicationContainer.instance().resolve<SessionBloc>();

    AuthenticationTabletBloc authenticationTabletBloc =
        ApplicationContainer.instance().resolve<AuthenticationTabletBloc>();
    var showButton = sessionBloc.showButtonNoAuthPointList(condoRef);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            "assets/condo_placeholder.png",
            fit: BoxFit.fill,
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: Dimens.spacingLarge),
          Container(
            padding: EdgeInsets.all(Dimens.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  condominiumName.toUpperCase(),
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacing),
                Text(
                  DateFormat("dd/MM/yyyy").format(DateTime.now()),
                  style: LelloTextStyles.subtitleBold(theme)?.copyWith(
                    color: LelloTheme.palleteOf(theme).hubText(),
                  ),
                ),
                SizedBox(height: Dimens.spacingLarge),
                PrimaryButton(
                    text: getString(context, "login_tablet_condo_start"),
                    onPressed: () {
                      changeStep(LoginTabletSteps.employees);
                    }),
                if (showButton) SizedBox(height: Dimens.spacing),
                if (showButton)
                  SecondaryButton(
                    text: getString(context, "login_tablet_condo_sync_view"),
                    onPressed: () {
                      changeStep(LoginTabletSteps.listOfflinePoints);
                    },
                  ),
                SizedBox(height: Dimens.spacing),
                Center(
                  child: InkWell(
                    onTap: () {
                      authenticationTabletBloc.sendNoAuthPoints(condoRef);
                    },
                    child: Padding(
                      padding: EdgeInsets.all(Dimens.spacing),
                      child:
                          Text(getString(context, "login_tablet_condo_sync")),
                    ),
                  ),
                ),
                if (!env.isProduction)
                  Center(
                    child: InkWell(
                      onTap: () {
                        _backLogin(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child:
                            Text(getString(context, "login_tablet_condo_back")),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _backLogin(BuildContext context) async {
    try {
      await TabletSessionUtils.removeIsTabletSession().then((value) =>
          Navigator.pushReplacementNamed(
              context, SharedApplicationRoute.login));
    } catch (ex) {}
  }
}
