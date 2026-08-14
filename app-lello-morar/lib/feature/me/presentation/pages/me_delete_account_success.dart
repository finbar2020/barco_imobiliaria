import 'package:essentials/essentials.dart';
import 'package:flutter/material.dart';
import 'package:morar/core/dependency/application_container.dart';
import 'package:morar/feature/me/presentation/controllers/me_controller.dart';
import 'package:morar/feature/session/presentation/bloc/session_bloc.dart';
import 'package:shared_features/feature/authentication/presentation/store/authentication_store.dart';

class MeDeleteAccountSuccessPage extends StatelessWidget {
  final MeController controller;

  const MeDeleteAccountSuccessPage({
    Key? key,
    required this.controller,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AuthenticationStore authenticationStore =
        ApplicationContainer.instance().resolve();
    SessionBloc sessionBloc = BlocProvider.of(context);

    return Theme(
      data: theme,
      child: WillPopScope(
        onWillPop: () => _onWillPop(context, sessionBloc, authenticationStore),
        child: Scaffold(
          backgroundColor: LelloTheme.palleteOf(theme).success(),
          body: Padding(
            padding: EdgeInsets.all(Dimens.spacingLarge),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset("assets/ic_success.svg",
                      width: 92, height: 92),
                  SizedBox(height: Dimens.spacingLarge),
                  Text("Conta excluída com sucesso.",
                      textAlign: TextAlign.center,
                      style: LelloTextStyles.headline(theme)!.copyWith(
                        color: LelloTheme.palleteOf(theme).customColor(),
                      )),
                ],
              ),
            ),
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Container(
              height: 54.0,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: LelloTheme.palleteOf(theme).customColor(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString(context, "conclude"),
                  style: LelloTextStyles.button(theme)!.copyWith(
                    color: LelloTheme.palleteOf(theme).text(),
                  ),
                ),
                onPressed: () {
                  _onWillPop(context, sessionBloc, authenticationStore);
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop(
    BuildContext context,
    SessionBloc sessionBloc,
    AuthenticationStore authStore,
  ) async {
    Navigator.pop(context);
    controller.logOutEvent();
    sessionBloc.logout();
    authStore.logout();
    return true;
  }
}
